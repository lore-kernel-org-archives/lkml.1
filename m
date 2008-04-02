Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbYDBSjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbYDBSjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYDBSfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:43 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38412 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757205AbYDBSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:38 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 24] xen: Move events.c to drivers/xen for IA64/Xen
	support
X-Mercurial-Node: 31c970b6aed33a1672db93c58c1ac9b64f0bae61
Message-Id: <31c970b6aed33a1672db.1207158835@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

move arch/x86/xen/events.c undedr drivers/xen to share codes
with x86 and ia64. And minor adjustment to compile.
ia64/xen also uses events.c

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile  |    2 +-
 arch/x86/xen/xen-ops.h |    2 +-
 drivers/xen/Makefile   |    2 +-
 drivers/xen/events.c   |    3 +--
 include/xen/xen-ops.h  |    9 ++++++++-
 5 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
-			events.o time.o manage.o xen-asm.o
+			time.o manage.o xen-asm.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -3,6 +3,7 @@
 
 #include <linux/init.h>
 #include <linux/irqreturn.h>
+#include <xen/xen-ops.h>
 
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
@@ -10,7 +11,6 @@
 
 void xen_copy_trap_info(struct trap_info *traps);
 
-DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
 DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,2 +1,2 @@
-obj-y	+= grant-table.o features.o
+obj-y	+= grant-table.o features.o events.o
 obj-y	+= xenbus/
diff --git a/arch/x86/xen/events.c b/drivers/xen/events.c
rename from arch/x86/xen/events.c
rename to drivers/xen/events.c
--- a/arch/x86/xen/events.c
+++ b/drivers/xen/events.c
@@ -33,11 +33,10 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
+#include <xen/xen-ops.h>
 #include <xen/events.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
-
-#include "xen-ops.h"
 
 /*
  * This lock protects updates to the following mapping and reference-count
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
new file mode 100644
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


