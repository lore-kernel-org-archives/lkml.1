Return-Path: <linux-kernel-owner+w=401wt.eu-S933521AbZKYRLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbZKYRLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbZKYRLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:11:02 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39574 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400AbZKYRK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:10:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YMkauBbFa5lAgDy37WjX/HTTqz8po17raRFsrsyfsryz31RZNbfzL9Z5RxnrM05kTB
         gijQQa3t6FeQlGhUkVhZ4hI+mBxt++Vv3rAvLU0QarvoAfYlbqFx6ILmKy7njCtcd9IV
         0QNPH+14nktTZ8kt7tzr1SZjrrFPmJ6iNRx1c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:10:17 +0100
Message-Id: <20091125171017.5446.75887.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 66/86] pata_rz1000: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_rz1000: add 32-bit PIO support

There shouldn't be any problems with it as IDE rz1000 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_rz1000.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ata/pata_rz1000.c
===================================================================
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -58,6 +58,8 @@ static struct ata_port_operations rz1000
 	.inherits	= &ata_sff_port_ops,
 	.cable_detect	= ata_cable_40wire,
 	.set_mode	= rz1000_set_mode,
+	.sff_data_xfer	= ata_sff_data_xfer32,
+	.port_start	= ata_sff_port_start32,
 };
 
 static int rz1000_fifo_disable(struct pci_dev *pdev)
