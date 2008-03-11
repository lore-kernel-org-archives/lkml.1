Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYCKPob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYCKPob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYCKPoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:44:22 -0400
Received: from aun.it.uu.se ([130.238.12.36]:38639 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbYCKPoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:44:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18390.43171.335608.379379@harpo.it.uu.se>
Date: Tue, 11 Mar 2008 16:43:31 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH 2.6.25-rc5] x86: correct/clarify comment in nops.h
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<asm-x86/nops.h> describes certain multibyte instructions as
"generic" nops when in fact they aren't nops at all in 64-bit
mode (missing REX.W causing truncation of a register).

Update the comment to state that K8 or P6 style nops should be
used in 64-bit mode. This matches what the alternatives code does.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
diff -rupN linux-2.6.25-rc5/include/asm-x86/nops.h linux-2.6.25-rc5.x86-generic-nops-arent/include/asm-x86/nops.h
--- linux-2.6.25-rc5/include/asm-x86/nops.h	2008-03-10 20:05:39.000000000 +0100
+++ linux-2.6.25-rc5.x86-generic-nops-arent/include/asm-x86/nops.h	2008-03-11 16:22:22.000000000 +0100
@@ -5,6 +5,8 @@
 
 /* generic versions from gas
    1: nop
+   the following instructions are NOT nops in 64-bit mode,
+   for 64-bit mode use K8 or P6 nops instead
    2: movl %esi,%esi
    3: leal 0x00(%esi),%esi
    4: leal 0x00(,%esi,1),%esi
