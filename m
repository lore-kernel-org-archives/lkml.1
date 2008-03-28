Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbYC1LmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbYC1LmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYC1LkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:40:24 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44543 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbYC1LkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:40:20 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com,
       yamahata@valinux.co.jp
Subject: [PATCH 06/12] xen: Move events.c to drivers/xen for IA64/Xen support.
Date: Fri, 28 Mar 2008 20:40:12 +0900
Message-Id: <1206704418948-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12067044183207-git-send-email-yamahata@valinux.co.jp>
References: <12067044183207-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move arch/x86/xen/events.c undedr drivers/xen to share codes
with x86 and ia64. And minor adjustment to compile.
ia64/xen also uses events.c

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 arch/x86/xen/Makefile              |    2 +-
 arch/x86/xen/xen-ops.h             |    2 +-
 drivers/xen/Makefile               |    2 +-
 {arch/x86 => drivers}/xen/events.c |    3 +--
 include/xen/xen-ops.h              |    8 ++++++++
 5 files changed, 12 insertions(+), 5 deletions(-)
 rename {arch/x86 => drivers}/xen/events.c (99%)
 create mode 100644 include/xen/xen-ops.h

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index c5e9aa4..95c5926 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
-			events.o time.o manage.o xen-asm.o
+			time.o manage.o xen-asm.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 22395d2..f1063ae 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -3,6 +3,7 @@
 
 #include <linux/init.h>
 #include <linux/irqreturn.h>
+#include <xen/xen-ops.h>
 
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
@@ -10,7 +11,6 @@ extern const char xen_failsafe_callback[];
 
 void xen_copy_trap_info(struct trap_info *traps);
 
-DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
 DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 609fdda..823ce78 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,2 +1,2 @@
-obj-y	+= grant-table.o features.o
+obj-y	+= grant-table.o features.o events.o
 obj-y	+= xenbus/
diff --git a/arch/x86/xen/events.c b/drivers/xen/events.c
similarity index 99%
rename from arch/x86/xen/events.c
rename to drivers/xen/events.c
index 85bac29..c50d499 100644
--- a/arch/x86/xen/events.c
+++ b/drivers/xen/events.c
@@ -33,12 +33,11 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
+#include <xen/xen-ops.h>
 #include <xen/events.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
-#include "xen-ops.h"
-
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
new file mode 100644
index 0000000..10ddfe0
--- /dev/null
+++ b/include/xen/xen-ops.h
@@ -0,0 +1,8 @@
+#ifndef INCLUDE_XEN_OPS_H
+#define INCLUDE_XEN_OPS_H
+
+#include <linux/percpu.h>
+
+DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
+
+#endif /* INCLUDE_XEN_OPS_H */
-- 
1.5.3

