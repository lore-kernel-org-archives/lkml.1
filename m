Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbYANSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbYANSzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYANSzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:55:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbYANSzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:55:32 -0500
Date: Mon, 14 Jan 2008 19:55:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Colin Fowler <elethiomel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive
	benchmark on 8 Core Xeon
Message-ID: <20080114185520.GA26540@elte.hu>
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Colin Fowler <elethiomel@gmail.com> wrote:

> Benchmark : A ray-trace is performed on 500 times on 17 separate 
> scenes. Workload is distributed by tiling the framebuffer into N 32x32 
> pixel tiles. Each CPU grabs one of N tiles out of the queue and 
> repeats until no jobs are left. Rendering is to a shared framebuffer 
> (obviously this causes problems with caching). Locking and 
> synchronization is done using pthreads.
> 
> Other details: The system is cleanly booted for each run. No I/O is 
> performed during the timed portions of the test. The benchmark does 
> however read a model file from the drive and build a data structure 
> from it before each timed portion.
> 
> On the 2.6.22 series of kernels results are pretty much the same. On
> 2.6.23 series kernels I see a loss in speed of ~2% across the board.
> On 2.6.24-rc7 that loss in speed is perhaps very slightly worse (~3%).
> 2.6.22 Kernels tested: 22.9(Ubuntu Stock Kernel), 22.14, 22.15
> 2.6.23 Kernels tested: 23.1, 23.3,  23.13
> 2.6.24 Kernels tested: 24-rc7
> 
> I have my kernel compiled to use the SLAB allocator. All other 
> tweaking options are set as defaults. My config files are available at 
> http://vangogh.cs.tcd.ie/fowler/configs . Perhaps I'm configuring 
> something wrong for the type of work I do?

Could you try CONFIG_SCHED_DEBUG=y and CONFIG_SCHEDSTATS=y and double 
the value of /proc/sys/kernel/sched_latency_ns - does that make any 
difference? Please also run the following script while the ray-trace app 
is running:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and send me the output of it, so that we can have an idea about what's 
going on in your system during this workload.

	Ingo
