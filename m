Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZGHMsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZGHMsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZGHMsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:48:13 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:57255 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346AbZGHMsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:48:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] floppy: switch driver to dev_pm_ops
Date: Wed, 8 Jul 2009 14:48:06 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081448.07696.elendil@planet.nl>
X-OriginalArrivalTime: 08 Jul 2009 12:48:08.0398 (UTC) FILETIME=[5823AEE0:01C9FFCA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of the following warning:
Platform driver 'floppy' needs updating - please use dev_pm_ops

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---

Looked straightforward enough for me to give it a shot.

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 91b7530..597fe3a 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4151,7 +4151,7 @@ static void floppy_device_release(struct device *dev)
 {
 }
 
-static int floppy_resume(struct platform_device *dev)
+static int floppy_resume(struct device *dev)
 {
 	int fdc;
 
@@ -4162,10 +4162,14 @@ static int floppy_resume(struct platform_device *dev)
 	return 0;
 }
 
-static struct platform_driver floppy_driver = {
+static struct dev_pm_ops floppy_pm_ops = {
 	.resume = floppy_resume,
+};
+
+static struct platform_driver floppy_driver = {
 	.driver = {
 		.name = "floppy",
+		.pm = &floppy_pm_ops,
 	},
 };
 
