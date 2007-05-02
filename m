Return-Path: <linux-kernel-owner+w=401wt.eu-S1767048AbXEBSGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767048AbXEBSGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767047AbXEBSGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:06:13 -0400
Received: from holomorphy.com ([66.93.40.71]:41992 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767044AbXEBSGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:06:11 -0400
Date: Wed, 2 May 2007 11:06:45 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: l.genoni@oltrelinux.com
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Rajib Majumder <rajibm2005@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, l.genoni@sns.it
Subject: Re: Kernel Scalability
Message-ID: <20070502180645.GY19966@holomorphy.com>
References: <6278d2220705020843l718b3272k5d6ebf8b827d0806@mail.gmail.com> <Pine.LNX.4.64.0705021933320.14034@Phoenix.oltrelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705021933320.14034@Phoenix.oltrelinux.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Daniel J Blueman wrote:
>> There are 128-processor IA64 systems which run recent 2.6 kernels out
>> there; the per-processor counters, RCU and page-fault scalability work
>> has been instrumental to the necessary scaling for decent resource
>> usage on these.
>> IIRC, there were some patches being developed to improve pagecache
>> scalability lately too, but I guess it all depends on what kind of
>> workload you have...

On Wed, May 02, 2007 at 07:39:48PM +0200, l.genoni@oltrelinux.com wrote:
> To stay on systems probably more familiar to the user who asked this 
> question, there are also some 64 core X86_64 bot AMD and Intel out there, 
> here the 2.6 kernel is doing 
> very well even on those intel CPU with shared L2 cache.
> I have some 16 and 32 core Opteron and never had scalability problems.
> You have to pay a lot of attention to your kernel configuration  (100 HZ, 
> just BKL preemption), and to the 
> filesystems you decide to use.

One doesn't typically experience scalability problems per se. One
rather compares slopes of scaling lines and notes relative scaling
across kernels, be they versions of the same kernel or different
codebases altogether. It's still possible to have scalability
problems, of course, where things basically slowdown severely or
appear to stop entirely.

Nonlinear scalability is generally considered to be where the limits
of scaling set in. There is usually linear scaling until some number
of processors, and then the limit is where the linearity breaks down.
Linear scalability is defined as adding resources (e.g. cpus) to the
system resulting in a linear increase in performance.

To characterize a kernel's scalability, one should say three things:
(1) workload/benchmark
(2) linear scaling coefficient
(3) upper limit on linearity

So you would say that when running dbench, Linux scales with a
coefficient of 0.85 up to 78 processors or similar.


-- wli
