Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbZFTTuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbZFTTuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 15:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZFTTuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 15:50:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35409 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZFTTuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 15:50:01 -0400
Date: Sat, 20 Jun 2009 20:50:00 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] profile: Suppress warning about large allocations when
	profile=1 is specified
Message-ID: <20090620195000.GC10878@csn.ul.ie>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org> <20090616223649.719ea378.akpm@linux-foundation.org> <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu> <20090617113534.GA21276@elte.hu> <20090617121913.GC28529@csn.ul.ie> <20090620100932.GA5863@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090620100932.GA5863@fancy-poultry.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 12:09:32PM +0200, Heinz Diehl wrote:
> On 17.06.2009, Mel Gorman wrote: 
> 
> > Patch as follows
> [....]
> 
> With 2.6.30-git14, I get this early in the boot process. 
> Don't know if it's related to this thread. In any case, your patch does not fix it:
> 

It's sortof related in that it's another source of NOFAIL high-order
allocations.

> [....]
> WARNING: at mm/page_alloc.c:1744 level2_spare_pgt+0x8f70a/0x36c800()
> Hardware name:  
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.30-git14 #1

I can't figure out from this trace where the problem is coming from. Can
you post your .config and the full dmesg please?

> Call Trace:
>  [<ffffffff8109770a>] ? level2_spare_pgt+0x8f70a/0x36c800
>  [<ffffffff8109770a>] ? level2_spare_pgt+0x8f70a/0x36c800
>  [<ffffffff81044a19>] ? level2_spare_pgt+0x3ca19/0x36c800
>  [<ffffffff8109770a>] ? level2_spare_pgt+0x8f70a/0x36c800
>  [<ffffffff810463f2>] ? level2_spare_pgt+0x3e3f2/0x36c800
>  [<ffffffff810bf8bb>] ? level2_spare_pgt+0xb78bb/0x36c800
>  [<ffffffff81096829>] ? level2_spare_pgt+0x8e829/0x36c800
>  [<ffffffff815281a2>] ? __smp_locks_end+0x33a4a/0x35773
>  [<ffffffff815280b0>] ? __smp_locks_end+0x33958/0x35773
>  [<ffffffff8100904b>] ? level2_spare_pgt+0x104b/0x36c800
>  [<ffffffff81119808>] ? level2_spare_pgt+0x111808/0x36c800
>  [<ffffffff81084df1>] ? level2_spare_pgt+0x7cdf1/0x36c800
>  [<ffffffff814f5665>] ? __smp_locks_end+0xf0d/0x35773
>  [<ffffffff8100ce0a>] ? level2_spare_pgt+0x4e0a/0x36c800
>  [<ffffffff814f54e9>] ? __smp_locks_end+0xd91/0x35773
>  [<ffffffff8100ce00>] ? level2_spare_pgt+0x4e00/0x36c800
> ---[ end trace 692ffa03e0502250 ]---
> CCID: Activated CCID 2 (TCP-like)
> registered taskstats version 1
> Freeing unused kernel memory: 572k freed
> [....]
> 
> Regards,
> Heinz.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
