Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYLPTd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYLPTd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbYLPTcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:32:15 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33945 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbYLPTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:32:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=uARh8p2OlBdfZkIfcga7WFg7vPGsGk2ohZKl+4i5ZnZYkyDTPxWPn4R3TYNkG2odl5
         lcAOIDZiws/xo5P2bCl8qLZvwB6hI6jrA0jqsp5A/wKfmURjYpDqJNa4WMayKUGbHGIX
         tRFJn8xZG25tDR4FUFRiRYF4m+NT5B4SjuBaM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2008 20:32:04 +0100
Message-Id: <20081216193204.3959.51518.sendpatchset@localhost.localdomain>
In-Reply-To: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
References: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] ide: remove ide_pci_enablebit_t typedef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ide_pci_enablebit_t typedef

Remove needless parens while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |    2 +-
 include/linux/ide.h     |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -471,7 +471,7 @@ void ide_pci_setup_ports(struct pci_dev 
 	 */
 
 	for (port = 0; port < channels; ++port) {
-		const ide_pci_enablebit_t *e = &(d->enablebits[port]);
+		const struct ide_pci_enablebit *e = &d->enablebits[port];
 
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val)) {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1301,11 +1301,11 @@ static inline int ide_hwif_setup_dma(ide
 }
 #endif
 
-typedef struct ide_pci_enablebit_s {
+struct ide_pci_enablebit {
 	u8	reg;	/* byte pci reg holding the enable-bit */
 	u8	mask;	/* mask to isolate the enable-bit */
 	u8	val;	/* value of masked reg when "enabled" */
-} ide_pci_enablebit_t;
+};
 
 enum {
 	/* Uses ISA control ports not PCI ones. */
@@ -1394,7 +1394,8 @@ struct ide_port_info {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	ide_pci_enablebit_t	enablebits[2];
+	struct ide_pci_enablebit	enablebits[2];
+
 	hwif_chipset_t		chipset;
 
 	u16			max_sectors;	/* if < than the default one */
