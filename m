Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZA1FCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZA1FCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZA1FCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:02:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:50595 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZA1FCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:02:40 -0500
From: Kumar Gala <galak@kernel.crashing.org>
To: jeff@garzik.org
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, rjw@sisk.pl
Subject: [PATCH] ahci: Fix build breakage
Date: Tue, 27 Jan 2009 23:02:00 -0600
Message-Id: <1233118922-15350-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit introduces:

commit 1fd684346d41f6be2487c161f60d03a7feb68911
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Jan 19 20:57:36 2009 +0100

    SATA AHCI: Blacklist system that spins off disks during ACPI power off

the following errors on non-x86 systems:

drivers/ata/ahci.c: In function 'ahci_broken_system_poweroff':
drivers/ata/ahci.c:2566: error: implicit declaration of function 'dmi_first_match'
drivers/ata/ahci.c:2566: warning: initialization makes pointer from integer without a cast

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/ata/ahci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 77bba4c..2c84f53 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2550,6 +2550,7 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 
 static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 {
+#ifdef CONFIG_DMI
 	static const struct dmi_system_id broken_systems[] = {
 		{
 			.ident = "HP Compaq nx6310",
@@ -2570,6 +2571,7 @@ static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 		/* apply the quirk only to on-board controllers */
 		return slot == PCI_SLOT(pdev->devfn);
 	}
+#endif
 
 	return false;
 }
-- 
1.5.6.6

