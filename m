Return-Path: <linux-kernel-owner+w=401wt.eu-S965093AbYBAHnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093AbYBAHnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935131AbYBAHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:13 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48075 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759262AbYBAHjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:10 -0500
Date: Fri, 1 Feb 2008 17:38:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010738.m117cWRh022738@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use IRQF_DISABLE in m68328serial.c
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use IRQF_DISABLED instead of obsolete IRQ_FLG_STD for request_irq() flags
in m68328serial.c driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/drivers/serial/68328serial.c linux-2.6.24-uc0/drivers/serial/68328serial.c
--- linux-2.6.24/drivers/serial/68328serial.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/drivers/serial/68328serial.c	2008-01-11 20:34:32.000000000 +1000
@@ -1410,7 +1410,7 @@ rs68328_init(void)
 
 	    if (request_irq(uart_irqs[i],
 			    rs_interrupt,
-			    IRQ_FLG_STD,
+			    IRQF_DISABLED,
 			    "M68328_UART", NULL))
                 panic("Unable to attach 68328 serial interrupt\n");
 	}
