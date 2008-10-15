Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYJOReY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYJOReY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYJOReQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:34:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:51353 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYJOReP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YCGJ3mUTJlCl/PjfSumHDyS1aEx09FnewoDy3UClUvMMw+WJV7j339RUmZMpm0hDqc
         FfhRC5ew31fL3WKHpeJDYCkprxhqyn4E9boxj8chewQ6flxBp2ItA3KooqqmSS+Di5vy
         y+3QTZojzz2TREbHl5MAo2+WhbujN7B0Bz264=
Date: Wed, 15 Oct 2008 21:34:06 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mingo@elte.hu, andreas.herrmann3@amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/early-quirks: fix warning defined but not used
Message-ID: <20081015173406.GB30703@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/early-quirks.c:99: warning: 'ati_ixp4x0_rev' defined but not used
Compile tested.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 arch/x86/kernel/early-quirks.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 733c4f8..eadfa3d 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -57,20 +57,14 @@ static void __init via_bugs(int  num, int slot, int func)
 #endif
 }
 
-#ifdef CONFIG_ACPI
-#ifdef CONFIG_X86_IO_APIC
-
+#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
 	return 0;
 }
-#endif /* CONFIG_X86_IO_APIC */
-#endif /* CONFIG_ACPI */
 
 static void __init nvidia_bugs(int num, int slot, int func)
 {
-#ifdef CONFIG_ACPI
-#ifdef CONFIG_X86_IO_APIC
 	/*
 	 * All timer overrides on Nvidia are
 	 * wrong unless HPET is enabled.
@@ -89,10 +83,6 @@ static void __init nvidia_bugs(int num, int slot, int func)
 		printk(KERN_INFO "If you got timer trouble "
 			"try acpi_use_timer_override\n");
 	}
-#endif
-#endif
-	/* RED-PEN skip them on mptables too? */
-
 }
 
 static u32 ati_ixp4x0_rev(int num, int slot, int func)
@@ -115,7 +105,6 @@ static u32 ati_ixp4x0_rev(int num, int slot, int func)
 
 static void __init ati_bugs(int num, int slot, int func)
 {
-#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
 	u32 d;
 	u8  b;
 
@@ -138,8 +127,14 @@ static void __init ati_bugs(int num, int slot, int func)
 		printk(KERN_INFO "If you got timer trouble "
 		       "try acpi_use_timer_override\n");
 	}
-#endif
 }
+#else
+static void __init nvidia_bugs(int num, int slot, int func)
+{
+/* RED-PEN skip them on mptables too? */
+}
+static void __init ati_bugs(int num, int slot, int func) {}
+#endif /* !(CONFIG_ACPI && CONFIG_X86_IO_APIC)*/
 
 #ifdef CONFIG_DMAR
 static void __init intel_g33_dmar(int num, int slot, int func)
