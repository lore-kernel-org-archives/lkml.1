Return-Path: <linux-kernel-owner+w=401wt.eu-S932720AbZKYRIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbZKYRIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932594AbZKYRIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:08:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbZKYRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Cf/r1rf61SASSObwyw8mWkEwq1wuoESf2mu1MPOoLzhqqbbiz7EV8EQ7UeUQPJmb/p
         sIqJsREkHV/syOTqy7x1syvhAS8qBskh7MNz1goTXUp6f3tW3SUyubwTPscSPcBPUEkw
         xRr7+F+LVWI+vvN1uBd3C+0z21diiky49c6vw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:07:26 +0100
Message-Id: <20091125170726.5446.18826.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 43/86] pata_it821x: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it821x: add 32-bit PIO support

There shouldn't be any problems with it as IDE it821x host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it821x.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: b/drivers/ata/pata_it821x.c
===================================================================
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -738,7 +738,7 @@ static int it821x_port_start(struct ata_
 	struct it821x_dev *itdev;
 	u8 conf;
 
-	int ret = ata_sff_port_start(ap);
+	int ret = ata_sff_port_start32(ap);
 	if (ret < 0)
 		return ret;
 
@@ -801,7 +801,7 @@ static struct scsi_host_template it821x_
 };
 
 static struct ata_port_operations it821x_smart_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 
 	.check_atapi_dma= it821x_check_atapi_dma,
 	.qc_issue	= it821x_smart_qc_issue,
@@ -815,7 +815,7 @@ static struct ata_port_operations it821x
 };
 
 static struct ata_port_operations it821x_passthru_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 
 	.check_atapi_dma= it821x_check_atapi_dma,
 	.sff_dev_select	= it821x_passthru_dev_select,
@@ -831,7 +831,7 @@ static struct ata_port_operations it821x
 };
 
 static struct ata_port_operations it821x_rdc_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 
 	.check_atapi_dma= it821x_check_atapi_dma,
 	.sff_dev_select	= it821x_passthru_dev_select,
