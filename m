Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYC0XGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYC0XGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYC0XGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:06:10 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42176 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYC0XGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:06:09 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Date: Thu, 27 Mar 2008 17:10:12 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
       Tim Waugh <tim@cyberelk.net>, Phil Blundell <philb@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271710.13714.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap PNP probe code in #ifdef CONFIG_PNP.  We already do the same
for CONFIG_PCI.

Without this change, we'll have unresolved references to
pnp_get_resource() function when CONFIG_PNP=n.  (This is a
new interface that's not in mainline yet.)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/parport/parport_pc.c
===================================================================
--- work7.orig/drivers/parport/parport_pc.c	2008-03-27 16:10:52.000000000 -0600
+++ work7/drivers/parport/parport_pc.c	2008-03-27 17:01:00.000000000 -0600
@@ -3083,6 +3083,7 @@
 static int __init parport_pc_init_superio(int autoirq, int autodma) {return 0;}
 #endif /* CONFIG_PCI */
 
+#ifdef CONFIG_PNP
 
 static const struct pnp_device_id parport_pc_pnp_tbl[] = {
 	/* Standard LPT Printer Port */
@@ -3149,6 +3150,9 @@
 	.remove		= parport_pc_pnp_remove,
 };
 
+#else
+static struct pnp_driver parport_pc_pnp_driver;
+#endif /* CONFIG_PNP */
 
 static int __devinit parport_pc_platform_probe(struct platform_device *pdev)
 {
