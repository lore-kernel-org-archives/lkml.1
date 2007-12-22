Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbXLVMhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbXLVMhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 07:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXLVMhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 07:37:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45769 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbXLVMhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 07:37:01 -0500
Date: Sat, 22 Dec 2007 04:35:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, shemminger@linux-foundation.org
Subject: [patch] opt the sky2 driver into using extended config space
Message-ID: <20071222043559.105e0a6c@laptopd505.fenrus.org>
In-Reply-To: <20071222043139.0cd59804@laptopd505.fenrus.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: opt the sky2 driver into using extended config space

So far, the sky2 driver is the only one I've identified (with a quick grep)
that actually would be using extended configuration space; the patch below
adds the enablement of this to the driver.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
CC: shemminger@linux-foundation.org


Index: linux-2.6.24-rc5/drivers/net/sky2.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/net/sky2.c
+++ linux-2.6.24-rc5/drivers/net/sky2.c
@@ -4111,6 +4111,11 @@ static int __devinit sky2_probe(struct p
 		goto err_out;
 	}
 
+	/*
+	 * enable extended config space to enable AER
+	 */
+	pci_enable_ext_config(pdev);
+
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
 		dev_err(&pdev->dev, "cannot obtain PCI resources\n");
