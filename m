Return-Path: <linux-kernel-owner+w=401wt.eu-S1763296AbXFGQck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763296AbXFGQck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXFGQcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:32:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXFGQcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:32:32 -0400
Message-ID: <4668276E.4030504@redhat.com>
Date: Thu, 07 Jun 2007 11:42:38 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Sripathi Kodi <sripathik@in.ibm.com>,
       Bernhard Walle <bwalle@suse.de>, "Eric W. Biederman"@redhat.com
Subject: Re: [BUG] sysrq-m oops
References: <1181176035.6275.13.camel@localhost.localdomain>
In-Reply-To: <1181176035.6275.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2007 08:27 PM, john stultz wrote:
> Hey All,
> 	With 2.6.21 and the current -git, we're seeing the following oops when
> we try sysrq-m:
> 

It's here in arch/x86_64/mm/init.c::show_mem():

        for_each_online_pgdat(pgdat) {
               for (i = 0; i < pgdat->node_spanned_pages; ++i) {
                        page = pfn_to_page(pgdat->node_start_pfn + i);
                        total++;
 ======>                if (PageReserved(page))
                                reserved++;
                        else if (PageSwapCache(page))
                                cached++;
                        else if (page_count(page))
                                shared += page_count(page) - 1;
               }
        }

page is completely bogus (it's 0x0000000003480000)
