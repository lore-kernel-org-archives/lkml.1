Return-Path: <linux-kernel-owner+w=401wt.eu-S933353AbXAaXY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbXAaXY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161028AbXAaXY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:24:28 -0500
Received: from sd291.sivit.org ([194.146.225.122]:3490 "EHLO sd291.sivit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353AbXAaXY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:24:27 -0500
Subject: PREEMPT_RT + HRT latencies on x86_64 SMP.
From: Stelian Pop <stelian@popies.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Philippe Gerum <rpm@xenomai.org>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 00:24:22 +0100
Message-Id: <1170285863.6531.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a dual Opteron dual-core machine here and while it behaves quite
well on PREEMPT_RT when using the clock_nanosleep() tests, it doesn't
work so well when using the timer primitives.

I ran the tests on 2.6.20-rc6-rt6 - using the precompiled x86_64 kernel
from Ingo's yum repository. The box is running RHEL 4, libc 2.3.4.

The latencies are reproductible even without any specific load and even
when using cyclictest on one or two threads only:
	./cyclictest -b 10000 -t 2 -p 90

1) a standard run gives a few latencies, like in:

0.57 0.16 0.32 1/150 3754 
T: 0 ( 3732) P:90 I:1000 C:  10109 Min:     46 Act:   95 Avg:   93 Max:     240
T: 1 ( 3733) P:89 I:1500 C:   6741 Min:     52 Act:   92 Avg:   93 Max:     178

Are the maximum latencies observed here (values around 200-300 us are
common) the expected ones ? Or are they caused by some problems which
needs to be investigated ?

2) some big latencies (>10 ms) are observed in some conditions. I
haven't been able to point out exactly what external activity - if any -
causes this, but it seems to happen every 10 minutes or so :

1.82 1.86 1.53 6/150 3658
T: 0 ( 3621) P:90 I:1000 C:1596828 Min:     20 Act:   25 Avg:   93 Max:     512
T: 1 ( 3622) P:89 I:1500 C:1064525 Min:     53 Act:   95 Avg:   94 Max:   15586

I have captured a latency trace for the above run (using cyclictest -b
as shown above), but I'm not sure it makes much sense. It weights almost
4 MB, so I'll not put in inline, get it from:
	http://www.popies.net/tmp/latency-trace-1

Any idea ?

Thanks,
-- 
Stelian Pop <stelian@popies.net>

