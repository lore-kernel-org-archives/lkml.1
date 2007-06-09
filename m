Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbXFIIJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbXFIIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXFIIJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:09:14 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:37082
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177AbXFIIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:09:13 -0400
Message-ID: <466A600E.9020109@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 09:08:46 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: [PATCH 2/7] Replace DPRINTK with pr_debug in alternative.c
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org>
In-Reply-To: <466A5E28.2000707@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts all DPRINTKs in alternative.c to pr_debug

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---

--- linux/arch/i386/kernel/alternative.c	2007-06-07 17:25:46.000000000 +0100
+++ linux/arch/i386/kernel/alternative.c	2007-06-07 20:45:52.000000000 +0100
@@ -1,3 +1,4 @@
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
@@ -41,9 +42,6 @@
 __setup("noreplace-paravirt", setup_noreplace_paravirt);
 #endif

-#define DPRINTK(fmt, args...) if (debug_alternative) \
-	printk(KERN_DEBUG fmt, args)
-
 #ifdef GENERIC_NOP1
 /* Use inline assembly to define this because the nops are defined
    as inline assembly strings in the include files and we cannot
@@ -165,7 +163,7 @@
 	u8 *instr;
 	int diff;

-	DPRINTK("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
+	pr_debug("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
 	for (a = start; a < end; a++) {
 		BUG_ON(a->replacementlen > a->instrlen);
 		if (!boot_cpu_has(a->cpuid))
@@ -175,7 +173,7 @@
 		/* vsyscall code is not mapped yet. resolve it manually. */
 		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
 			instr = __va(instr - (u8*)VSYSCALL_START +
(u8*)__pa_symbol(&__vsyscall_0));
-			DPRINTK("%s: vsyscall fixup: %p => %p\n",
+			pr_debug("%s: vsyscall fixup: %p => %p\n",
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
@@ -261,7 +259,7 @@
 	smp->locks_end	= locks_end;
 	smp->text	= text;
 	smp->text_end	= text_end;
-	DPRINTK("%s: locks %p -> %p, text %p -> %p, name %s\n",
+	pr_debug("%s: locks %p -> %p, text %p -> %p, name %s\n",
 		__FUNCTION__, smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);

@@ -287,7 +285,7 @@
 			continue;
 		list_del(&item->next);
 		spin_unlock_irqrestore(&smp_alt, flags);
-		DPRINTK("%s: %s\n", __FUNCTION__, item->name);
+		pr_debug("%s: %s\n", __FUNCTION__, item->name);
 		kfree(item);
 		return;
 	}
