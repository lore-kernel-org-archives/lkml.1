Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYBJW7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYBJW7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYBJW65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:58:57 -0500
Received: from www.tglx.de ([62.245.132.106]:43393 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYBJW65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:58:57 -0500
Date: Sun, 10 Feb 2008 23:57:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: remove over noisy debug printk
Message-ID: <alpine.LFD.1.00.0802102341460.12988@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pageattr-test.c contains a noisy debug printk that people reported. 
The condition under which it prints (randomly tapping into a mem_map[]
hole and not being able to c_p_a() there) is valid behavior and not
interesting to report.

Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pageattr-test.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6/arch/x86/mm/pageattr-test.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pageattr-test.c
+++ linux-2.6/arch/x86/mm/pageattr-test.c
@@ -40,7 +40,6 @@ struct split_state {
 static int print_split(struct split_state *s)
 {
 	long i, expected, missed = 0;
-	int printed = 0;
 	int err = 0;
 
 	s->lpg = s->gpg = s->spg = s->exec = 0;
@@ -53,12 +52,6 @@ static int print_split(struct split_stat
 
 		pte = lookup_address(addr, &level);
 		if (!pte) {
-			if (!printed) {
-				dump_pagetable(addr);
-				printk(KERN_INFO "CPA %lx no pte level %d\n",
-					addr, level);
-				printed = 1;
-			}
 			missed++;
 			i++;
 			continue;
