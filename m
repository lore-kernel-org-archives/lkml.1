Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXKLCSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXKLCSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 21:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXKLCSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 21:18:36 -0500
Received: from mga10.intel.com ([192.55.52.92]:28811 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752543AbXKLCSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 21:18:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,402,1188802800"; 
   d="scan'208";a="378786658"
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1194602064.6289.157.camel@twins>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>
Content-Type: text/plain; charset=utf-8
Date: Mon, 12 Nov 2007 10:14:00 +0800
Message-Id: <1194833640.20251.80.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-09 at 10:54 +0100, Peter Zijlstra wrote:
> On Fri, 2007-11-09 at 17:47 +0800, Zhang, Yanmin wrote:
> > Comparing with 2.6.23, iozone sequential write/rewrite (512M) has 50% regression
> > in kernel 2.6.24-rc1. 2.6.24-rc2 has the same regression.
> > 
> > My machine has 8 processor cores and 8GB memory.
> > 
> > By bisect, I located patch
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=04fbfdc14e5f48463820d6b9807daa5e9c92c51f.
> > 
> > 
> > Another behavior: with kernel 2.6.23, if I run iozone for many times after rebooting machine,
> > the result looks stable. But with 2.6.24-rc1, the first run of iozone got a very small result and
> > following run has 4Xorig_result.
> 
> So the second run is 4x as fast as the first run?
Pls. see below comments.

> 
> > What I reported is the regression of 2nd/3rd run, because first run has bigger regression.
> 
> So the 2nd and 3rd run are stable at 50% slower than .23?
Almostly. I did more testing today. Pls. see below result list.

> 
> > I also tried to change /proc/sys/vm/dirty_ratio,dirty_backgroud_ratio and didn't get improvement.
> 
> Could you try:
> 
> ---
> Subject: mm: speed up writeback ramp-up on clean systems
I tested kernel 2.6.23, 2,6,24-rc2, 2.6.24-rc2_peter(2.6.24-rc2+this patch).

1) Compare among first/second/following running
2.6.23: second run of iozone will get about 28% improvement than first run.
	Following run is very stable like 2nd run.
2.6.24-rc2: second run of iozone will get about 170% improvement than first run. 3rd run
	will get about 80% improvement than 2nd. Following run is very stable like 3rd run.
2.6.24-rc2_peter: second run of iozone will get about 14% improvement than first run. Following
	run is mostly stable like 2nd run.
So the new patch really improves the first run result. Comparing wiht 2.6.24-rc2, 2.6.24-rc2_peter
has 330% improvement on the first run.

2) Compare among different kernels(based on the stable highest result):
2.6.24-rc2 has about 50% regression than 2.6.23.
2.6.24-rc2_peter has the same result like 2.6.24-rc2.
>From this point of view, above patch has no improvement. :)

-yanmin
