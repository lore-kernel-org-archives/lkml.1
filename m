Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab0CLRRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:17:18 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:47827 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238Ab0CLRRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:17:16 -0500
Date: Fri, 12 Mar 2010 18:17:13 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/serial/sunsab.c: adjust the constant used to initialize
 the interrupt_mask0 fields
Message-ID: <Pine.LNX.4.64.1003121816500.3043@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

SAB82532_ISR0_TCD is declared in drivers/serial/subsab.h as relating to a
status register, while SAB82532_IMR0_TCD is declared in the same file as
relating to a mask register.  The latter seems more appropriate for the
interrupt_mask0 field, and follows the strategy for initializing this field
elsewhere in the same file.

Both SAB82532_ISR0_TCD and SAB82532_IMR0_TCD have the same value.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/sunsab.c             |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/sunsab.c b/drivers/serial/sunsab.c
index d514e28..d2e0321 100644
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -474,7 +474,7 @@ static void sunsab_stop_rx(struct uart_port *port)
 {
 	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
 
-	up->interrupt_mask0 |= SAB82532_ISR0_TCD;
+	up->interrupt_mask0 |= SAB82532_IMR0_TCD;
 	writeb(up->interrupt_mask1, &up->regs->w.imr0);
 }
 
