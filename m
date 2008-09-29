Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYI2RXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYI2RXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYI2RW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:22:58 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:35317 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYI2RW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:22:57 -0400
Date: Mon, 29 Sep 2008 19:24:07 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       sfr@canb.auug.org.au
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: enable CPUID on Cyrix cpus with CPUID disabled
Message-Id: <20080929192407.1c31fe90.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 7ac0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

The macros setCx86_old() and getCx86_old() do not
work as a comment says in the processor-cyrix.h.

Use working inline functions instead to enable
the CPUID instriction on Cyrix cpus. 

Tested on IBM 6x86MX cpu with disabled the
CPUID instruction.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

This patch is against the linux-next tree (20080819)
as it contains the following patch:

x86, cyrix: debug
Signed-off-by: Ingo Molnar <mingo@elte.hu>

http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=026e2c05ef58ef413e2d52696f125d5ea1aa8bce

The linux-2.6-tip tree has not the Ingo's patch so it 
does not require my patch.

I am confused. Is the x86 detection code for Cyrix
cpus is right in the linux-next or in the linux-2.6-tip?
Should I prepare patches against the linux-2.6-tip
or linux-next?

diff -urp linux-orig/arch/x86/kernel/cpu/cyrix.c linux-2.6.27/arch/x86/kernel/cpu/cyrix.c
--- linux-orig/arch/x86/kernel/cpu/cyrix.c	2008-09-29 00:16:31.000000000 +0200
+++ linux-2.6.27/arch/x86/kernel/cpu/cyrix.c	2008-09-29 17:03:52.563864398 +0200
@@ -428,7 +428,7 @@ static void __cpuinit cyrix_identify(str
 			local_irq_save(flags);
 			ccr3 = getCx86(CX86_CCR3);
 			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);       /* enable MAPEN  */
-			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);  /* enable cpuid  */
+			setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x80);  /* enable cpuid  */
 			setCx86(CX86_CCR3, ccr3);                       /* disable MAPEN */
 			local_irq_restore(flags);
 		}

----------------------------------------------------------------------
Dzwon taniej na zagraniczne komorki!
Sprawdz >> http://link.interia.pl/f1f26 

