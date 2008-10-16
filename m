Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbYJPV30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbYJPV30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYJPV3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:29:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYJPV3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:29:17 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Adam Jackson <ajax@redhat.com>
Subject: [PATCH] sony-laptop: Ignore missing _DIS method on pic device
Date: Thu, 16 Oct 2008 17:29:10 -0400
Message-Id: <1224192550-366-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg59@srcf.ucam.org>

At least the Vaio VGN-Z540N doesn't have this method, so let's not fail
to suspend just because it doesn't exist.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/misc/sony-laptop.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index 60775be..b35eb92 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -2315,8 +2315,10 @@ end:
  */
 static int sony_pic_disable(struct acpi_device *device)
 {
-	if (ACPI_FAILURE(acpi_evaluate_object(device->handle,
-			"_DIS", NULL, NULL)))
+	acpi_status ret = acpi_evaluate_object(device->handle, "_DIS", NULL,
+					       NULL);
+
+	if (ACPI_FAILURE(ret) && ret != AE_NOT_FOUND)
 		return -ENXIO;
 
 	dprintk("Device disabled\n");
-- 
1.6.0.1

