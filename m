Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbYDPAee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbYDPAee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYDPAeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:34:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:47884 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275AbYDPAeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lqOPqm+ues3o1pOnjQ3fYcUsAPkMEnhRdFmVwF3hYwlH1WIL//GGogKpPMyghvLUxczcz/gcY++8Ipd2u5c87vIv0pPtYhE9ic14HFM+0AgSudfaT8djcUWbc+eTuUNZpJHyFeVOxR5aLifV6v4/rxPlPNivcHSvkQPvNeAeeXo=
Subject: [PATCH] Adding dummy release functions to avoid warnings.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: linux-kernel@vger.kernel.org, devzero@web.de, jsun@junsun.net,
       dwmw2@infradead.org
Content-Type: text/plain
Date: Wed, 16 Apr 2008 03:34:16 +0300
Message-Id: <1208306056.15140.13.camel@pcvitaliy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] Adding dummy release functions to avoid warnings.

From: Vitaliy Ivanov <vitalivanov@gmail.com>

Trivial fix for #9690.
Added simple release functions that doing nothing.
Not sure whether we can leave it as is or to rework using platform_device helpers like platform_device_alloc.
This approach is used in many drivers.


Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

--

 drivers/mtd/maps/physmap.c |    6 ++++++
 drivers/video/hgafb.c      |   10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index bc4649a..5bdbd04 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -264,11 +264,17 @@ static struct resource physmap_flash_resource = {
 	.flags		= IORESOURCE_MEM,
 };
 
+/* Fake release func.*/
+static void physmap_flash_release(struct device *dev)
+{
+}
+
 static struct platform_device physmap_flash = {
 	.name		= "physmap-flash",
 	.id		= 0,
 	.dev		= {
 		.platform_data	= &physmap_flash_data,
+		.release	= physmap_flash_release, 
 	},
 	.num_resources	= 1,
 	.resource	= &physmap_flash_resource,
diff --git a/drivers/video/hgafb.c b/drivers/video/hgafb.c
index fb9e672..8707115 100644
--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -623,8 +623,16 @@ static struct device_driver hgafb_driver = {
 	.remove = hgafb_remove,
 };
 
+/* Fake release func.*/
+static void hgafb_device_release(struct device *dev)
+{
+}
+
 static struct platform_device hgafb_device = {
-	.name = "hgafb",
+	.name	= "hgafb",
+	.dev	= {
+		.release = hgafb_device_release, 
+	},
 };
 
 static int __init hgafb_init(void)


