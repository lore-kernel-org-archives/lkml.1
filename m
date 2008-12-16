Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYLPNkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYLPNkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 08:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYLPNj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 08:39:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54545 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbYLPNj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 08:39:58 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Pass driver_data onto child devices
Date: Tue, 16 Dec 2008 13:39:55 +0000
Message-Id: <1229434796-24871-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
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

