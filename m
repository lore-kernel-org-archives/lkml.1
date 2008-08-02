Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbYHBRKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbYHBRKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbYHBRJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:09:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:7434 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbYHBRJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=lkX4eWmiQNAzpMIosrmxS7ozjLuBtUGZzA4jTZz2CkUH8m20J20Zs2JHtRyF9bw45r
         LAUuasid5PzigYHMhnPbnR1BBs0WHMjX/BbIxCj1wE8YjRKzWrL+l3snnBY6l0clrNCp
         XUlLz7wT0znvca9P0eegc5i/m9FquijOVCkro=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide: ->quirkproc method cannot be marked __devinit
Date: Sat, 2 Aug 2008 19:04:17 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021904.17798.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have warm-plug support ->quirkproc method no longer
can be be marked __devinit.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/it821x.c  |    2 +-
 drivers/ide/pci/siimage.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -442,7 +442,7 @@ static u8 __devinit it821x_cable_detect(
  *	final tuning that is needed, or fixups to work around bugs.
  */
 
-static void __devinit it821x_quirkproc(ide_drive_t *drive)
+static void it821x_quirkproc(ide_drive_t *drive)
 {
 	struct it821x_dev *itdev = ide_get_hwifdata(drive->hwif);
 	u16 *id = drive->id;
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -640,7 +640,7 @@ static int is_dev_seagate_sata(ide_drive
  *	that can occur before we know what drives are present.
  */
 
-static void __devinit sil_quirkproc(ide_drive_t *drive)
+static void sil_quirkproc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
