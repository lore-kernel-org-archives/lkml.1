Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXKSWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXKSWKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbXKSWHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:07:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbXKSWHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:07:42 -0500
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
Subject: [PATCH 18/18] x86 vDSO: makefile cleanup
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Shopping-List: (1) Instant dramatic audition lips
   (2) Sunburnt bugs
   (3) Bicentennial breeze longitudes
   (4) Licentious maternity warriors
   (5) Hilarious friction
Message-Id: <20071119220706.57F7226F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:07:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the arch/x86/vdso/Makefile rules for vdso.so to
share more code with the vdso32-*.so rules and remove old cruft.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/Makefile |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 53f36bc..2d5bbbe 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -23,25 +23,15 @@ $(obj)/vdso.o: $(obj)/vdso.so
 
 targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 
-# The DSO images are built using a special linker script.
-quiet_cmd_syscall = SYSCALL $@
-      cmd_syscall = $(CC) -m elf_x86_64 -nostdlib $(SYSCFLAGS_$(@F)) \
-		          -Wl,-T,$(filter-out FORCE,$^) -o $@
-
 export CPPFLAGS_vdso.lds += -P -C
 
-vdso-flags = -fPIC -shared -Wl,-soname=linux-vdso.so.1 \
-		 $(call ld-option, -Wl$(comma)--hash-style=sysv) \
-		-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
-SYSCFLAGS_vdso.so = $(vdso-flags)
-SYSCFLAGS_vdso.so.dbg = $(vdso-flags)
+VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
+		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
 
-$(obj)/vdso.so: $(src)/vdso.lds $(vobjs) FORCE
-
 $(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
-	$(call if_changed,syscall)
+	$(call if_changed,vdso)
 
 $(obj)/%.so: OBJCOPYFLAGS := -S
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
@@ -49,8 +39,7 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 
 CFL := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
 
-$(obj)/vclock_gettime.o: KBUILD_CFLAGS = $(CFL)
-$(obj)/vgetcpu.o: KBUILD_CFLAGS = $(CFL)
+$(vobjs): KBUILD_CFLAGS = $(CFL)
 
 targets += vdso-syms.lds
 obj-$(VDSO64-y)			+= vdso-syms.lds
