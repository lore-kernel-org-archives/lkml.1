Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbXJQT2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbXJQT2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXJQT2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:28:36 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52704 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755310AbXJQT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:28:35 -0400
Date: Wed, 17 Oct 2007 21:29:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] hwmon/ibmpex.c: fix NULL dereference
Message-ID: <20071017192902.GB3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't dereference "data" when we know for sure it's NULL.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
66bec2ef5c6d55fc30ef6ac5bb97fdfcfaf394f2 
diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index c462824..e14ce3d 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -457,7 +457,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
-		       "interface %d.\n", data->interface);
+		       "interface.\n");
 		return;
 	}
 

