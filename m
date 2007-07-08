Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbXGHL7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbXGHL7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXGHLzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:38408 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbXGHLyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 13/20] KVM: Clean up #includes
Date: Sun,  8 Jul 2007 14:54:42 +0300
Message-Id: <11838956891257-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary ones, and rearange the remaining in the standard order.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   18 +++++++-----------
 drivers/kvm/mmu.c      |   10 ++++++----
 drivers/kvm/svm.c      |    7 ++++---
 drivers/kvm/vmx.c      |    5 +++--
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 26ca90f..ea02719 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -16,37 +16,33 @@
  */
 
 #include "kvm.h"
+#include "x86_emulate.h"
+#include "segment_descriptor.h"
 
 #include <linux/kvm.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/magic.h>
-#include <asm/processor.h>
 #include <linux/percpu.h>
 #include <linux/gfp.h>
-#include <asm/msr.h>
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 #include <linux/vmalloc.h>
-#include <asm/uaccess.h>
 #include <linux/reboot.h>
-#include <asm/io.h>
 #include <linux/debugfs.h>
 #include <linux/highmem.h>
 #include <linux/file.h>
-#include <asm/desc.h>
 #include <linux/sysdev.h>
 #include <linux/cpu.h>
-#include <linux/file.h>
-#include <linux/fs.h>
-#include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 #include <linux/anon_inodes.h>
 
-#include "x86_emulate.h"
-#include "segment_descriptor.h"
+#include <asm/processor.h>
+#include <asm/msr.h>
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/desc.h>
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 49ffbd3..b297a6b 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -16,16 +16,18 @@
  * the COPYING file in the top-level directory.
  *
  */
+
+#include "vmx.h"
+#include "kvm.h"
+
 #include <linux/types.h>
 #include <linux/string.h>
-#include <asm/page.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
-#include <asm/cmpxchg.h>
 
-#include "vmx.h"
-#include "kvm.h"
+#include <asm/page.h>
+#include <asm/cmpxchg.h>
 
 #undef MMU_DEBUG
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index a0d4428..bc818cc 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -14,16 +14,17 @@
  *
  */
 
+#include "kvm_svm.h"
+#include "x86_emulate.h"
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <asm/desc.h>
 
-#include "kvm_svm.h"
-#include "x86_emulate.h"
+#include <asm/desc.h>
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 7d04ffa..80628f6 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -17,17 +17,18 @@
 
 #include "kvm.h"
 #include "vmx.h"
+#include "segment_descriptor.h"
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+
 #include <asm/io.h>
 #include <asm/desc.h>
 
-#include "segment_descriptor.h"
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
-- 
1.5.2.2

