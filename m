Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbYDFVqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbYDFVqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 17:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYDFVpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 17:45:54 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1927 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbYDFVpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 17:45:53 -0400
Subject: [PATCH] drivers/ata/sata_via.c - Eliminate "may be used
	uninitialized" warning
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 06 Apr 2008 14:45:20 -0700
Message-Id: <1207518320.1803.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Called by svia_init_one with a temporary,
so there's no effective code change.

Signed-off-by: Joe Perches <joe@perches.com>

 drivers/ata/sata_via.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 0d03f44..e01d2b1 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -406,10 +406,9 @@ static int vt6420_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 	struct ata_host *host;
 	int rc;
 
-	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
+	rc = ata_pci_prepare_sff_host(pdev, ppi, r_host);
 	if (rc)
 		return rc;
-	*r_host = host;
 
 	rc = pcim_iomap_regions(pdev, 1 << 5, DRV_NAME);
 	if (rc) {
@@ -417,6 +416,7 @@ static int vt6420_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 		return rc;
 	}
 
+	host = *r_host;
 	host->ports[0]->ioaddr.scr_addr = svia_scr_addr(host->iomap[5], 0);
 	host->ports[1]->ioaddr.scr_addr = svia_scr_addr(host->iomap[5], 1);
 


