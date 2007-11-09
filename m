Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbXKIGHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbXKIGHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXKIGHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:07:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:53720 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXKIGHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:07:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=M2IbvVOyPVg89ux7F6mL5UfDgMkgPpTVb3pAZG1bpi0VObmIx7qdtT37wbun8yFlVemnbo59ZjWh3F0ps4CWPe2C2z43g6MgLci5j8gYxptc9msmR3ZhudOUPqYCD4jRizk/++C1FKVE1FWB0XdVfIBqHG3a2Yby2Rvbc/we8zo=
Message-ID: <f17812d70711082207p455c5bc9v25fea9a0585ba152@mail.gmail.com>
Date: Fri, 9 Nov 2007 14:07:31 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] make ds1wm driver to check ds1wm_platform_data pointer against NULL
Cc: "Szabolcs Gyurko" <szabolcs.gyurko@tlt.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do a sanity check for the "struct ds1wm_platform_data" pointer passed in
by the platform_device, and so to enforce each platform to provide a
valid structure.

Signed-off-by: eric miao <eric.miao@marvell.com>
---
 drivers/w1/masters/ds1wm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 5747997..11ce9ec 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -351,6 +351,10 @@ static int ds1wm_probe(struct platform_device *pdev)
 		goto err0;
 	}
 	plat = pdev->dev.platform_data;
+	if (!plat) {
+		ret = -ENXIO;
+		goto err0;
+	}
 	ds1wm_data->bus_shift = plat->bus_shift;
 	ds1wm_data->pdev = pdev;
 	ds1wm_data->pdata = plat;
-- 
1.5.2.5.GIT
