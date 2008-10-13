Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYJMW7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYJMW7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbYJMW7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:59:08 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:46255 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbYJMW7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:59:07 -0400
Subject: [PATCH] x86: fix compile warning for !(ACPI && X86_IO_APIC) builds
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 14 Oct 2008 01:00:50 +0200
Message-Id: <1223938850.21717.21.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following compile warning for !(ACPI && X86_IO_APIC) builds:

arch/x86/kernel/early-quirks.c:99: warning: 'ati_ixp4x0_rev' defined
but not used

that was introduced by 33fb0e4 (x86: SB450: skip IRQ0 override if it is not
routed to INT2 of IOAPIC).

Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
---
 arch/x86/kernel/early-quirks.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 733c4f8..f60afb6 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,6 +95,7 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
 static u32 ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -115,7 +116,6 @@ static u32 ati_ixp4x0_rev(int num, int slot, int func)
 
 static void __init ati_bugs(int num, int slot, int func)
 {
-#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
 	u32 d;
 	u8  b;
 
@@ -138,8 +138,12 @@ static void __init ati_bugs(int num, int slot, int func)
 		printk(KERN_INFO "If you got timer trouble "
 		       "try acpi_use_timer_override\n");
 	}
-#endif
 }
+#else
+static void __init ati_bugs(int num, int slot, int func)
+{
+}
+#endif
 
 #ifdef CONFIG_DMAR
 static void __init intel_g33_dmar(int num, int slot, int func)
-- 
1.5.6.2.255.gbed62

