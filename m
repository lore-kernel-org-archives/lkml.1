Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYDUIxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYDUIxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759077AbYDUIvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:51:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36146 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759037AbYDUIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:51:44 -0400
Date: Mon, 21 Apr 2008 11:51:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <mlord@pobox.com>, Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make sata_print_link_status() static
Message-ID: <20080421085111.GB26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sata_print_link_status() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/libata-core.c |    3 +--
 include/linux/libata.h    |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

017dd9ea17af28a805e099c245ae1f8991eb6b5a diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1686773..4b918d7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2605,7 +2605,7 @@ void ata_port_probe(struct ata_port *ap)
  *	LOCKING:
  *	None.
  */
-void sata_print_link_status(struct ata_link *link)
+static void sata_print_link_status(struct ata_link *link)
 {
 	u32 sstatus, scontrol, tmp;
 
@@ -6197,7 +6197,6 @@ EXPORT_SYMBOL_GPL(ata_host_detach);
 EXPORT_SYMBOL_GPL(ata_sg_init);
 EXPORT_SYMBOL_GPL(ata_qc_complete);
 EXPORT_SYMBOL_GPL(ata_qc_complete_multiple);
-EXPORT_SYMBOL_GPL(sata_print_link_status);
 EXPORT_SYMBOL_GPL(atapi_cmd_type);
 EXPORT_SYMBOL_GPL(ata_tf_to_fis);
 EXPORT_SYMBOL_GPL(ata_tf_from_fis);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2d8874b..84618df 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -847,7 +847,6 @@ static inline int ata_port_is_dummy(struct ata_port *ap)
 	return ap->ops == &ata_dummy_port_ops;
 }
 
-extern void sata_print_link_status(struct ata_link *link);
 extern void ata_port_probe(struct ata_port *);
 extern int sata_set_spd(struct ata_link *link);
 extern int ata_std_prereset(struct ata_link *link, unsigned long deadline);

