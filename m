Return-Path: <linux-kernel-owner+w=401wt.eu-S964822AbXBPNOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbXBPNOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964833AbXBPNOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:14:42 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3018 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964822AbXBPNOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:14:41 -0500
Date: Fri, 16 Feb 2007 14:15:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] parport_pc: Fix parport_pc_probe_port section warning
Message-Id: <20070216141510.baac6077.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/parport/parport_pc.o - Section mismatch: reference
to .init.text: from .text between 'parport_pc_probe_port' (at offset
0x14f7) and 'parport_pc_unregister_port'

parport_dma_probe() cannot be declared __devinit as it is called
from parport_pc_probe_port() which isn't.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/parport/parport_pc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.20-rc1.orig/drivers/parport/parport_pc.c	2006-12-17 16:08:05.000000000 +0100
+++ linux-2.6.20-rc1/drivers/parport/parport_pc.c	2006-12-17 17:36:47.000000000 +0100
@@ -1546,7 +1546,7 @@
 }
 #endif /* CONFIG_PARPORT_PC_SUPERIO */
 
-static int __devinit get_superio_dma (struct parport *p)
+static int get_superio_dma (struct parport *p)
 {
 	int i=0;
 	while( (superios[i].io != p->base) && (i<NR_SUPERIOS))
@@ -2106,7 +2106,7 @@
 /* --- DMA detection -------------------------------------- */
 
 /* Only if chipset conforms to ECP ISA Interface Standard */
-static int __devinit programmable_dma_support (struct parport *p)
+static int programmable_dma_support (struct parport *p)
 {
 	unsigned char oecr = inb (ECONTROL (p));
 	int dma;
@@ -2123,7 +2123,7 @@
 	return dma;
 }
 
-static int __devinit parport_dma_probe (struct parport *p)
+static int parport_dma_probe (struct parport *p)
 {
 	const struct parport_pc_private *priv = p->private_data;
 	if (priv->ecr)


-- 
Jean Delvare
