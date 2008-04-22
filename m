Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbYDVS0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbYDVS0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYDVS0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:26:46 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:40015 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbYDVS0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:26:46 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pci_try_set_mwi() in sata_promise
Date: Tue, 22 Apr 2008 21:26:56 +0300
User-Agent: KMail/1.9.7
Cc: Jeff Garzik <jgarzik@pobox.com>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804222126.56321.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The BIOS (Asus A8V Deluxe) is setting incorrectly PCI
Cache Line Size Register (as seen in lspci -vvv output), 
so try to correct it by pci_try_set_mwi(pdev).

Marin Mitov
----------------------------------------------------------
Enable Memory-Write-and-Invalidate in sata_promise driver and 
get rid of strange BIOS-set value for cache line size register.

According to Documentation/pci.txt:  "This enables...
...and also ensures that the cache line size register
is set correctly".

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
----------------------------------------------------------
--- a/drivers/ata/sata_promise.c	2008-04-22 13:09:15.000000000 +0300
+++ b/drivers/ata/sata_promise.c	2008-04-22 13:11:01.000000000 +0300
@@ -1114,6 +1114,7 @@ static int pdc_ata_init_one(struct pci_d

 	/* start host, request IRQ and attach */
 	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
 	return ata_host_activate(host, pdev->irq, pdc_interrupt, IRQF_SHARED,
 				 &pdc_ata_sht);
 }


