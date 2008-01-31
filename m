Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbYAaVpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbYAaVpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYAaVpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:45:40 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:47191 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176AbYAaVpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:45:39 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 31 Jan 2008 21:45:17 +0000
Message-Id: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] x86: define OBJCOPYFLAGS explicitly for each target.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do this rather than defining a global version and overriding it in
almost all cases in order to make subsequent patches simpler.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Makefile                 |    1 -
 arch/x86/boot/Makefile            |    2 +-
 arch/x86/boot/compressed/Makefile |    1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index da8f412..e7b7c68 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -92,7 +92,6 @@ KBUILD_AFLAGS += $(cfi) $(cfi-sigframe)
 KBUILD_CFLAGS += $(cfi) $(cfi-sigframe)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
-OBJCOPYFLAGS := -O binary -R .note -R .comment -S
 
 # Speed up the build
 KBUILD_CFLAGS += -pipe
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 349b81a..254a583 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -80,6 +80,7 @@ $(obj)/zImage $(obj)/bzImage: $(obj)/setup.bin \
 	$(call if_changed,image)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
+OBJCOPYFLAGS_vmlinux.bin := -O binary -R .note -R .comment -S
 $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
 
@@ -90,7 +91,6 @@ $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
 	$(call if_changed,ld)
 
 OBJCOPYFLAGS_setup.bin	:= -O binary
-
 $(obj)/setup.bin: $(obj)/setup.elf FORCE
 	$(call if_changed,objcopy)
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index fe24cea..d2b9f3b 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -22,6 +22,7 @@ $(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $
 	$(call if_changed,ld)
 	@:
 
+OBJCOPYFLAGS_vmlinux.bin := -O binary -R .note -R .comment -S
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
-- 
1.5.3.8

