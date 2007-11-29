Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbXLFMpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbXLFMpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbXLFMmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:44 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53707 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXLFMmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:12 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <b703fe57ecba57fc7fd3c9f0521e5acf5c6a340a.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 18:11:12 +0100
Subject: [PATCH 11/47] Minor fixes to CRISv32 irq defines.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Include files using <>
- Change NR_REAL_IRQS to be calculated from the other defines.
- Set MACH_IRQS depending on the value of NR_REAL_IRQS.
- Remove unused mask parameter to BUILD_IRQ macro.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/arch-v32/irq.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/asm-cris/arch-v32/irq.h b/include/asm-cris/arch-v32/irq.h
index bac94ee..9e4c9fb 100644
--- a/include/asm-cris/arch-v32/irq.h
+++ b/include/asm-cris/arch-v32/irq.h
@@ -1,12 +1,17 @@
 #ifndef _ASM_ARCH_IRQ_H
 #define _ASM_ARCH_IRQ_H
 
-#include "hwregs/intr_vect.h"
+#include <hwregs/intr_vect.h>
 
 /* Number of non-cpu interrupts. */
-#define NR_IRQS 0x50 /* Exceptions + IRQs */
-#define NR_REAL_IRQS 0x20 /* IRQs */
+#define NR_IRQS NBR_INTR_VECT /* Exceptions + IRQs */
 #define FIRST_IRQ 0x31 /* Exception number for first IRQ */
+#define NR_REAL_IRQS (NBR_INTR_VECT - FIRST_IRQ) /* IRQs */
+#if NR_REAL_IRQS > 32
+#define MACH_IRQS 64
+#else
+#define MACH_IRQS 32
+#endif
 
 #ifndef __ASSEMBLY__
 /* Global IRQ vector. */
@@ -73,7 +78,7 @@ void set_exception_vector(int n, irqvectptr addr);
  * which will acknowledge the interrupt, is run. The actual blocking is made
  * by crisv32_do_IRQ.
  */
-#define BUILD_IRQ(nr, mask)		\
+#define BUILD_IRQ(nr)		        \
 void IRQ_NAME(nr);			\
 __asm__ (				\
 	".text\n\t"			\
@@ -81,7 +86,7 @@ __asm__ (				\
 	SAVE_ALL			\
 	KGDB_FIXUP                      \
 	"move.d "#nr",$r10\n\t"		\
-	"move.d $sp,$r12\n\t"		\
+	"move.d $sp, $r12\n\t"          \
 	"jsr crisv32_do_IRQ\n\t"       	\
 	"moveq 1, $r11\n\t"		\
 	"jump ret_from_intr\n\t"	\
-- 
1.5.3.6.970.gd25430

