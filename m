Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbYDPW2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbYDPW2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYDPW1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:27:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:53952 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYDPW1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UogAPGNAeZZWy7UQ47RMYOpHlPcQ05ABzacaMiXYK+TkQ5Eb3MDbI3629P0KOsj3h2wctlZDdrHywz3AAg6hBD88Me20qXmZ0Y0nCpAaBesuOCzvQQHQC5WpZYqwhAyVl6ykR/skboHa7ZNOHqy4n6RjWj/ywmGvCYB3/j5Xo98=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] au1xxx-ide: add ->{in,out}put_data methods (take 2)
Date: Thu, 17 Apr 2008 00:14:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170014.26848.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2:

* Update ->{in,out}_data methods to take 'struct request *rq' argument.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch for the one in the IDE tree

 drivers/ide/mips/au1xxx-ide.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -88,6 +88,17 @@ void auide_outsw(unsigned long port, voi
 	ctp->cur_ptr = au1xxx_ddma_get_nextptr_virt(dp);
 }
 
+static void au1xxx_input_data(ide_drive_t *drive, struct request *rq,
+			      void *buf, unsigned int len)
+{
+	auide_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void au1xxx_output_data(ide_drive_t *drive, struct request *rq,
+			       void *buf, unsigned int len)
+{
+	auide_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
 #endif
 
 static void au1xxx_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -598,6 +609,9 @@ static int au_ide_probe(struct device *d
 	*/
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA	
+	hwif->input_data  = au1xxx_input_data;
+	hwif->output_data = au1xxx_output_data;
+
 	hwif->INSW                      = auide_insw;
 	hwif->OUTSW                     = auide_outsw;
 #endif
