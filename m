Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZGOPso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZGOPso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZGOPso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:48:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:21692 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZGOPsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cBV/nnGZMCHR2qUjo3T6MLmHpxogma3xL4kB1h7Rczc/SCvbCZzhqguODcZQtnQUBf
         DBW1HNqO3HEC0hWNisqUhvoUZKqorCaeKpIOLi/3DPPBzUDFIwJY+J0G48rwy+oRQJck
         Ua2by90wiIKvQhy4NHPy3rOGoNJ9I87nXeAG4=
From: Borislav Petkov <petkovbb@googlemail.com>
To: lenb@kernel.org
Cc: peter@piie.net, linux-kernel@vger.kernel.org
Subject: [PATCH] acerhdf: convert to dev_pm_ops
Date: Wed, 15 Jul 2009 17:48:39 +0200
Message-Id: <1247672919-13089-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/platform/x86/acerhdf.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index aa298d6..561b471 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -435,7 +435,7 @@ struct thermal_cooling_device_ops acerhdf_cooling_ops = {
 };
 
 /* suspend / resume functionality */
-static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
+static int acerhdf_suspend(struct device *dev)
 {
 	if (kernelmode)
 		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
@@ -446,7 +446,7 @@ static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int acerhdf_resume(struct platform_device *device)
+static int acerhdf_resume(struct device *dev)
 {
 	if (verbose)
 		pr_notice("resuming\n");
@@ -464,15 +464,19 @@ static int acerhdf_remove(struct platform_device *device)
 	return 0;
 }
 
+static struct dev_pm_ops acerhdf_pm_ops = {
+	.suspend = acerhdf_suspend,
+	.resume	 = acerhdf_resume,
+};
+
 static struct platform_driver acerhdf_driver = {
 	.driver = {
-		.name = "acerhdf",
+		.name  = "acerhdf",
 		.owner = THIS_MODULE,
+		.pm    = &acerhdf_pm_ops,
 	},
 	.probe = acerhdf_probe,
 	.remove = acerhdf_remove,
-	.suspend = acerhdf_suspend,
-	.resume = acerhdf_resume,
 };
 
 
-- 
1.6.3.3

