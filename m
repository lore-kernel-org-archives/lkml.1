Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbXI1Odc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbXI1Odc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbXI1OdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:33:20 -0400
Received: from www.osadl.org ([213.239.205.134]:53411 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761932AbXI1OdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:33:18 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc8-mm2: Fix a compile problem in macb.c
Date: Fri, 28 Sep 2007 16:33:15 +0200
User-Agent: KMail/1.9.5
Organization: Linutronix
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Victor <andrew@sanpeople.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281633.15608.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling macb.c fails because the type of parameter 2 of macb_poll()
was changed from int* to int. Furthermore, a local variable was removed
but was still used inside the function. This patch fixes it.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

---
Index: linux-2.6.23-rc/drivers/net/macb.c
===================================================================
--- linux-2.6.23-rc.orig/drivers/net/macb.c	2007-09-27 12:55:21.000000000 +0200
+++ linux-2.6.23-rc/drivers/net/macb.c	2007-09-27 13:00:28.000000000 +0200
@@ -492,7 +492,7 @@
 	}
 
 	dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
-		(unsigned long)status, *budget);
+		(unsigned long)status, budget);
 
 	if (!(status & MACB_BIT(REC))) {
 		dev_warn(&bp->pdev->dev,
@@ -503,7 +503,7 @@
 	}
 
 	work_done = macb_rx(bp, budget);
-	if (work_done < orig_budget)
+	if (work_done < budget)
 		netif_rx_complete(dev, napi);
 
 	/*
