Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYJ3UAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYJ3UAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYJ3T7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:59:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57267 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYJ3T7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:59:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: David Woodhouse <David.Woodhouse@intel.com>,
       Chen Gong <g.chen@freescale.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <Michael.Hennerich@analog.com>
Subject: [PATCH] m25p80: fix detection of m25p16 flashes
Date: Thu, 30 Oct 2008 15:59:46 -0400
Message-Id: <1225396786-23679-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1225286467-17955-1-git-send-email-vapier@gentoo.org>
References: <1225286467-17955-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d0e8c47c58575b9131e786edb488fd029eba443e added support for extended ids
but seems to break on flashes which don't have an extended id defined.  If the
table does not have an extid defined, then we should ignore it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Michael Hennerich <Michael.Hennerich@analog.com>
---
 drivers/mtd/devices/m25p80.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index a298fed..6188fd4 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -575,7 +575,7 @@ static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
 			tmp < ARRAY_SIZE(m25p_data);
 			tmp++, info++) {
 		if (info->jedec_id == jedec) {
-			if (ext_jedec != 0 && info->ext_id != ext_jedec)
+			if (info->ext_id != 0 && info->ext_id != ext_jedec)
 				continue;
 			return info;
 		}
-- 
1.6.0.2

