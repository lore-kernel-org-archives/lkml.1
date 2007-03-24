Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXCXNkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXCXNkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXCXNkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:40:05 -0400
Received: from www.osadl.org ([213.239.205.134]:34981 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751691AbXCXNkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:40:03 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>
In-Reply-To: <1174677724.10840.328.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174677724.10840.328.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 Mar 2007 14:47:26 +0100
Message-Id: <1174744046.10840.428.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Emil,

On Fri, 2007-03-23 at 20:22 +0100, Thomas Gleixner wrote:
> On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> > Subject    : dynticks makes ksoftirqd1 use unreasonable amount of cpu time
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8100
> > Submitter  : Emil Karlson <jkarlson@cc.hut.fi>
> > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > Status     : problem is being debugged
> 
> The problem is not reproducible on any of my machines.
> 

I've uploaded a patch against 2.6.21-rc4 to

http://tglx.de/private/tglx/2.6.21-rc4-trace/2.6.21-rc4-trace.patch.bz2

It contains all changes in Linus tree since -rc4 plus the two pending
fixes (http://tglx.de/private/tglx/2.6.21-rc4-pending/) along with a
backport of the latency tracer from the realtime preemption patch.

Can you please apply the patch on top of -rc4 and build it with the
configuration, which exposes this strange behaviour. Please enable also
CONFIG_LATENCY_TRACE in the Kernel hacking menu.

When the problem is visible, then run trace-it
(http://tglx.de/private/tglx/2.6.21-rc4-trace/trace-it.c) as root:

# trace-it >trace.txt

This captures roughly one second of kernel code pathes. Please stick
trace.txt into Bugzilla.

Thanks,

	tglx


