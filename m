Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYKLMbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYKLMbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYKLMbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:31:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43781 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYKLMbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:31:41 -0500
Date: Wed, 12 Nov 2008 13:49:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] Fix warning with !CONFIG_X86_RESERVE_LOW_64K
Message-ID: <20081112124910.GA30832@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Sent this patch earlier together with another, but it seems to have escaped 
your attention.]

Fix warning with !CONFIG_X86_RESERVE_LOW_64K

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.28-rc4-test/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.28-rc4-test.orig/arch/x86/kernel/setup.c	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-rc4-test/arch/x86/kernel/setup.c	2008-11-10 09:06:00.000000000 +0100
@@ -738,6 +738,7 @@
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -749,6 +750,7 @@
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
