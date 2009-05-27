Return-Path: <linux-kernel-owner+w=401wt.eu-S1762904AbZE0Han@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762904AbZE0Han (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762296AbZE0H0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:30 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46919 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762288AbZE0H02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:28 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 29/29] microblaze_mmu_v2: Makefiles
Date: Wed, 27 May 2009 08:47:54 +0200
Message-Id: <1243406874-3917-30-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-29-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
 <1243406874-3917-16-git-send-email-monstr@monstr.eu>
 <1243406874-3917-17-git-send-email-monstr@monstr.eu>
 <1243406874-3917-18-git-send-email-monstr@monstr.eu>
 <1243406874-3917-19-git-send-email-monstr@monstr.eu>
 <1243406874-3917-20-git-send-email-monstr@monstr.eu>
 <1243406874-3917-21-git-send-email-monstr@monstr.eu>
 <1243406874-3917-22-git-send-email-monstr@monstr.eu>
 <1243406874-3917-23-git-send-email-monstr@monstr.eu>
 <1243406874-3917-24-git-send-email-monstr@monstr.eu>
 <1243406874-3917-25-git-send-email-monstr@monstr.eu>
 <1243406874-3917-26-git-send-email-monstr@monstr.eu>
 <1243406874-3917-27-git-send-email-monstr@monstr.eu>
 <1243406874-3917-28-git-send-email-monstr@monstr.eu>
 <1243406874-3917-29-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Makefile        |    4 ++++
 arch/microblaze/boot/Makefile   |    2 ++
 arch/microblaze/kernel/Makefile |    1 +
 arch/microblaze/lib/Makefile    |    3 ++-
 arch/microblaze/mm/Makefile     |    2 ++
 5 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index ab731b7..d0bcf80 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -1,4 +1,8 @@
+ifeq ($(CONFIG_MMU),y)
+UTS_SYSNAME = -DUTS_SYSNAME=\"Linux\"
+else
 UTS_SYSNAME = -DUTS_SYSNAME=\"uClinux\"
+endif
 
 # What CPU vesion are we building for, and crack it open
 # as major.minor.rev
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 844edf4..c2bb043 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -7,6 +7,8 @@ targets := linux.bin linux.bin.gz
 OBJCOPYFLAGS_linux.bin  := -O binary
 
 $(obj)/linux.bin: vmlinux FORCE
+	[ -n $(CONFIG_INITRAMFS_SOURCE) ] && [ ! -e $(CONFIG_INITRAMFS_SOURCE) ] && \
+	touch $(CONFIG_INITRAMFS_SOURCE) || echo "No CPIO image"
 	$(call if_changed,objcopy)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index da94bec..f4a5e19 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -15,5 +15,6 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_SELFMOD)		+= selfmod.o
 obj-$(CONFIG_HEART_BEAT)	+= heartbeat.o
 obj-$(CONFIG_MODULES)		+= microblaze_ksyms.o module.o
+obj-$(CONFIG_MMU)		+= misc.o
 
 obj-y	+= entry$(MMUEXT).o
diff --git a/arch/microblaze/lib/Makefile b/arch/microblaze/lib/Makefile
index d27126b..71c8cb6 100644
--- a/arch/microblaze/lib/Makefile
+++ b/arch/microblaze/lib/Makefile
@@ -10,4 +10,5 @@ else
 lib-y += memcpy.o memmove.o
 endif
 
-lib-y +=  uaccess.o
+lib-$(CONFIG_NO_MMU) += uaccess.o
+lib-$(CONFIG_MMU) += uaccess_old.o
diff --git a/arch/microblaze/mm/Makefile b/arch/microblaze/mm/Makefile
index bf9e447..6c8a924 100644
--- a/arch/microblaze/mm/Makefile
+++ b/arch/microblaze/mm/Makefile
@@ -3,3 +3,5 @@
 #
 
 obj-y := init.o
+
+obj-$(CONFIG_MMU) += pgtable.o mmu_context.o fault.o
-- 
1.5.5.1

