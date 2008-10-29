Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYJ2NVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYJ2NVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYJ2NVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:21:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49875 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbYJ2NVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:21:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: David Woodhouse <David.Woodhouse@intel.com>,
       Chen Gong <g.chen@freescale.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] m25p80: fix detection of SPI parts
Date: Wed, 29 Oct 2008 09:21:07 -0400
Message-Id: <1225286467-17955-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d0e8c47c58575b9131e786edb488fd029eba443e added support for extended
ids but in the process managed to break detection of all flashes.  The ext
jedec id check was inserted into an if statement that lacked braces, and
it did not add the required braces.  As such, the detection routine always
returns the first entry in the SPI flash list.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mtd/devices/m25p80.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 76a7675..a298fed 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -574,10 +574,11 @@ static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
 	for (tmp = 0, info = m25p_data;
 			tmp < ARRAY_SIZE(m25p_data);
 			tmp++, info++) {
-		if (info->jedec_id == jedec)
+		if (info->jedec_id == jedec) {
 			if (ext_jedec != 0 && info->ext_id != ext_jedec)
 				continue;
 			return info;
+		}
 	}
 	dev_err(&spi->dev, "unrecognized JEDEC id %06x\n", jedec);
 	return NULL;
-- 
1.6.0.2

