Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZGYNFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZGYNFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 09:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZGYNFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 09:05:06 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:34917 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZGYNFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 09:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=slJpSI11RX+CRxqsEtGsBXz45FVZwjy7vxbFWH/aJoS96Ng2X4/B6pGNDIUNrWJHMM
         U51K4tD4Jox1Iegtj61uhLJjqD59rLBAZpHWZkrudb8yVIYBHvknrdujjEwRukqo7nNS
         F/M91ubqGXtrQCyR3Y+3oWEYjZ8gVPnOhsm4s=
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Date: Sat, 25 Jul 2009 09:04:51 -0400
Message-Id: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of the following warning:
Platform driver 'acer-wmi' needs updating - please use dev_pm_ops

Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
---
 drivers/platform/x86/acer-wmi.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index be2fd6f..b2b6aef 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct platform_device *device)
 	return 0;
 }
 
-static int acer_platform_suspend(struct platform_device *dev,
-pm_message_t state)
+static int acer_platform_suspend(struct device *dev)
 {
 	u32 value;
 	struct acer_data *data = &interface->data;
@@ -1174,7 +1173,7 @@ pm_message_t state)
 	return 0;
 }
 
-static int acer_platform_resume(struct platform_device *device)
+static int acer_platform_resume(struct device *dev)
 {
 	struct acer_data *data = &interface->data;
 
@@ -1190,15 +1189,19 @@ static int acer_platform_resume(struct platform_device *device)
 	return 0;
 }
 
+static struct dev_pm_ops acer_platform_pm_ops = {
+	.suspend = acer_platform_suspend,
+	.resume = acer_platform_resume,
+};
+
 static struct platform_driver acer_platform_driver = {
 	.driver = {
 		.name = "acer-wmi",
 		.owner = THIS_MODULE,
+		.pm = &acer_platform_pm_ops,
 	},
 	.probe = acer_platform_probe,
 	.remove = acer_platform_remove,
-	.suspend = acer_platform_suspend,
-	.resume = acer_platform_resume,
 };
 
 static struct platform_device *acer_platform_device;
-- 
1.6.3.3

