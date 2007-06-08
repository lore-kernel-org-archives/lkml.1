Return-Path: <linux-kernel-owner+w=401wt.eu-S1030830AbXFHQn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030830AbXFHQn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969576AbXFHQmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:42:11 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:25217 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S969286AbXFHQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:42:10 -0400
Date: Fri, 08 Jun 2007 10:45:09 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 3/6] driver edac fix ignored return i82875p
Message-ID: <46698795.mH5LubX8ifdr3G2S%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Compiling this module gave a warning that the return
value of 'pci_bus_add_device()' was not checked.

This patch adds that check and an output message

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
Cc:	alan@lxorguk.ukuu.org.uk
---


Index: linux-2.6.22-rc4-mm1/drivers/edac/i82875p_edac.c
===================================================================
--- linux-2.6.22-rc4-mm1.orig/drivers/edac/i82875p_edac.c
+++ linux-2.6.22-rc4-mm1/drivers/edac/i82875p_edac.c
@@ -270,6 +270,7 @@ static int i82875p_setup_overfl_dev(stru
 {
 	struct pci_dev *dev;
 	void __iomem *window;
+	int err;
 
 	*ovrfl_pdev = NULL;
 	*ovrfl_window = NULL;
@@ -287,7 +288,12 @@ static int i82875p_setup_overfl_dev(stru
 		if (dev == NULL)
 			return 1;
 
-		pci_bus_add_device(dev);
+		err = pci_bus_add_device(dev);
+		if (err) {
+			i82875p_printk(KERN_ERR,
+				"%s(): pci_bus_add_device() Failed\n",
+				__func__);
+		}
 	}
 
 	*ovrfl_pdev = dev;
