Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYAAPmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYAAPmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYAAPgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:37 -0500
Received: from il.qumranet.com ([82.166.9.18]:33791 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbYAAPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:26 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 21/54] KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM
Date: Tue,  1 Jan 2008 17:35:47 +0200
Message-Id: <1199201780-14001-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export kvm.h
only if the arch actually supports it.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/Kconfig     |    4 ++++
 drivers/kvm/Kconfig  |    4 ++--
 include/linux/Kbuild |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80b7ba4..e029a93 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -116,6 +116,10 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
 
+config ARCH_SUPPORTS_KVM
+	bool
+	default y
+
 
 config ZONE_DMA32
 	bool
diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 6569206..4086080 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -3,7 +3,7 @@
 #
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
-	depends on X86
+	depends on ARCH_SUPPORTS_KVM || X86
 	default y
 	---help---
 	  Say Y here to get to see options for using your Linux host to run other
@@ -16,7 +16,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on X86 && EXPERIMENTAL
+	depends on ARCH_SUPPORTS_KVM && EXPERIMENTAL
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 805c2a7..d70fa26 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -253,7 +253,7 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-unifdef-y += kvm.h
+unifdef-$(CONFIG_ARCH_SUPPORTS_KVM) += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
-- 
1.5.3.7

