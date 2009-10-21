Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZJUOeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZJUOeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZJUOeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:34:24 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:33101 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZJUOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YOv8k4q0JMBuGYvs0HP5NDEjQvCJMp2k1EBvBR97c1pP/+9+Vfa7les72vYjl+5IKW
         l/DsVToQTfWqNKwbyG/cgXQSOl16kwv52hJee4orvVfPI+WQ91nJYQEkijfct/dMGCU/
         GvkHzz5xwiM8x7vQyJc0Uawg0ccqXx/CORIE0=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH -v4 0/9] ftrace for MIPS
Date: Wed, 21 Oct 2009 22:34:17 +0800
Message-Id: <cover.1256134682.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add basic ftrace support for MIPS, it is on the -v4 revision. which
incorporates the feedbacks from Steven, Ralf, Nicholas, Thomas, Américo Wang,
Zhang Le and Sergei Shtylyov. thanks goes to them!

It includes the following parts:

1. mips specific high precision of trace_clock_local() support

It is based on the clock counter register, and can provide us precision
timestamp. the old one is jiffies based, only provide ms precision.

2. mips specific static, dynamic, graph function tracer support

all of them support 32bit/64bit kernel, but not support modules yet(Steven will
help to fix this part! thanks goes to him). but if you want to have a quick try
on using module with static function tracer, you just need to add -mlong-calls
to KBUILD_CFLAGS.

All of the latest upgrade will be put into this git repo.

git://dev.lemote.com/rt4ls.git linux-mips/dev/ftrace-upstream

Welcome to play with it and give feedback, thanks!

Regards,
	Wu Zhangjin

Wu Zhangjin (9):
  tracing: convert trace_clock_local() as weak function
  MIPS: add mips_timecounter_read() to get high precision timestamp
  tracing: add MIPS specific trace_clock_local()
  tracing: add static function tracer support for MIPS
  tracing: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
  tracing: add an endian argument to scripts/recordmcount.pl
  tracing: add dynamic function tracer support for MIPS
  tracing: not trace mips_timecounter_init() in MIPS
  tracing: add function graph tracer support for MIPS

 arch/mips/Kconfig              |    5 +
 arch/mips/Makefile             |    2 +
 arch/mips/include/asm/ftrace.h |   35 +++++-
 arch/mips/include/asm/time.h   |   19 +++
 arch/mips/kernel/Makefile      |    9 ++
 arch/mips/kernel/csrc-r4k.c    |   41 ++++++
 arch/mips/kernel/ftrace.c      |  299 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S      |  182 ++++++++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c  |    5 +
 arch/mips/kernel/time.c        |    2 +
 arch/mips/kernel/trace_clock.c |   37 +++++
 arch/mips/kernel/vmlinux.lds.S |    1 +
 include/linux/clocksource.h    |    2 +-
 kernel/time/clocksource.c      |    4 +-
 kernel/trace/trace_clock.c     |    2 +-
 scripts/Makefile.build         |    1 +
 scripts/recordmcount.pl        |   28 ++++-
 17 files changed, 666 insertions(+), 8 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace.c
 create mode 100644 arch/mips/kernel/mcount.S
 create mode 100644 arch/mips/kernel/trace_clock.c

