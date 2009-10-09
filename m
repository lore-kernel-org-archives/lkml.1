Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbZJIEd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbZJIEd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 00:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZJIEdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 00:33:25 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46169 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbZJIEdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 00:33:24 -0400
Date: Fri, 9 Oct 2009 00:32:48 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata build fix
Message-ID: <20091009043248.GA12304@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

Markus Trippelsdorf (1):
      ahci: Add ifdef wrapper to ahci_gtf_filter_workaround

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4edca6e..b1a2577 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2884,6 +2884,7 @@ static bool ahci_broken_online(struct pci_dev *pdev)
 	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
 }
 
+#ifdef CONFIG_ATA_ACPI
 static void ahci_gtf_filter_workaround(struct ata_host *host)
 {
 	static const struct dmi_system_id sysids[] = {
@@ -2927,6 +2928,10 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
 				dev->gtf_filter |= filter;
 	}
 }
+#else
+static inline void ahci_gtf_filter_workaround(struct ata_host *host)
+{}
+#endif
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
