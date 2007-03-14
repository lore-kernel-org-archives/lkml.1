Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXCNWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXCNWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXCNWZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:25:18 -0400
Received: from gw.goop.org ([64.81.55.164]:49746 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbXCNWYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:24:32 -0400
Message-ID: <45F8761F.8010203@goop.org>
Date: Wed, 14 Mar 2007 15:24:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] clean up mach_reboot_fixups
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The reboot_fixups stuff seems to be a bit of a mess, specifically the
header is in linux/ when its a purely i386-specific piece of code.  I'm
not sure why it has its config option; its only currently needed for
"geode-gx1/cs5530a", so perhaps whatever config option controls that
hardware should enable this?

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/reboot.c        |    6 +++++-
 arch/i386/kernel/reboot_fixups.c |    2 +-
 include/asm-i386/reboot_fixups.h |    6 ++++++
 include/linux/reboot_fixups.h    |   10 ----------
 4 files changed, 12 insertions(+), 12 deletions(-)

===================================================================
--- a/arch/i386/kernel/reboot.c
+++ b/arch/i386/kernel/reboot.c
@@ -17,7 +17,7 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 #include "mach_reboot.h"
-#include <linux/reboot_fixups.h>
+#include <asm/reboot_fixups.h>
 
 /*
  * Power off function, if any
@@ -314,6 +314,10 @@ void machine_shutdown(void)
 #ifdef CONFIG_X86_IO_APIC
 	disable_IO_APIC();
 #endif
+}
+
+void __attribute__((weak)) mach_reboot_fixups(void)
+{
 }
 
 void machine_emergency_restart(void)
===================================================================
--- a/arch/i386/kernel/reboot_fixups.c
+++ b/arch/i386/kernel/reboot_fixups.c
@@ -10,7 +10,7 @@
 
 #include <asm/delay.h>
 #include <linux/pci.h>
-#include <linux/reboot_fixups.h>
+#include <asm/reboot_fixups.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
===================================================================
--- /dev/null
+++ b/include/asm-i386/reboot_fixups.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_REBOOT_FIXUPS_H
+#define _LINUX_REBOOT_FIXUPS_H
+
+extern void mach_reboot_fixups(void);
+
+#endif /* _LINUX_REBOOT_FIXUPS_H */
===================================================================
--- a/include/linux/reboot_fixups.h
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

