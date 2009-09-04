Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZIDIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZIDIQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZIDIQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:16:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33155 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbZIDIQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:16:21 -0400
Message-Id: <4AA0E8F60200007800013703@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 04 Sep 2009 09:16:22 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: properly cpuinit-annotate SMP boot trampolines
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing annotations, and make use of include/linux/init.h's macros.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/trampoline.c    |    4 ++--
 arch/x86/kernel/trampoline_32.S |    8 ++------
 arch/x86/kernel/trampoline_64.S |    5 +++--
 3 files changed, 7 insertions(+), 10 deletions(-)

--- linux-2.6.31-rc8/arch/x86/kernel/trampoline.c	2009-03-24 00:12:14.000000000 +0100
+++ 2.6.31-rc8-x86-trampoline-cpuinit/arch/x86/kernel/trampoline.c	2009-09-02 12:13:01.000000000 +0200
@@ -4,7 +4,7 @@
 #include <asm/e820.h>
 
 /* ready for x86_64 and x86 */
-unsigned char *trampoline_base = __va(TRAMPOLINE_BASE);
+unsigned char *__cpuinitdata trampoline_base = __va(TRAMPOLINE_BASE);
 
 void __init reserve_trampoline_memory(void)
 {
@@ -26,7 +26,7 @@ void __init reserve_trampoline_memory(vo
  * bootstrap into the page concerned. The caller
  * has made sure it's suitably aligned.
  */
-unsigned long setup_trampoline(void)
+unsigned long __cpuinit setup_trampoline(void)
 {
 	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
 	return virt_to_phys(trampoline_base);
--- linux-2.6.31-rc8/arch/x86/kernel/trampoline_32.S	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc8-x86-trampoline-cpuinit/arch/x86/kernel/trampoline_32.S	2009-09-02 12:13:01.000000000 +0200
@@ -28,16 +28,12 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
-#ifndef CONFIG_HOTPLUG_CPU
-.section ".cpuinit.data","aw",@progbits
-#else
-.section .rodata,"a",@progbits
-#endif
-
+__CPUINITRODATA
 .code16
 
 ENTRY(trampoline_data)
--- linux-2.6.31-rc8/arch/x86/kernel/trampoline_64.S	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc8-x86-trampoline-cpuinit/arch/x86/kernel/trampoline_64.S	2009-09-02 12:13:01.000000000 +0200
@@ -25,14 +25,15 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/pgtable_types.h>
 #include <asm/page_types.h>
 #include <asm/msr.h>
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
 
-.section .rodata, "a", @progbits
-
+/* We can free up the trampoline after bootup if cpu hotplug is not supported. */
+__CPUINITRODATA
 .code16
 
 ENTRY(trampoline_data)



