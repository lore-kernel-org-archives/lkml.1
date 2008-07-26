Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYGZNm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYGZNm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYGZNmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:42:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:59814 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYGZNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=EsaZkKoTsnkFn+3umK51v42+k1QGpWr6Sts4R0JJcG8mNw9DqJ5bG9lmuwHi+lumhj
         Wig8q1g+5nffKqjGG6VkUO4uisjTX9x3k0uxZFlq/k6o1byeD3HkgjEnjUwZ/B2Vw+wW
         bOZMyLg9SFNr4j6pYD5JNX6cxAkgqNLu2OLI4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:40:10 +0200
Message-Id: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/10] ide: sanitize struct ide_port_ops documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
some easy/trivial changes just to keep the ball rolling...

 include/linux/ide.h |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -508,24 +508,33 @@ struct ide_tp_ops {
 
 extern const struct ide_tp_ops default_tp_ops;
 
+/**
+ * struct ide_port_ops - IDE port operations
+ *
+ * init_dev:		host specific initialization of a device
+ * set_pio_mode:	routine to program host for PIO mode
+ * set_dma_mode:	routine to program host for DMA mode
+ * selectproc:		tweaks hardware to select drive
+ * reset_poll:		chipset polling based on hba specifics
+ * pre_reset:		chipset specific changes to default for device-hba resets
+ * resetproc:		routine to reset controller after a disk reset
+ * maskproc:		special host masking for drive selection
+ * quirkproc:		check host's drive quirk list
+ *
+ * mdma_filter:		filter MDMA modes
+ * udma_filter:		filter UDMA modes
+ *
+ * cable_detect:	detect cable type
+ */
 struct ide_port_ops {
-	/* host specific initialization of a device */
 	void	(*init_dev)(ide_drive_t *);
-	/* routine to program host for PIO mode */
 	void	(*set_pio_mode)(ide_drive_t *, const u8);
-	/* routine to program host for DMA mode */
 	void	(*set_dma_mode)(ide_drive_t *, const u8);
-	/* tweaks hardware to select drive */
 	void	(*selectproc)(ide_drive_t *);
-	/* chipset polling based on hba specifics */
 	int	(*reset_poll)(ide_drive_t *);
-	/* chipset specific changes to default for device-hba resets */
 	void	(*pre_reset)(ide_drive_t *);
-	/* routine to reset controller after a disk reset */
 	void	(*resetproc)(ide_drive_t *);
-	/* special host masking for drive selection */
 	void	(*maskproc)(ide_drive_t *, int);
-	/* check host's drive quirk list */
 	void	(*quirkproc)(ide_drive_t *);
 
 	u8	(*mdma_filter)(ide_drive_t *);
