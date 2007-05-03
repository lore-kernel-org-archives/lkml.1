Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbXECPya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbXECPya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbXECPya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:54:30 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:56505 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754356AbXECPy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:54:29 -0400
Subject: [MCA] fix bus matching
From: James Bottomley <James.Bottomley@SteelEye.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 May 2007 10:54:26 -0500
Message-Id: <1178207666.3714.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's a bug in the MCA bus matching algorithm in that it promotes from
signed short to int before comparing with the actual id and does sign
extension on anything > 0x7fff (which means that pos ids > 0x7fff never
get correctly matched).

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

---
diff --git a/drivers/mca/mca-bus.c b/drivers/mca/mca-bus.c
index da862e4..a70fe00 100644
--- a/drivers/mca/mca-bus.c
+++ b/drivers/mca/mca-bus.c
@@ -47,7 +47,7 @@ static int mca_bus_match (struct device *dev, struct device_driver *drv)
 {
 	struct mca_device *mca_dev = to_mca_device (dev);
 	struct mca_driver *mca_drv = to_mca_driver (drv);
-	const short *mca_ids = mca_drv->id_table;
+	const unsigned short *mca_ids = mca_drv->id_table;
 	int i;
 
 	if (!mca_ids)


