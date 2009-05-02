Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbZEBUEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbZEBUEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbZEBUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:02:17 -0400
Received: from www.tglx.de ([62.245.132.106]:58475 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565AbZEBUCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:02:15 -0400
Message-Id: <20090502195926.117909052@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:01:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [patch 10/11] sh: remove obsolete hw_interrupt_type
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=sh-remove-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Mundt <lethal@linux-sh.org>

---
 arch/sh/kernel/cpu/irq/imask.c    |    2 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/sh/kernel/cpu/irq/imask.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/irq/imask.c
+++ linux-2.6/arch/sh/kernel/cpu/irq/imask.c
@@ -39,7 +39,7 @@ static unsigned int startup_imask_irq(un
 	return 0; /* never anything pending */
 }
 
-static struct hw_interrupt_type imask_irq_type = {
+static struct irq_chip imask_irq_type = {
 	.typename = "SR.IMASK",
 	.startup = startup_imask_irq,
 	.shutdown = shutdown_imask_irq,
Index: linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/irq/intc-sh5.c
+++ linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c
@@ -84,7 +84,7 @@ static void disable_intc_irq(unsigned in
 static void mask_and_ack_intc(unsigned int);
 static void end_intc_irq(unsigned int irq);
 
-static struct hw_interrupt_type intc_irq_type = {
+static struct irq_chip intc_irq_type = {
 	.typename = "INTC",
 	.startup = startup_intc_irq,
 	.shutdown = shutdown_intc_irq,


