Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXFGUjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXFGUjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936735AbXFGUjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:39:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4726 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936609AbXFGUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:39:10 -0400
Message-ID: <46686CF4.2090900@shadowen.org>
Date: Thu, 07 Jun 2007 21:39:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Bob Picco <bob.picco@hp.com>
CC: Chuck Ebbert <cebbert@redhat.com>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Bernhard Walle <bwalle@suse.de>,
       "Eric W. Biederman"@redhat.com, acme@redhat.com
Subject: Re: [BUG] sysrq-m oops
References: <1181176035.6275.13.camel@localhost.localdomain> <4668276E.4030504@redhat.com> <20070607182122.GE11999@localhost>
In-Reply-To: <20070607182122.GE11999@localhost>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Picco wrote:
> Chuck Ebbert wrote:	[Thu Jun 07 2007, 11:42:38AM EDT]
>> On 06/06/2007 08:27 PM, john stultz wrote:
>>> Hey All,
>>> 	With 2.6.21 and the current -git, we're seeing the following oops when
>>> we try sysrq-m:
>>>
>> It's here in arch/x86_64/mm/init.c::show_mem():
>>
>>         for_each_online_pgdat(pgdat) {
>>                for (i = 0; i < pgdat->node_spanned_pages; ++i) {
> This is probably with sparsemem? I'm working with acme@redhat.com to
> test a patch. Basically you need to validate the pfn because it
> could be in a hole. Most arches which support sparsemem perform this
> check.
> 
> 			if (!pfn_valid(pgdat->node_start_pfn + i))
> 				continue;
> bob

Yep you would want one of those for sure with sparsemem.

-apw
>>                         page = pfn_to_page(pgdat->node_start_pfn + i);
>>                         total++;
>>  ======>                if (PageReserved(page))
>>                                 reserved++;
>>                         else if (PageSwapCache(page))
>>                                 cached++;
>>                         else if (page_count(page))
>>                                 shared += page_count(page) - 1;
>>                }
>>         }
>>
>> page is completely bogus (it's 0x0000000003480000)
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

