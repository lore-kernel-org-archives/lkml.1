Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZJZPNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZJZPNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZJZPNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:13:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:26442 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZJZPNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=reejxIt+RCntPOEb72K0WFSD+fUViaSCWI0Dfjb1WUWBR4B4lF4Z0LL6ukhtkuGN4z
         AAJnFxKD6SCzYVhFqG2Quj90wYPG0ULgSZLV+KsE0SwkhNVD63HBlwaVRBTLpyLHmzEC
         K4YEH/AoPW6qBcFJMCkbGb8I48D2BZh+o3F58=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Subject: [PATCH -v6 00/13] ftrace for MIPS
Date: Mon, 26 Oct 2009 23:13:17 +0800
Message-Id: <cover.1256569489.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This -v6 revision incorporates the feedbacks of -v5 revision from Frederic
Weisbecker, the most important changes include:

1. tracing: add IRQENTRY_EXIT section for MIPS

Tag the mips irq entry functions with "__irq_entry".

2. "notrace" relative patches

To avoid hanging on mips_timecounter_read() when using function graph tracer,
we need not to trace the subroutines called by mips_timecounter_read(). for the
mips specific subroutines, we use __notrac_funcgraph to tag them.

For the common timecounter_read_* functions, we add a new __arch_notrace
flag/macro to include/linux/ftrace.h for the arch specific requirement, and use
it to tag them. and then we define the macro in arch/mips/include/asm/ftrace.h
to make it take effect for MIPS.

All of the latest update have been pushed into:

git://dev.lemote.com/rt4ls.git  linux-mips/dev/ftrace-upstream

Thanks & Regards,
	Wu Zhangjin

Wu Zhangjin (13):
  tracing: convert trace_clock_local() as weak function
  tracing: add mips_timecounter_read() for MIPS
  tracing: add MIPS specific trace_clock_local()
  tracing: add static function tracer support for MIPS
  tracing: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
  tracing: add an endian argument to scripts/recordmcount.pl
  tracing: add dynamic function tracer support for MIPS
  tracing: add IRQENTRY_EXIT section for MIPS
  tracing: Add __arch_notrace for arch specific requirement
  tracing: not trace the timecounter_read* in kernel/time/clocksource.c
  tracing: not trace mips_timecounter_read() for MIPS
  tracing: add function graph tracer support for MIPS
  tracing: add dynamic function graph tracer for MIPS

 arch/mips/Kconfig              |    5 +
 arch/mips/Makefile             |    4 +
 arch/mips/include/asm/ftrace.h |   42 +++++++++-
 arch/mips/include/asm/irq.h    |   29 +------
 arch/mips/include/asm/time.h   |   19 ++++
 arch/mips/kernel/Makefile      |    9 ++
 arch/mips/kernel/csrc-r4k.c    |   42 +++++++++
 arch/mips/kernel/ftrace.c      |  190 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/irq.c         |   34 +++++++
 arch/mips/kernel/mcount.S      |  177 +++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c  |    5 +
 arch/mips/kernel/smp.c         |    3 +-
 arch/mips/kernel/smtc.c        |   21 +++--
 arch/mips/kernel/time.c        |    2 +
 arch/mips/kernel/trace_clock.c |   33 +++++++
 arch/mips/kernel/vmlinux.lds.S |    1 +
 arch/mips/sgi-ip22/ip22-int.c  |    3 +-
 arch/mips/sgi-ip22/ip22-time.c |    3 +-
 include/linux/ftrace.h         |   19 ++++
 kernel/time/clocksource.c      |    5 +-
 kernel/trace/trace_clock.c     |    2 +-
 scripts/Makefile.build         |    1 +
 scripts/recordmcount.pl        |   44 +++++++++-
 23 files changed, 649 insertions(+), 44 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace.c
 create mode 100644 arch/mips/kernel/mcount.S
 create mode 100644 arch/mips/kernel/trace_clock.c

