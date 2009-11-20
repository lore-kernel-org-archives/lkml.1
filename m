Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZKTM2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZKTM2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZKTM2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:28:51 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:59641 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZKTM2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=v+5EsV4HXvV8cIloZJFfVDQutbvgyUpNii0f/9Hb3Vzp2hJ8dk2ZeUtuFKWJMZani2
         yOCTDnne5N2KRwyojOKIS16/1gcpkmpViidiMUIg9K5Gc7HDXsRMfHgFPQz121a+tEjf
         ygQYQm8ZcFaXy+lpMTKDRzMQrA2DOigKH1YBg=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org
Cc: Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       Wu Zhangjin <wuzhangjin@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: [PATCH v9 00/10] ftrace for MIPS
Date: Fri, 20 Nov 2009 20:28:28 +0800
Message-Id: <cover.1258719323.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

After getting the feedback of v8 revision from Thomas, I have written a
cnt3_to_63() based sched_clock() for MIPS and send it out as a standalone
patch("MIPS: Add a high precision sched_clock() via cnt32_to_63()").

This v9 revision only reserve the Ftrace parts. So, Steven or Ralf, Is it time
to apply it? Thanks!

Best Regards,
     Wu Zhangjin

Wu Zhangjin (10):
  tracing: add static function tracer support for MIPS
  tracing: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
  tracing: add an endian argument to scripts/recordmcount.pl
  tracing: add dynamic function tracer support for MIPS
  tracing: add IRQENTRY_EXIT section for MIPS
  tracing: add function graph tracer support for MIPS
  tracing: add dynamic function graph tracer for MIPS
  tracing: make ftrace for MIPS work without -fno-omit-frame-pointer
  tracing: reserve $12(t0) for mcount-ra-address of gcc 4.5
  tracing: make function graph tracer work with -mmcount-ra-address

 arch/mips/Kconfig              |    5 +
 arch/mips/Makefile             |    9 ++
 arch/mips/include/asm/ftrace.h |   91 +++++++++++++-
 arch/mips/include/asm/irq.h    |   29 +----
 arch/mips/kernel/Makefile      |    7 +
 arch/mips/kernel/ftrace.c      |  275 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/irq.c         |   30 +++++
 arch/mips/kernel/mcount.S      |  189 +++++++++++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c  |    5 +
 arch/mips/kernel/smp.c         |    3 +-
 arch/mips/kernel/smtc.c        |   21 ++-
 arch/mips/kernel/vmlinux.lds.S |    1 +
 arch/mips/sgi-ip22/ip22-int.c  |    3 +-
 arch/mips/sgi-ip22/ip22-time.c |    3 +-
 scripts/Makefile.build         |    1 +
 scripts/recordmcount.pl        |   60 ++++++++-
 16 files changed, 691 insertions(+), 41 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace.c
 create mode 100644 arch/mips/kernel/mcount.S

