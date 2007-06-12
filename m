Return-Path: <linux-kernel-owner+w=401wt.eu-S1751260AbXFLHYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbXFLHYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXFLHX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:23:59 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51874 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751728AbXFLHX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:23:58 -0400
Message-Id: <466E665E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 09:24:46 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: minor nx handling adjustment
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Constrain __supported_pte_mask and NX handling to just the PAE kernel.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/mm/init.c     |    7 ++++---
 include/asm-i386/page.h |    1 -
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc4/arch/i386/mm/init.c	2007-06-11 18:09:52.000000000 +0200
+++ 2.6.22-rc4-i386-supported_pte_mask/arch/i386/mm/init.c	2007-06-01 17:45:18.000000000 +0200
@@ -471,6 +471,10 @@ void zap_low_mappings (void)
 	flush_tlb_all();
 }
 
+int nx_enabled = 0;
+
+#ifdef CONFIG_X86_PAE
+
 static int disable_nx __initdata = 0;
 u64 __supported_pte_mask __read_mostly = ~_PAGE_NX;
 
@@ -499,9 +503,6 @@ static int __init noexec_setup(char *str
 }
 early_param("noexec", noexec_setup);
 
-int nx_enabled = 0;
-#ifdef CONFIG_X86_PAE
-
 static void __init set_nx(void)
 {
 	unsigned int v[4], l, h;
--- linux-2.6.22-rc4/include/asm-i386/page.h	2007-06-11 18:10:43.000000000 +0200
+++ 2.6.22-rc4-i386-supported_pte_mask/include/asm-i386/page.h	2007-06-01 17:45:18.000000000 +0200
@@ -43,7 +43,6 @@
 extern int nx_enabled;
 
 #ifdef CONFIG_X86_PAE
-extern unsigned long long __supported_pte_mask;
 typedef struct { unsigned long pte_low, pte_high; } pte_t;
 typedef struct { unsigned long long pmd; } pmd_t;
 typedef struct { unsigned long long pgd; } pgd_t;



