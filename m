Return-Path: <linux-kernel-owner+w=401wt.eu-S934008AbXC0Fs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbXC0Fs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934030AbXC0Fs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:48:59 -0400
Received: from gw.goop.org ([64.81.55.164]:59342 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934008AbXC0Fs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:48:58 -0400
Message-Id: <20070327053816.881735237@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 26 Mar 2007 22:38:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: [patch 0/2] softlockup watchdog improvements
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's couple of patches to improve the softlockup watchdog.

The first changes the softlockup timer from using jiffies to sched_clock()
as a timebase.  Xen and VMI implement sched_clock() as counting unstolen
time, so time stolen by the hypervisor won't cause the watchdog to bite.

The second adds per-cpu enable flags for the watchdog timer.  This allows
the timer to be disabled when the CPU goes into a (potentially unbounded)
tickless sleep.

I know this conflicts with
fix-bogus-softlockup-warning-with-sysrq-t.patch in -mm2.  I think that
patch incorrectly changes the behaviour of the softlockup watchdog,
and a better solution is to temporarily disable the watchdog while
doing something known to be cpu-consuming, like a long sysreq output.

	J
-- 

