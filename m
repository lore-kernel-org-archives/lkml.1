Return-Path: <linux-kernel-owner+w=401wt.eu-S935102AbYBHAdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102AbYBHAdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762812AbYBHAaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:30:55 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:45438 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762392AbYBHAan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:30:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=EaQiFk0BpczrCoz7KR+cnZ1HOa287vvqmjqsiorFtMPR+M39bVzP0EvrbNUK4fxcLJe1pActNDGvbptS9H4go+8ASkJxc7WZm9ddwAN46ZLp/odeInqW3SbiGYM6b10SVLXbO39Gy16hyzUzTSz0CdphvH8cEfTh3MCMcJJR9eA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:44:55 +0100
Message-Id: <20080208004455.17746.44570.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/18] ide: factor out cable detection from ide_init_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out cable detection from ide_init_port() to ide_port_cable_detect().

* Move ide_port_cable_detect() call to ide_device_add_all().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1364,7 +1364,10 @@ static void ide_init_port(ide_hwif_t *hw
 	/* call chipset specific routine for each enabled port */
 	if (d->init_hwif)
 		d->init_hwif(hwif);
+}
 
+static void ide_port_cable_detect(ide_hwif_t *hwif)
+{
 	if (hwif->cable_detect && (hwif->ultra_mask & 0x78)) {
 		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 			hwif->cbl = hwif->cable_detect(hwif);
@@ -1392,6 +1395,7 @@ int ide_device_add_all(u8 *idx, const st
 		mate = (i & 1) ? NULL : hwif;
 
 		ide_init_port(hwif, i & 1, d);
+		ide_port_cable_detect(hwif);
 		ide_port_init_devices(hwif);
 	}
 
