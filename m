Return-Path: <linux-kernel-owner+w=401wt.eu-S1163353AbXD1SA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163353AbXD1SA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163326AbXD1RxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:08 -0400
Received: from mail.suse.de ([195.135.220.2]:34440 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163320AbXD1Rw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:56 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [30/35] i386: clean up mach_reboot_fixups
Message-Id: <20070428175255.EDE6D151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
The reboot_fixups stuff seems to be a bit of a mess, specifically the
header is in linux/ when its a purely i386-specific piece of code.  I'm
not sure why it has its config option; its only currently needed for
"geode-gx1/cs5530a", so perhaps whatever config option controls that
hardware should enable this?

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/reboot.c        |    6 +++++-
 arch/i386/kernel/reboot_fixups.c |    2 +-
 include/asm-i386/reboot_fixups.h |    6 ++++++
 include/linux/reboot_fixups.h    |   10 ----------
 4 files changed, 12 insertions(+), 12 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/reboot.c
===================================================================
--- linux.orig/arch/i386/kernel/reboot.c
+++ linux/arch/i386/kernel/reboot.c
@@ -17,7 +17,7 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 #include "mach_reboot.h"
-#include <linux/reboot_fixups.h>
+#include <asm/reboot_fixups.h>
 
 /*
  * Power off function, if any
@@ -316,6 +316,10 @@ void machine_shutdown(void)
 #endif
 }
 
+void __attribute__((weak)) mach_reboot_fixups(void)
+{
+}
+
 void machine_emergency_restart(void)
 {
 	if (!reboot_thru_bios) {
Index: linux/arch/i386/kernel/reboot_fixups.c
===================================================================
--- linux.orig/arch/i386/kernel/reboot_fixups.c
+++ linux/arch/i386/kernel/reboot_fixups.c
@@ -10,7 +10,7 @@
 
 #include <asm/delay.h>
 #include <linux/pci.h>
-#include <linux/reboot_fixups.h>
+#include <asm/reboot_fixups.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
Index: linux/include/asm-i386/reboot_fixups.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/reboot_fixups.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_REBOOT_FIXUPS_H
+#define _LINUX_REBOOT_FIXUPS_H
+
+extern void mach_reboot_fixups(void);
+
+#endif /* _LINUX_REBOOT_FIXUPS_H */
Index: linux/include/linux/reboot_fixups.h
===================================================================
--- linux.orig/include/linux/reboot_fixups.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _LINUX_REBOOT_FIXUPS_H
-#define _LINUX_REBOOT_FIXUPS_H
-
-#ifdef CONFIG_X86_REBOOTFIXUPS
-extern void mach_reboot_fixups(void);
-#else
-#define mach_reboot_fixups() ((void)(0))
-#endif
-
-#endif /* _LINUX_REBOOT_FIXUPS_H */
