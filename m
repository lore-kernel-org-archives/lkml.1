Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXKSWDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXKSWDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXKSWCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:02:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbXKSWCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:02:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 03/18] x86 vDSO: remove vdso-syms.o
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Zippy-Says: I just bought FLATBUSH from MICKEY MANTLE!
Message-Id: <20071119220238.9131326F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:02:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Get rid of vdso-syms.o from the kernel link.  We don't need it any more.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/Makefile |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index d2ec170..6a665dd 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -6,13 +6,13 @@
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
 
 # files to link into kernel
-obj-y := vma.o vdso.o vdso-syms.o
+obj-y := vma.o vdso.o
 
 vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y) vdso-syms.o
+targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 
 # The DSO images are built using a special linker script.
 quiet_cmd_syscall = SYSCALL $@
@@ -43,17 +43,6 @@ CFL := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m
 $(obj)/vclock_gettime.o: KBUILD_CFLAGS = $(CFL)
 $(obj)/vgetcpu.o: KBUILD_CFLAGS = $(CFL)
 
-# We also create a special relocatable object that should mirror the symbol
-# table and layout of the linked DSO.  With ld -R we can then refer to
-# these symbols in the kernel code rather than hand-coded addresses.
-extra-y += vdso-syms.o
-$(obj)/built-in.o: $(obj)/vdso-syms.o
-$(obj)/built-in.o: ld_flags += -R $(obj)/vdso-syms.o
-
-SYSCFLAGS_vdso-syms.o = -r -d
-$(obj)/vdso-syms.o: $(src)/vdso.lds $(vobjs) FORCE
-	$(call if_changed,syscall)
-
 targets += vdso-syms.lds
 obj-y += vdso-syms.lds
 
