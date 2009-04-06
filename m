Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZDFNKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZDFNKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZDFNKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:10:11 -0400
Received: from vsmtp4.tin.it ([212.216.176.224]:48542 "EHLO vsmtp4.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZDFNKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:10:09 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 09:10:09 EDT
Date: Mon, 6 Apr 2009 15:03:53 +0200 (CEST)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: jgarzik@pobox.com
cc: linux-kernel@vger.kernel.org
Subject: nvida sata controller CK804  and  NCQ not working on linux-2.6.28||29.1
Message-ID: <Pine.LNX.4.64.0904061458540.3110@Phoenix.oltrelinux.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
to make NCQ work with nvidia sata CK804 I had to introduce this simple 
change into sata-nv.c. Is there some reason I am missing why adma_enable 
is not by default one, so later in the dome NCQ is not enabled?



--- linux/drivers/ata/sata_nv.c.old     2009-04-06 14:56:19.000000000 
+0200
+++ linux/drivers/ata/sata_nv.c 2009-04-06 14:56:24.000000000 +0200
@@ -577,7 +577,7 @@
  MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
  MODULE_VERSION(DRV_VERSION);

-static int adma_enabled;
+static int adma_enabled = 1;
  static int swncq_enabled = 1;

  static void nv_adma_register_mode(struct ata_port *ap)

regards

Luigi Genoni
