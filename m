Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753080AbYLRKpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYLRKpA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYLRKor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:44:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35870 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751541AbYLRKoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:44:46 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] mfd: Pass driver_data onto child devices
Date: Thu, 18 Dec 2008 10:44:39 +0000
Message-Id: <1229597084-12727-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218104301.GA12649@rakim.wolfsonmicro.main>
References: <20081218104301.GA12649@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MFD cell structure provides a driver_data field but doesn't pass it
on to the child devices when instantiating them - do that.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/mfd-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 6c0d1be..54ddf37 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -34,6 +34,7 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;
 
 	pdev->dev.parent = parent;
+	platform_set_drvdata(pdev, cell->driver_data);
 
 	ret = platform_device_add_data(pdev,
 			cell->platform_data, cell->data_size);
-- 
1.5.6.5

