Return-Path: <linux-kernel-owner+w=401wt.eu-S965094AbXCAOa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094AbXCAOa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965106AbXCAOa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:30:57 -0500
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:2545 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115AbXCAOa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:30:56 -0500
Date: Thu, 1 Mar 2007 13:57:11 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH 2.6.21-rc2] dz: Remove struct pt_regs references
Message-ID: <Pine.LNX.4.64N.0703011326490.25556@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove remaining references to saved registers now that 
uart_handle_sysrq_char() does not want them.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---

 The driver does not build without this update.

 Please apply.

  Maciej

patch-mips-2.6.21-rc1-20070222-dz-pt_regs-0
diff -up --recursive --new-file linux-mips-2.6.21-rc1-20070222.macro/drivers/serial/dz.c linux-mips-2.6.21-rc1-20070222/drivers/serial/dz.c
--- linux-mips-2.6.21-rc1-20070222.macro/drivers/serial/dz.c	2007-02-05 16:38:50.000000000 +0000
+++ linux-mips-2.6.21-rc1-20070222/drivers/serial/dz.c	2007-03-01 01:36:56.000000000 +0000
@@ -170,8 +170,7 @@ static void dz_enable_ms(struct uart_por
  * This routine deals with inputs from any lines.
  * ------------------------------------------------------------
  */
-static inline void dz_receive_chars(struct dz_port *dport_in,
-				    struct pt_regs *regs)
+static inline void dz_receive_chars(struct dz_port *dport_in)
 {
 	struct dz_port *dport;
 	struct tty_struct *tty = NULL;
@@ -226,7 +225,7 @@ static inline void dz_receive_chars(stru
 			break;
 		}
 
-		if (uart_handle_sysrq_char(&dport->port, ch, regs))
+		if (uart_handle_sysrq_char(&dport->port, ch))
 			continue;
 
 		if ((status & dport->port.ignore_status_mask) == 0) {
@@ -332,7 +331,7 @@ static irqreturn_t dz_interrupt(int irq,
 	status = dz_in(dport, DZ_CSR);
 
 	if ((status & (DZ_RDONE | DZ_RIE)) == (DZ_RDONE | DZ_RIE))
-		dz_receive_chars(dport, regs);
+		dz_receive_chars(dport);
 
 	if ((status & (DZ_TRDY | DZ_TIE)) == (DZ_TRDY | DZ_TIE))
 		dz_transmit_chars(dport);
patch-mips-2.6.21-rc1-20070222-dz-pt_regs-0
