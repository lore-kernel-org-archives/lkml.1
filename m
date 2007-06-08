Return-Path: <linux-kernel-owner+w=401wt.eu-S971411AbXFHWdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971411AbXFHWdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971312AbXFHWdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:33:17 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:60893
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970611AbXFHWdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:33:15 -0400
Message-ID: <4669D65D.1000605@hawkeye.stone.uk.eu.org>
Date: Fri, 08 Jun 2007 23:21:17 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, raven@themaw.net
Subject: [PATCH 2/7] Replace DPRINTK with pr_debug in alternative.c
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
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

--

