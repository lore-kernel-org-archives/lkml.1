Return-Path: <linux-kernel-owner+w=401wt.eu-S965370AbXA3NYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370AbXA3NYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965383AbXA3NYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:24:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41150 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965370AbXA3NXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:23:50 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] pata_platform: fallout from set_mode() change
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HBsxd-0002NU-Uz@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 30 Jan 2007 13:23:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ata/pata_platform.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 443b1d8..40ae11c 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -30,7 +30,7 @@ static int pio_mask = 1;
  * Provide our own set_mode() as we don't want to change anything that has
  * already been configured..
  */
-static void pata_platform_set_mode(struct ata_port *ap)
+static int pata_platform_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int i;
 
@@ -44,6 +44,7 @@ static void pata_platform_set_mode(struct ata_port *ap)
 			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
+	return 0;
 }
 
 static void pata_platform_host_stop(struct ata_host *host)
-- 
1.5.0-rc2.GIT


