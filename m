Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZLUH3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZLUH3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZLUH3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:29:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:41715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbZLUH3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:29:32 -0500
Message-ID: <4B2F237F.3040909@kernel.org>
Date: Sun, 20 Dec 2009 23:27:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix size for ex trampoline with 32bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



fix for error that is introduced by
| x86: Use find_e820() instead of hard coded trampoline address

it should end with PAGE_SIZE + PAGE_SIZE

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -733,13 +733,13 @@ struct early_res {
 };
 static struct early_res early_res[MAX_EARLY_RES] __initdata = {
 	{ 0, PAGE_SIZE, "BIOS data page", 1 },	/* BIOS data page */
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && defined(CONFIG_X86_TRAMPOLINE)
 	/*
 	 * But first pinch a few for the stack/trampoline stuff
 	 * FIXME: Don't need the extra page at 4K, but need to fix
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
-	{ PAGE_SIZE, PAGE_SIZE, "EX TRAMPOLINE", 1 },
+	{ PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE", 1 },
 #endif
 
 	{}
