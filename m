Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbXKIGEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbXKIGEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXKIGDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:03:48 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52868 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751797AbXKIGDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:03:47 -0500
Date: Fri, 9 Nov 2007 07:03:23 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86 e820_64.c: make 2 functions static
Message-ID: <20071109060323.GU26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- e820_print_map()
- early_panic()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/e820_64.c |    4 ++--
 include/asm-x86/e820_64.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

a57254863b322df7232405b71e4ce5a792143b36 
diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index 04698e0..182586a 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -363,7 +363,7 @@ unsigned long __init e820_hole_size(unsigned long start, unsigned long end)
 	return end - start - (ram << PAGE_SHIFT);
 }
 
-void __init e820_print_map(char *who)
+static void __init e820_print_map(char *who)
 {
 	int i;
 
@@ -587,7 +587,7 @@ static int __init copy_e820_map(struct e820entry * biosmap, int nr_map)
 	return 0;
 }
 
-void early_panic(char *msg)
+static void early_panic(char *msg)
 {
 	early_printk(msg);
 	panic(msg);
diff --git a/include/asm-x86/e820_64.h b/include/asm-x86/e820_64.h
index 0bd4787..e535e60 100644
--- a/include/asm-x86/e820_64.h
+++ b/include/asm-x86/e820_64.h
@@ -21,7 +21,6 @@ extern void contig_e820_setup(void);
 extern unsigned long e820_end_of_ram(void);
 extern void e820_reserve_resources(void);
 extern void e820_mark_nosave_regions(void);
-extern void e820_print_map(char *who);
 extern int e820_any_mapped(unsigned long start, unsigned long end, unsigned type);
 extern int e820_all_mapped(unsigned long start, unsigned long end, unsigned type);
 extern unsigned long e820_hole_size(unsigned long start, unsigned long end);

