Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYC3Tbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYC3Tbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYC3Ta7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:30:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:29692 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYC3Tau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BMQoS08mc3ft2b3XymQ68BBeg0e7xhcl0hWU44zRfOqvbAEZ+yCDauZCkg0jUZQWfhR/9BQ/aqMwDujcoQFkHnbmL/Sk+3vXsw0zbnyWVl3GJmz26g/0897ghEajpJXpEOBrTxtI9DwYe9PNh7nVM9rtxTax1B8Y5PlhbVORIZ8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/6] au1xxx-ide: add ->{in,out}put_data methods
Date: Sun, 30 Mar 2008 21:42:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302142.07004.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/mips/au1xxx-ide.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -93,6 +93,15 @@ void auide_outsw(unsigned long port, voi
 	ctp->cur_ptr = au1xxx_ddma_get_nextptr_virt(dp);
 }
 
+static void au1xxx_input_data(ide_drive_t *drive, void *buf, unsigned int len)
+{
+	auide_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void au1xxx_output_data(ide_drive_t *drive, void *buf, unsigned int len)
+{
+	auide_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
 #endif
 
 static void au1xxx_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -602,6 +611,9 @@ static int au_ide_probe(struct device *d
 	*/
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA	
+	hwif->input_data  = au1xxx_input_data;
+	hwif->output_data = au1xxx_output_data;
+
 	hwif->INSW                      = auide_insw;
 	hwif->OUTSW                     = auide_outsw;
 #endif
