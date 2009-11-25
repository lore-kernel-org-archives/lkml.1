Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbZKYRL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbZKYRL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbZKYRLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:11:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39574 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582AbZKYRLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JGDLbWiEWBf6kF5APsUqZ4KpbtrDUwBmueh1WEIgpDurD34aVPzilr7JhAlt0pDjL4
         oQnv1/oKusWKqOEKsLddpeZSpoqtElHPVBrxvMa5dDvXF4PwW2VKnW8JmwoTODPJjkhO
         NqKp6sOxSUdfglRgwyQP9a45vey4ybv0/mFFw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:11:07 +0100
Message-Id: <20091125171107.5446.66796.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 73/86] pata_serverworks: use standard cable detection methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: use standard cable detection methods

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_serverworks.c |   45 ++++++++++-------------------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -64,7 +64,8 @@ static const char *csb_bad_ata100[] = {
  *	bits of the subsystem ID.
  */
 
-static int dell_cable(struct ata_port *ap) {
+static int dell_cable(struct ata_port *ap)
+{
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
@@ -81,7 +82,8 @@ static int dell_cable(struct ata_port *a
  *	need to extend the Dell one in future
  */
 
-static int sun_cable(struct ata_port *ap) {
+static int sun_cable(struct ata_port *ap)
+{
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
@@ -89,29 +91,6 @@ static int sun_cable(struct ata_port *ap
 	return ATA_CBL_PATA40;
 }
 
-/**
- *	osb4_cable	-	OSB4 cable detect
- *	@ap: ATA port to check
- *
- *	The OSB4 isn't UDMA66 capable so this is easy
- */
-
-static int osb4_cable(struct ata_port *ap) {
-	return ATA_CBL_PATA40;
-}
-
-/**
- *	csb_cable	-	CSB5/6 cable detect
- *	@ap: ATA port to check
- *
- *	Serverworks default arrangement is to use the drive side detection
- *	only.
- */
-
-static int csb_cable(struct ata_port *ap) {
-	return ATA_CBL_PATA_UNK;
-}
-
 struct sv_cable_table {
 	int device;
 	int subvendor;
@@ -124,14 +103,14 @@ struct sv_cable_table {
  */
 
 static struct sv_cable_table cable_detect[] = {
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_VENDOR_ID_DELL, dell_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE, PCI_VENDOR_ID_DELL, dell_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_VENDOR_ID_SUN,  sun_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE, PCI_ANY_ID, osb4_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, PCI_ANY_ID, csb_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE, PCI_ANY_ID, csb_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2, PCI_ANY_ID, csb_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, csb_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, dell_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, dell_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  sun_cable  },
+	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE,   PCI_ANY_ID, ata_cable_40wire  },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2,  PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, ata_cable_unknown },
 	{ }
 };
 
