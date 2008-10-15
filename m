Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbYJOXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbYJOXZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYJOXZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:25:07 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:25222 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYJOXZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:25:06 -0400
Date: Wed, 15 Oct 2008 17:25:05 -0600
From: Alex Chiang <achiang@hp.com>
To: jeff@redhat.com
Cc: linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] stop gcc warning about uninitialized 'dev' in
	ata_scsi_scan_host
Message-ID: <20081015232505.GB9272@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jeff@redhat.com,
	linux-ide@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuts up gcc-3.4.5-glibc-2.3.6 when it complains of:

drivers/ata/libata-scsi.c: In function `ata_scsi_scan_host':
drivers/ata/libata-scsi.c:3225: warning: 'dev' might be used
uninitialized in this function

Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5d312dc..4e27c68 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3222,7 +3222,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	int tries = 5;
 	struct ata_device *last_failed_dev = NULL;
 	struct ata_link *link;
-	struct ata_device *dev;
+	struct ata_device *dev = NULL;
 
 	if (ap->flags & ATA_FLAG_DISABLED)
 		return;
