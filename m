Return-Path: <linux-kernel-owner+w=401wt.eu-S1765822AbYDQJP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765822AbYDQJP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbYDQJLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:09 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59012
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961AbYDQJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 12/45] KVM: s390: add kvm to kconfig on s390
Date: Thu, 17 Apr 2008 12:10:17 +0300
Message-Id: <1208423450-29415-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patch adds the virtualization submenu and the kvm option to the kernel
config. It also defines HAVE_KVM for 64bit kernels.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/Kconfig     |    3 +++
 arch/s390/kvm/Kconfig |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 arch/s390/kvm/Kconfig

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3a6bfef..c43b250 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -66,6 +66,7 @@ config S390
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_KVM if 64BIT
 
 source "init/Kconfig"
 
@@ -553,3 +554,5 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+source "arch/s390/kvm/Kconfig"
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
new file mode 100644
index 0000000..2489b34
--- /dev/null
+++ b/arch/s390/kvm/Kconfig
@@ -0,0 +1,43 @@
+#
+# KVM configuration
+#
+config HAVE_KVM
+       bool
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	default y
+	---help---
+	  Say Y here to get to see options for using your Linux host to run other
+	  operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if VIRTUALIZATION
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on HAVE_KVM && EXPERIMENTAL
+	select PREEMPT_NOTIFIERS
+	select ANON_INODES
+	select S390_SWITCH_AMODE
+	select PREEMPT
+	---help---
+	  Support hosting paravirtualized guest machines using the SIE
+	  virtualization capability on the mainframe. This should work
+	  on any 64bit machine.
+
+	  This module provides access to the hardware capabilities through
+	  a character device node named /dev/kvm.
+
+	  To compile this as a module, choose M here: the module
+	  will be called kvm.
+
+	  If unsure, say N.
+
+# OK, it's a little counter-intuitive to do this, but it puts it neatly under
+# the virtualization menu.
+source drivers/virtio/Kconfig
+
+endif # VIRTUALIZATION
-- 
1.5.5

