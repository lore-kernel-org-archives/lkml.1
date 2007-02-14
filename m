Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbXBNUG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbXBNUG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932532AbXBNUG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:06:27 -0500
Received: from mta15.mail.adelphia.net ([68.168.78.77]:42671 "EHLO
	mta15.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbXBNUG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:06:26 -0500
Date: Wed, 14 Feb 2007 14:06:24 -0600
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: [patch 3/4] ipmi: add pci remove handling
Message-ID: <20070214200624.GC5364@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add pci_remove handling to the driver, so it will clean up if
the device is hot-removed.

Signed-off-by: Corey Minyard <minyard@acm.org>

Index: linux-2.6.19/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.19.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.19/drivers/char/ipmi/ipmi_si_intf.c
@@ -2191,12 +2191,15 @@ static int __devinit ipmi_pci_probe(stru
 		info->irq_setup = std_irq_setup;
 
 	info->dev = &pdev->dev;
+	pdev->dev->driver_data = info;
 
 	return try_smi_init(info);
 }
 
 static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
 {
+	struct smi_info *info = pdev->dev->driver_data;
+	cleanup_one_si(info);
 }
 
 #ifdef CONFIG_PM
