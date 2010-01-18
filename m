Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069Ab0ARRT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab0ARRT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995Ab0ARRTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:19:25 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39792 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab0ARRTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mmRsfnWSLqJvkL5vcb2hk5vtu1jzGzxJgjw6wVQptF7wGVtj8yzSFuA1295ZgqrRX7
         C0TMYAsLZ6RNjgGFJU3+ygVBXZGc8TG02Fmg6zlAbZ05dYPmtD507mWgbOdHPGzxMDGo
         2ss/bKczNue/Lg3OdGHvwFiwW+3fNDKQrWdew=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:18:07 +0100
Message-Id: <20100118171807.14623.50469.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 29/64] alim15x3: cleanup ali_cable_detect()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: cleanup ali_cable_detect()

Remove leftover local_irq_[save,restore]() and FIXME note.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |    8 --------
 1 file changed, 8 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -345,19 +345,13 @@ static int ali_cable_override(struct pci
  *
  *	This checks if the controller and the cable are capable
  *	of UDMA66 transfers. It doesn't check the drives.
- *	But see note 2 below!
- *
- *	FIXME: frobs bits that are not defined on newer ALi devicea
  */
 
 static u8 ali_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	unsigned long flags;
 	u8 cbl = ATA_CBL_PATA40, tmpbyte;
 
-	local_irq_save(flags);
-
 	if (m5229_revision >= 0xC2) {
 		/*
 		 * m5229 80-pin cable detection (from Host View)
@@ -377,8 +371,6 @@ static u8 ali_cable_detect(ide_hwif_t *h
 		}
 	}
 
-	local_irq_restore(flags);
-
 	return cbl;
 }
 
