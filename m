Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYBKJu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYBKJu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYBKJuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:22 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:28207 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYBKJuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:19 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111050.372086035@suse.de>
In-Reply-To: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/8] CPA: Remove inline from static_protections
Message-Id: <20080211095017.6708F1B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:50:17 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:43:56.0235 (UTC) FILETIME=[9E9FB1B0:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The function is huge and called three times, so don't inline it.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -139,7 +139,7 @@ static unsigned long virt_to_direct(void
  * right (again, ioremap() on BIOS memory is not uncommon) so this function
  * checks and fixes these known static required protection bits.
  */
-static inline pgprot_t static_protections(pgprot_t prot, unsigned long address)
+static pgprot_t static_protections(pgprot_t prot, unsigned long address)
 {
 	pgprot_t forbidden = __pgprot(0);
 
