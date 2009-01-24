Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbZAXOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbZAXOX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbZAXOVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:21:32 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:60595 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbZAXOVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:21:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Pze1t4M8q/WO+3TAbRJuLQWMx6sB8hgrn+j4slRM2TpF33gkOjwMxHn7n8XR7xBzT7
         uIguW0QEjLNSwXSS47K+weborOmIECsi2ej8qY2tclOqHfJl3nM3Gs6YZ/BpfTbKYaoo
         uHV5LaAmDDhIKAWJQi8NoEqKIFFOnHvwKoMKc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-pnp: use struct ide_port_info
Date: Sat, 24 Jan 2009 15:17:00 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901241517.00398.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-pnp: use struct ide_port_info

This fixes hwif->channel and drive->dn assignments.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-pnp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -27,6 +27,10 @@ static struct pnp_device_id idepnp_devic
 	{.id = ""}
 };
 
+static const struct ide_port_info ide_pnp_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	struct ide_host *host;
@@ -60,7 +64,7 @@ static int idepnp_probe(struct pnp_dev *
 	hw.irq = pnp_irq(dev, 0);
 	hw.chipset = ide_generic;
 
-	rc = ide_host_add(NULL, hws, &host);
+	rc = ide_host_add(&ide_pnp_port_info, hws, &host);
 	if (rc)
 		goto out;
 
