Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZCLLwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZCLLwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZCLLwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:52:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:28004 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZCLLwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:52:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,350,1233561600"; 
   d="scan'208";a="119515356"
Date: Thu, 12 Mar 2009 19:51:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: jack marrow <jackmarrow2@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Memory usage per memory zone
Message-ID: <20090312115147.GA20785@localhost>
References: <20090311121123.GA7656@localhost> <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com> <20090311122611.GA8804@localhost> <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com> <20090312075952.GA19331@localhost> <e2dc2c680903120104h4d19a3f6j57ad045bc06f9a90@mail.gmail.com> <20090312081113.GA19506@localhost> <e2dc2c680903120117j7be962b2xd63f3296f8f65a46@mail.gmail.com> <20090312103847.GA20210@localhost> <e2dc2c680903120438i27e209c2h28c61704299b8b4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2dc2c680903120438i27e209c2h28c61704299b8b4f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 01:38:46PM +0200, jack marrow wrote:
> > Can you paste the /proc/meminfo after doing 'echo 3 > drop_caches'?
> 
> http://pastebin.com/mce24730
> 
> >> I thought the kernel dropped caches if a program needs the ram?
> >
> > Sure, but something is unreclaimable... Maybe some process is taking a
> > lot of shared memory(shm)? What's the output of `lsof`?
> 
> I can't paste that, but I expect oracle is using it.

Oh well...

But from the meminfo, there are 1.2G mapped pages. That could be a big
trouble for reclaiming.  Recent kernels can better handle this situation.

Thanks,
Fengguang
---

# cat /proc/meminfo
MemTotal:      3895404 kB
MemFree:       2472656 kB
Buffers:           412 kB
Cached:         239716 kB
SwapCached:     202652 kB
Active:        1275212 kB
Inactive:        34584 kB
HighTotal:     3014592 kB
HighFree:      1684032 kB
LowTotal:       880812 kB
LowFree:        788624 kB
SwapTotal:     2040212 kB
SwapFree:      1626756 kB
Dirty:             104 kB
Writeback:           0 kB
Mapped:        1247000 kB
Slab:            80040 kB
CommitLimit:   3987912 kB
Committed_AS:  8189040 kB
PageTables:      18792 kB
VmallocTotal:   106488 kB
VmallocUsed:      3072 kB
VmallocChunk:   102980 kB
HugePages_Total:     0
HugePages_Free:      0
Hugepagesize:     2048 kB
