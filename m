Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689Ab0A2QSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0A2QSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876Ab0A2QFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:05:40 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0A2QFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VZldLvaXX6jxvfQkx7QvmAra5thKS/jG85N+fY9Rc8TxncBAgQx3jrB5idlhd0J263
         jvlYjKvbwS3iiZ65vm/gMuFmOZb2VqLopd8kKJzG2iFQQeCD51nNjhfqzAIN358JO3CW
         G1D+T8yUCzKYGiwsfMg3wxdODRj1Ix2emJX4A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:05:25 +0100
Message-Id: <20100129160525.21495.12888.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 21/68] ide: add hwif->private_data field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add hwif->private_data field

Add private_data field to ide_hwif_t matching private_data field used
in struct ata_port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -747,7 +747,11 @@ typedef struct hwif_s {
 
 	struct completion gendev_rel_comp; /* To deal with device release() */
 
-	void		*hwif_data;	/* extra hwif data */
+	/* extra port data */
+	union {
+		void	*hwif_data;
+		void	*private_data;
+	};
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	struct ide_acpi_hwif_link *acpidata;
