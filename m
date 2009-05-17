Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbZEQJ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbZEQJ3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 05:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbZEQJ3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 05:29:34 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:59870 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586AbZEQJ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 05:29:33 -0400
Date: Sun, 17 May 2009 11:29:21 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: timur@freescale.com, alsa-devel@alsa-project.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] sound: use dev_set_drvdata
Message-ID: <Pine.LNX.4.64.0905171129020.20440@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Eliminate direct accesses to the driver_data field.
cf 82ab13b26f15f49be45f15ccc96bfa0b81dfd015

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct device *dev;
expression E;
type T;
@@

- dev->driver_data = (T)E
+ dev_set_drvdata(dev, E)

@@
struct device *dev;
type T;
@@

- (T)dev->driver_data
+ dev_get_drvdata(dev)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/fsl/fsl_ssi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -674,7 +674,7 @@ struct snd_soc_dai *fsl_ssi_create_dai(s
 	ssi_private->dev = ssi_info->dev;
 	ssi_private->asynchronous = ssi_info->asynchronous;
 
-	ssi_private->dev->driver_data = fsl_ssi_dai;
+	dev_set_drvdata(ssi_private->dev, fsl_ssi_dai);
 
 	/* Initialize the the device_attribute structure */
 	dev_attr->attr.name = "ssi-stats";
