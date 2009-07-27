Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZG0Nq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZG0Nq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZG0NqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:46:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59102 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754363AbZG0NqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:24 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 01/22] mfd: Allow multiple MFD cells with the same name
Date: Mon, 27 Jul 2009 14:45:51 +0100
Message-Id: <1248702372-29534-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide basic support for MFDs having multiple cells of a given
type with different IDs by adding an id to the mfd_cell structure
and then adding that to the id passed in to mfd_add_devices().

As it stands this approach requires that MFDs using this feature
deal with ensuring that there aren't any ID collisions resulting
from multiple MFDs of the same type being instantiated. This needs
to happen with the existing code too, but with this approach there
is a knock on effect on the IDs for non-duplicated devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/mfd-core.c   |    2 +-
 include/linux/mfd/core.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 54ddf37..ae15e49 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -25,7 +25,7 @@ static int mfd_add_device(struct device *parent, int id,
 	int ret = -ENOMEM;
 	int r;
 
-	pdev = platform_device_alloc(cell->name, id);
+	pdev = platform_device_alloc(cell->name, id + cell->id);
 	if (!pdev)
 		goto fail_alloc;
 
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 49ef857..11d740b 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -23,6 +23,7 @@
  */
 struct mfd_cell {
 	const char		*name;
+	int			id;
 
 	int			(*enable)(struct platform_device *dev);
 	int			(*disable)(struct platform_device *dev);
-- 
1.6.3.3

