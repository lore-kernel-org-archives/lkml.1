Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZETWVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZETWVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZETWVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:21:00 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:36155 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbZETWVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:21:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RRUzPgzCox6uu4qhqAXV/3Jy+AssFvTu6ghLWATPM6iHHRNhZDIAXrUiDx1HG8Wlde
         XZGL9qL4t9W7zjoZxlUM65Pem7rj4x7kQoIiX6XIKiLo/FFjJ4/G8P4Glb88Wz+E0u++
         amDIX1okb02r55W5wgyNbzAYWVHn/EpkyFt4Q=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>, Yan hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>,
       Erwan Lerale <erwan@thiscow.com>
Subject: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Thu, 21 May 2009 06:12:46 +0800
Message-Id: <a998340033c8f89ec028b354ebe2956239144049.1242855716.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1242855716.git.wuzhangjin@gmail.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This is originally from the to-mips branch from
http://dev.lemote.com/code/linux_loongson

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/ide/amd74xx.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
index 77267c8..8f488b8 100644
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -23,6 +23,11 @@
 
 #define DRV_NAME "amd74xx"
 
+static const char *am74xx_quirk_drives[] = {
+	"FUJITSU MHZ2160BH G2",
+	NULL
+};
+
 enum {
 	AMD_IDE_CONFIG		= 0x41,
 	AMD_CABLE_DETECT	= 0x42,
@@ -112,6 +117,19 @@ static void amd_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	amd_set_drive(drive, XFER_PIO_0 + pio);
 }
 
+static void amd_quirkproc(ide_drive_t *drive)
+{
+	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
+
+	for (list = am74xx_quirk_drives; *list != NULL; list++)
+			if (strstr(m, *list) != NULL) {
+				drive->quirk_list = 2;
+				return;
+			}
+
+	drive->quirk_list = 0;
+}
+
 static void amd7409_cable_detect(struct pci_dev *dev)
 {
 	/* no host side cable detection */
@@ -194,6 +212,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 static const struct ide_port_ops amd_port_ops = {
 	.set_pio_mode		= amd_set_pio_mode,
 	.set_dma_mode		= amd_set_drive,
+	.quirkproc		= amd_quirkproc,
 	.cable_detect		= amd_cable_detect,
 };
 
-- 
1.6.2.1

