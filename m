Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZA1FDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZA1FDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZA1FCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:02:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:50599 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZA1FCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:02:48 -0500
From: Kumar Gala <galak@kernel.crashing.org>
To: jeff@garzik.org
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, rjw@sisk.pl
Subject: [PATCH] sata_sil: Fix build breakage
Date: Tue, 27 Jan 2009 23:02:02 -0600
Message-Id: <1233118922-15350-3-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1233118922-15350-2-git-send-email-galak@kernel.crashing.org>
References: <1233118922-15350-1-git-send-email-galak@kernel.crashing.org>
 <1233118922-15350-2-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit introduces:

commit e57db7bde7bff95ae812736ca00c73bd5271455b
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Jan 19 20:58:29 2009 +0100

    SATA Sil: Blacklist system that spins off disks during ACPI power off

the following build errors on non-x86 systems:

drivers/ata/sata_sil.c: In function 'sil_broken_system_poweroff':
drivers/ata/sata_sil.c:713: error: implicit declaration of function 'dmi_first_match'
drivers/ata/sata_sil.c:713: warning: initialization makes pointer from integer without a cast

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/ata/sata_sil.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index bfd55b0..3f0549d 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -697,6 +697,7 @@ static void sil_init_controller(struct ata_host *host)
 
 static bool sil_broken_system_poweroff(struct pci_dev *pdev)
 {
+#ifdef CONFIG_DMI
 	static const struct dmi_system_id broken_systems[] = {
 		{
 			.ident = "HP Compaq nx6325",
@@ -717,6 +718,7 @@ static bool sil_broken_system_poweroff(struct pci_dev *pdev)
 		/* apply the quirk only to on-board controllers */
 		return slot == PCI_SLOT(pdev->devfn);
 	}
+#endif
 
 	return false;
 }
-- 
1.5.6.6

