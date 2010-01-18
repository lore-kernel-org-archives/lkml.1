Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224Ab0ARRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0ARRa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871Ab0ARRSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:18:21 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab0ARRSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=u+BchlAVxpxHnP2mS4zM8xja0yyvxwj4mrJWDSOGmhwUFDexQU9Twtht9dh2EmDI6L
         eVUteyVkZPorG9SPLfrevoxLtx+l9mnqS7lz9ZQ36CvdFRcqL24XmKBY7jOxGWvwaJkv
         mbHhZ2knGbol4zerqV6/f3bcHZ3pgenWJWLcg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:16:55 +0100
Message-Id: <20100118171655.14623.12567.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 21/64] pata_serverworks: cleanup cable detection
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: cleanup cable detection

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_serverworks.c |   37 +++++++------------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -57,32 +57,14 @@ static const char *csb_bad_ata100[] = {
 };
 
 /**
- *	dell_cable	-	Dell serverworks cable detection
+ *	oem_cable	-	Dell/Sun serverworks cable detection
  *	@ap: ATA port to do cable detect
  *
- *	Dell hide the 40/80 pin select for their interfaces in the top two
- *	bits of the subsystem ID.
+ *	Dell PowerEdge and Sun Cobalt 'Alpine' hide the 40/80 pin select
+ *	for their interfaces in the top two bits of the subsystem ID.
  */
 
-static int dell_cable(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
-		return ATA_CBL_PATA80;
-	return ATA_CBL_PATA40;
-}
-
-/**
- *	sun_cable	-	Sun Cobalt 'Alpine' cable detection
- *	@ap: ATA port to do cable select
- *
- *	Cobalt CSB5 IDE hides the 40/80pin in the top two bits of the
- *	subsystem ID the same as dell. We could use one function but we may
- *	need to extend the Dell one in future
- */
-
-static int sun_cable(struct ata_port *ap)
+static int oem_cable(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
@@ -97,15 +79,10 @@ struct sv_cable_table {
 	int (*cable_detect)(struct ata_port *ap);
 };
 
-/*
- *	Note that we don't copy the old serverworks code because the old
- *	code contains obvious mistakes
- */
-
 static struct sv_cable_table cable_detect[] = {
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, dell_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, dell_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  sun_cable  },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  oem_cable },
 	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE,   PCI_ANY_ID, ata_cable_40wire  },
 	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_ANY_ID, ata_cable_unknown },
 	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_ANY_ID, ata_cable_unknown },
