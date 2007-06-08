Return-Path: <linux-kernel-owner+w=401wt.eu-S936632AbXFHHSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936632AbXFHHSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937803AbXFHHRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33120 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937142AbXFHHRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:05 -0400
Message-Id: <20070608071537.374741000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>, Jeroen Janssen <jeroen.janssen@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/32] sata_via: add missing PM hooks
Content-Disposition: inline; filename=sata_via-add-missing-pm-hooks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tejun Heo <htejun@gmail.com>

For some reason, sata_via is missing PM hooks.  Add them.  Spotted by
Jeroen Janssen <jeroen.janssen@gmail.com>.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jeroen Janssen <jeroen.janssen@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
[chrisw: trivial 2.6.20 backport]

 drivers/ata/sata_via.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.20.13.orig/drivers/ata/sata_via.c
+++ linux-2.6.20.13/drivers/ata/sata_via.c
@@ -90,6 +90,10 @@ static struct pci_driver svia_pci_driver
 	.name			= DRV_NAME,
 	.id_table		= svia_pci_tbl,
 	.probe			= svia_init_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= ata_pci_device_resume,
+#endif
 	.remove			= ata_pci_remove_one,
 };
 
@@ -109,6 +113,10 @@ static struct scsi_host_template svia_sh
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
+	.suspend		= ata_scsi_device_suspend,
+	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const struct ata_port_operations vt6420_sata_ops = {

-- 
