Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYGRMpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYGRMpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbYGRMpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:45:00 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30856 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbYGRMo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:44:59 -0400
Message-Id: <4880AC80.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:45:20 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: reduce force_mwait visibility
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used anywhere outside its single referencing file.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/cpu/amd.c   |    2 --
 arch/x86/kernel/process.c   |    2 ++
 include/asm-x86/processor.h |    2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.26/arch/x86/kernel/cpu/amd.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-force-mwait-cleanup/arch/x86/kernel/cpu/amd.c	2008-07-15 14:54:53.000000000 +0200
@@ -61,8 +61,6 @@ static __cpuinit int amd_apic_timer_brok
 }
 #endif
 
-int force_mwait __cpuinitdata;
-
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpuid_eax(0x80000000) >= 0x80000007) {
--- linux-2.6.26/arch/x86/kernel/process.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-force-mwait-cleanup/arch/x86/kernel/process.c	2008-07-15 14:54:53.000000000 +0200
@@ -122,6 +122,8 @@ static void poll_idle(void)
  *
  * idle=mwait overrides this decision and forces the usage of mwait.
  */
+static int __cpuinitdata force_mwait;
+
 static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
 	if (force_mwait)
--- linux-2.6.26/include/asm-x86/processor.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-force-mwait-cleanup/include/asm-x86/processor.h	2008-07-15 14:54:53.000000000 +0200
@@ -727,8 +727,6 @@ static inline void __sti_mwait(unsigned 
 
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
-extern int			force_mwait;
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
 extern unsigned long		boot_option_idle_override;



