Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZCQX4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZCQX4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZCQXzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:55:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZCQXzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:55:50 -0400
Subject: Re: Test program for counters in groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <18880.12797.758764.128252@cargo.ozlabs.ibm.com>
References: <18880.12797.758764.128252@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 00:55:38 +0100
Message-Id: <1237334138.5189.1226.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 10:27 +1100, Paul Mackerras wrote:
> Here's a little test program that checks whether software counters
> (specifically, the task clock counter) work correctly when they're in
> a group with hardware counters.
> 
> What it does is to create several groups, each with one hardware
> counter, counting instructions, plus a task clock counter.  It needs
> to know an upper bound N on the number of hardware counters you have
> (N defaults to 8), and it creates N+4 groups to force them to be
> multiplexed.  It also creates an overall task clock counter.
> 
> Then it spins for a while, and then stops all the counters and reads
> them.  It takes the total of the task clock counters in the groups and
> computes the ratio of that total to the overall execution time from
> the overall task clock counter.
> 
> That ratio should be equal to the number of actual hardware counters
> that can count instructions.  If the task clock counters in the groups
> don't stop when their group gets taken off the PMU, the ratio will
> instead be close to N+4.  The program will declare that the test fails
> if the ratio is greater than N (actually, N + 0.0001 to allow for FP
> rounding errors).
> 
> Could someone run this on x86 on the latest PCL tree and let me know
> what happens?  I don't have an x86 crash box easily to hand.  On
> powerpc, it passes, but I think that is because I am missing setting
> counter->prev_count in arch/powerpc/kernel/perf_counter.c, and I think
> that means that enabling/disabling a group with a task clock counter
> in it won't work correctly (I'll do a test program for that next).
> 
> Usage is: swsched-test [-c num-hw-counters] [-v]
> 
> Use -c N if you have more than 8 hardware counters.  The -v flag makes
> it print out the values of each counter.

I'll give it a run when I'm awake again, with the patches I send out --
esp the last one, x86 might stand a chance of actually working.

