Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbZDGVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbZDGVlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760728AbZDGVkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:40:42 -0400
Received: from grfedg702rm001.telecomitalia.it ([217.169.121.21]:21865 "EHLO
	GRFEDG702RM001.telecomitalia.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756321AbZDGVkm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:40:42 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 17:40:41 EDT
From: Genoni Luigi <luigi.genoni@telecomitalia.it>
To: "jgarzik@pobox.com" <jgarzik@pobox.com>, "tj@kernel.org" <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Apr 2009 23:34:59 +0200
Subject: nvida sata controller CK804  and  NCQ not working on
 linux-2.6.28||29.1
Thread-Topic: nvida sata controller CK804  and  NCQ not working on
 linux-2.6.28||29.1
Thread-Index: AQHJt8izCA3CCCYeA02x2UTVNF8w4A==
Message-ID: <8260162D332466469A1DD3FB317C18882E665616BA@GRFMBX706RM001.griffon.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
to make NCQ work with nvidia sata CK804 I had to introduce this simple
change into sata-nv.c. Is there some reason I am missing why adma_enable is
not by default one, so later in the dome NCQ is not enabled?



--- linux/drivers/ata/sata_nv.c.old     2009-04-06 14:56:19.000000000 +0200
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

Questo messaggio e i suoi allegati sono indirizzati esclusivamente alle persone indicate. La diffusione, copia o qualsiasi altra azione derivante dalla conoscenza di queste informazioni sono rigorosamente vietate. Qualora abbiate ricevuto questo documento per errore siete cortesemente pregati di darne immediata comunicazione al mittente e di provvedere alla sua distruzione, Grazie.

This e-mail and any attachments is confidential and may contain privileged information intended for the addressee(s) only. Dissemination, copying, printing or use by anybody else is unauthorised. If you are not the intended recipient, please delete this message and any attachments and advise the sender by return e-mail, Thanks.

