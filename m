Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZHMPrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZHMPrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZHMPrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:47:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZHMPra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:47:30 -0400
Message-ID: <4A843565.3010104@redhat.com>
Date: Thu, 13 Aug 2009 11:46:45 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090806100824.GO23385@random.random> <4A7AD5DF.7090801@redhat.com> <20090807121443.5BE5.A69D9226@jp.fujitsu.com> <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com> <20090813010356.GA7619@localhost>
In-Reply-To: <20090813010356.GA7619@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> On Wed, Aug 12, 2009 at 10:31:41PM +0800, Rik van Riel wrote:

>> For zones it is a fixed value, which is available in
>> /proc/zoneinfo
> 
> On my 64bit desktop with 4GB memory:
> 
>         DMA     inactive_ratio:    1
>         DMA32   inactive_ratio:    4
>         Normal  inactive_ratio:    1
> 
> The biggest zone DMA32 has inactive_ratio=4. But I guess the
> referenced bit should not be ignored on this typical desktop
> configuration?

We need to ignore the referenced bit on active anon pages
on very large systems, but it could indeed be helpful to
respect the referenced bit on smaller systems.

I have no idea where the cut-off between them would be.

Maybe at inactive_ratio <= 4 ?

-- 
All rights reversed.
