Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZA1FDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZA1FDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZA1FCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:02:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:50601 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZA1FCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:02:51 -0500
From: Kumar Gala <galak@kernel.crashing.org>
To: jeff@garzik.org
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, rjw@sisk.pl
Subject: [PATCH] ata_piix: Fix build breakage
Date: Tue, 27 Jan 2009 23:02:01 -0600
Message-Id: <1233118922-15350-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1233118922-15350-1-git-send-email-galak@kernel.crashing.org>
References: <1233118922-15350-1-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit introduces:

commit 5f451fe1ab5d73b987051f0d23c85216c552e163
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Jan 19 20:59:22 2009 +0100

    SATA PIIX: Blacklist system that spins off disks during ACPI power off

the following build errors on non-x86 systems:

drivers/ata/ata_piix.c: In function 'piix_broken_system_poweroff':
drivers/ata/ata_piix.c:1405: error: implicit declaration of function 'dmi_first_match'
drivers/ata/ata_piix.c:1405: warning: initialization makes pointer from integer without a cast

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/ata/ata_piix.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 54961c0..14874e1 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1389,6 +1389,7 @@ static void piix_iocfg_bit18_quirk(struct ata_host *host)
 
 static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 {
+#ifdef CONFIG_DMI
 	static const struct dmi_system_id broken_systems[] = {
 		{
 			.ident = "HP Compaq 2510p",
@@ -1409,6 +1410,7 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 		/* apply the quirk only to on-board controllers */
 		return slot == PCI_SLOT(pdev->devfn);
 	}
+#endif
 
 	return false;
 }
-- 
1.5.6.6

