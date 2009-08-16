Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZHPJkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZHPJkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZHPJiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45335 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/48] KVM: Move common KVM Kconfig items to new file virt/kvm/Kconfig
Date: Sun, 16 Aug 2009 12:29:30 +0300
Message-Id: <1250415008-17175-11-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce Kconfig code duplication.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/Kconfig    |    7 ++-----
 arch/powerpc/kvm/Kconfig |    3 +--
 arch/s390/kvm/Kconfig    |    6 +-----
 arch/x86/kvm/Kconfig     |    7 ++-----
 virt/kvm/Kconfig         |    7 +++++++
 5 files changed, 13 insertions(+), 17 deletions(-)
 create mode 100644 virt/kvm/Kconfig

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index 64d5209..f922bbb 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -1,12 +1,8 @@
 #
 # KVM configuration
 #
-config HAVE_KVM
-	bool
 
-config HAVE_KVM_IRQCHIP
-       bool
-       default y
+source "virt/kvm/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -28,6 +24,7 @@ config KVM
 	depends on PCI
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
+	select HAVE_KVM_IRQCHIP
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 5a152a5..46019dc 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -2,8 +2,7 @@
 # KVM configuration
 #
 
-config HAVE_KVM_IRQCHIP
-       bool
+source "virt/kvm/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 3e260b7..ad75ce3 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -1,11 +1,7 @@
 #
 # KVM configuration
 #
-config HAVE_KVM
-       bool
-
-config HAVE_KVM_IRQCHIP
-       bool
+source "virt/kvm/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8600a09..939b1cb 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -1,12 +1,8 @@
 #
 # KVM configuration
 #
-config HAVE_KVM
-       bool
 
-config HAVE_KVM_IRQCHIP
-       bool
-       default y
+source "virt/kvm/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -29,6 +25,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
+	select HAVE_KVM_IRQCHIP
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
new file mode 100644
index 0000000..79e83fc
--- /dev/null
+++ b/virt/kvm/Kconfig
@@ -0,0 +1,7 @@
+# KVM common configuration items and defaults
+
+config HAVE_KVM
+       bool
+
+config HAVE_KVM_IRQCHIP
+       bool
-- 
1.6.3.3

