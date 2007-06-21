Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbXFUSL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbXFUSL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbXFUSLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:11:20 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:50047 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbXFUSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:11:20 -0400
Date: Thu, 21 Jun 2007 19:11:18 +0100
From: Ben Dooks <ben@fluff.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: SM501: only compile suspend/resume if CONFIG_PM
Message-ID: <20070621181118.GA6725@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The suspend and resume support only needs to be built if
CONFIG_PM is defined.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.21-quilt9/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.21-quilt9.orig/drivers/mfd/sm501.c
+++ linux-2.6.21-quilt9/drivers/mfd/sm501.c
@@ -1000,6 +1000,7 @@ static int sm501_plat_probe(struct platf
 
 }
 
+#ifdef CONFIG_PM
 /* power management support */
 
 static int sm501_plat_suspend(struct platform_device *pdev, pm_message_t state)
@@ -1045,7 +1046,10 @@ static int sm501_plat_resume(struct plat
 
 	return 0;
 }
-
+#else
+#define sm501_plat_suspend NULL
+#define sm501_plat_resume NULL
+#endif
 
 /* Initialisation data for PCI devices */
 
