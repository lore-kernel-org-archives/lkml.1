Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbZCDLLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbZCDLLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZCDLLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:11:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:20400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZCDLLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:11:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,300,1233561600"; 
   d="scan'208";a="116603204"
Date: Wed, 4 Mar 2009 19:05:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Markus <M4rkusXXL@web.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: drop_caches ...
Message-ID: <20090304110558.GA17014@localhost>
References: <200903041057.34072.M4rkusXXL@web.de> <20090304100420.GA16859@localhost> <200903041132.04451.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903041132.04451.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 12:32:02PM +0200, Markus wrote:
> Hello Fengguang!
> 
> > Hi Markus,
> > 
> > On Wed, Mar 04, 2009 at 10:57:33AM +0100, Markus wrote:
> > > Hello!
> > > 
> > > I have a small problem. Maybe its just a misunderstanding but I cant 
> > > solve it.
> > > 
> > > I think that writing "3" to drop_caches should drop all buffers and 
> > > caches which are already written. So its recommended to put a "sync" 
> > > infront of it.
> > > So I did "free -m ; sync ; echo 3 > /proc/sys/vm/drop_caches ; 
> free -m"
> > > And it gave me:
> > >              total       used       free     shared    buffers     
> > > cached
> > > Mem:          3950       3922         28          0          1        
> > > 879
> > > -/+ buffers/cache:       3041        909
> > > Swap:         5342        205       5136
> > >              total       used       free     shared    buffers     
> > > cached
> > > Mem:          3950       3907         43          0          0        
> > > 864
> > > -/+ buffers/cache:       3041        908
> > > Swap:         5341        206       5135
> > > 
> > > So the buffer was 1 and is 0 afterthat. But cached is at 879 MB 
> before 
> > > and is still 864 MB (!!!) after that!
> > > 
> > > I am at swappiness=0 and when I remove and readd one swap-partition 
> > > after another (so there is always swap). It will keep the cached and 
> > > put the swapped memory on other swaps?!
> > > 
> > > I _think_ thats not the way it should go?
> > > 
> > > It would be really kind if someone could explain that issue and 
> > > what "cached" is at all!
> > 
> > The memory mapped pages won't be dropped in this way.
> > "cat /proc/meminfo" will show you the number of mapped pages.
> 
> # sync ; echo 3 > /proc/sys/vm/drop_caches ; free -m ; cat /proc/meminfo
>              total       used       free     shared    buffers     
> cached
> Mem:          3950       3262        688          0          0        
> 359
> -/+ buffers/cache:       2902       1047
> Swap:         5890       1509       4381
> MemTotal:        4045500 kB
> MemFree:          705180 kB
> Buffers:             508 kB
> Cached:           367748 kB
> SwapCached:       880744 kB
> Active:          1555032 kB
> Inactive:        1634868 kB
> Active(anon):    1527100 kB
> Inactive(anon):  1607328 kB
> Active(file):      27932 kB
> Inactive(file):    27540 kB
> Unevictable:         816 kB
> Mlocked:               0 kB
> SwapTotal:       6032344 kB
> SwapFree:        4486496 kB
> Dirty:                 0 kB
> Writeback:             0 kB
> AnonPages:       2378112 kB
> Mapped:            52196 kB
> Slab:              65640 kB
> SReclaimable:      46192 kB
> SUnreclaim:        19448 kB
> PageTables:        28200 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     8055092 kB
> Committed_AS:    4915636 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:       44580 kB
> VmallocChunk:   34359677239 kB
> DirectMap4k:     3182528 kB
> DirectMap2M:     1011712 kB
> 
> The cached reduced to 359 MB (after the dropping).
> I dont know where to read the "number of mapped pages".
> "Mapped" is about 51 MB.

Does your tmpfs store lots of files?

Thanks,
Fengguang

