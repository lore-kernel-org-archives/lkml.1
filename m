Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbXKGQxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbXKGQxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbXKGQw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:52:56 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39822 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753527AbXKGQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:52:55 -0500
Date: Wed, 7 Nov 2007 16:53:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dhowells@redhat.com, linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org
Subject: [PATCH] frv: Remove bogus NO_IRQ = -1 define
Message-ID: <20071107165300.6eeea2d8@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The old NO_IRQ define some platforms had was long ago declared obsolete
and wrong. FRV should therefore not be re-introducing this, especially as
IRQs are usually unsigned in the kernel. The "no IRQ" case is defined to be
zero and Linus made this rather clear at the time.

arch/frv shows no dependancy on this but it might show up driver fixes
needing doing I guess

Signed-off-by: Alan Cox <alan@redhat.com>

--- include/asm-frv//irq.h~	2007-11-07 16:35:09.927759328 +0000
+++ include/asm-frv/irq.h	2007-11-07 16:35:09.944756744 +0000
@@ -12,9 +12,6 @@
 #ifndef _ASM_IRQ_H_
 #define _ASM_IRQ_H_
 
-/* this number is used when no interrupt has been assigned */
-#define NO_IRQ				(-1)
-
 #define NR_IRQS				48
 #define IRQ_BASE_CPU			(0 * 16)
 #define IRQ_BASE_FPGA			(1 * 16)
