Return-Path: <linux-kernel-owner+w=401wt.eu-S937172AbXGUMpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937172AbXGUMpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762940AbXGUMo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:44:59 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:24057 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762811AbXGUMo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:44:58 -0400
Date: Sat, 21 Jul 2007 16:45:18 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] [broken-out-2007-07-20-00-22] libata compile fix
Message-ID: <20070721124518.GD10576@dnb.sw.ru>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix libata compilation.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/ata/libata-core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cc6ba64..721f43d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2036,9 +2036,7 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
-	if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
-		dev->horkage |= ATA_HORKAGE_ALPM;
-
+	if (dev->horkage & ATA_HORKAGE_ALPM) {
 		/* reset link pm_policy for this port to no pm */
 		ap->pm_policy = SHOST_MAX_PERFORMANCE;
 	}
-- 
1.5.2.2


