Return-Path: <linux-kernel-owner+w=401wt.eu-S933841AbXCNFMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbXCNFMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933869AbXCNFMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:43 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45296 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933841AbXCNFMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:08 -0400
Message-Id: <20070314051050.515925858@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 17/18] create x86/oprofile/Makefile
Content-Disposition: inline; filename=oprofile-makefile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create the Makefile in the common hold and adjust the i386 and
x86_64 code accordingly.


Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86_64/oprofile/Makefile b/arch/x86_64/oprofile/Makefile
deleted file mode 100644
index 6be3268..0000000
--- a/arch/x86_64/oprofile/Makefile
+++ /dev/null
@@ -1,19 +0,0 @@
-#
-# oprofile for x86-64.
-# Just reuse the one from i386. 
-#
-
-obj-$(CONFIG_OPROFILE) += oprofile.o
- 
-DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
-	oprof.o cpu_buffer.o buffer_sync.o \
-	event_buffer.o oprofile_files.o \
-	oprofilefs.o oprofile_stats.o \
-	timer_int.o )
-
-OPROFILE-y := init.o backtrace.o
-OPROFILE-$(CONFIG_X86_LOCAL_APIC) += nmi_int.o op_model_athlon.o op_model_p4.o \
-				     op_model_ppro.o
-OPROFILE-$(CONFIG_X86_IO_APIC)    += nmi_timer_int.o 
-
-oprofile-y = $(DRIVER_OBJS) $(addprefix ../../i386/oprofile/, $(OPROFILE-y))

--
