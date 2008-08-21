Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYHUNrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYHUNrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYHUNrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:47:19 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:40154 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbYHUNrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:47:17 -0400
Subject: [PATCH] libata: reorder ata_device to remove 8 bytes of padding on
	64 bits
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: jgarzik@pobox.com
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Content-Type: text/plain
Date: Thu, 21 Aug 2008 14:47:00 +0100
Message-Id: <1219326420.1276.8.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reduce size by 8 bytes from 1160 to 1152 allowing it to fit in 1 fewer
cachelines.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
patch against 2.6.27-rc4 compiled & run on AMD64.

Richard


diff --git a/include/linux/libata.h b/include/linux/libata.h
index 06b8033..84a7a0d 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -553,8 +553,8 @@ struct ata_ering {
 struct ata_device {
 	struct ata_link		*link;
 	unsigned int		devno;		/* 0 or 1 */
-	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	unsigned int		horkage;	/* List of broken features */
+	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	struct scsi_device	*sdev;		/* attached SCSI device */
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;


