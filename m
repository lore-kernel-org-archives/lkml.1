Return-Path: <linux-kernel-owner+w=401wt.eu-S933037AbZKYRIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbZKYRIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932970AbZKYRIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:08:36 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906AbZKYRId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:08:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Kvpikbrgihze4yx/t3D943O6jCq+X39SwUxiifEL6ybevUgTLF24gtS9ZbH00JhjLh
         o++bHt3r4CxVNZzQs0NDQ+czWAz8SZ9K/6/pN9hHeHOhC7z+nA0zOdK0419qyAwr3eRw
         9dhX0azBm6xh24x61zsARYqc3V+IQoEShemW8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:07:55 +0100
Message-Id: <20091125170755.5446.40963.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 47/86] pata_legacy: fix access to control register for QDI6580
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_legacy: fix access to control register for QDI6580

We need to mask out the port offset from the port number
cached in ld_qdi->timing.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_legacy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_legacy.c
===================================================================
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -672,7 +672,7 @@ static void qdi6580dp_set_piomode(struct
 	outb(timing, ld_qdi->timing + 2 * ap->port_no);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, ld_qdi->timing + 3);
+		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
 }
 
 /**
@@ -707,7 +707,7 @@ static void qdi6580_set_piomode(struct a
 	outb(timing, ld_qdi->timing + 2 * adev->devno);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, ld_qdi->timing + 3);
+		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
 }
 
 /**
