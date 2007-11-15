Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXKOAOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXKOAOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbXKOAOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:14:15 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:28362 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831AbXKOAOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:14:14 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <473B8F91.20704@am.sony.com>
Date: Wed, 14 Nov 2007 16:15:13 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: rt-preempt: problem compiling rt-preempt 2.6.23.1-rt11 on MIPS
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2007 00:14:06.0988 (UTC) FILETIME=[6FE49CC0:01C8271C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I applied the patches in patch-2.6.23.1-rt11-broken-out.tar.bz2
to a Linux kernel version 2.6.23.1 (along with a few other
board specific patches).

I got the following compilation error:

  GEN     /home/tbird/work/rt-preempt/build/tx49/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    /home/tbird/work/rt-preempt/linux-2.6.23.1-rt11/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      kernel/latency_trace.o
/home/tbird/work/rt-preempt/linux-2.6.23.1-rt11/kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory
make[2]: *** [kernel/latency_trace.o] Error 1
make[1]: *** [kernel] Error 2
make: *** [vmlinux] Error 2

Indeed, there is no include/asm-mips/rtc.h.

I commented out the include line in latency_trace.c, and everything
compiled fine.  I'm not sure what is needed in an arch-specific rtc.h,
but compiling without it for the mips arch caused no problems.
Should I create a patch with a stub for rtc.h for mips?

As an aside, this has me worried.  Is anyone else doing any
RT Preempt testing or work on MIPS platforms, or am I forging
new ground? :-)

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

