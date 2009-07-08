Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZGHMSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZGHMSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZGHMSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:18:43 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:65434 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbZGHMSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:18:42 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-input@vger.kernel.org
Subject: [PATCH] pcspkr: switch driver to dev_pm_ops
Date: Wed, 8 Jul 2009 14:18:36 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Dmitry Torokhov <dtor@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081418.37229.elendil@planet.nl>
X-OriginalArrivalTime: 08 Jul 2009 12:18:37.0627 (UTC) FILETIME=[38AD78B0:01C9FFC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of the following warning:
Platform driver 'pcspkr' needs updating - please use dev_pm_ops

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---

Looked straightforward enough for me to give it a shot.

diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 6d67af5..21cb755 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -114,7 +114,7 @@ static int __devexit pcspkr_remove(struct platform_device *dev)
 	return 0;
 }
 
-static int pcspkr_suspend(struct platform_device *dev, pm_message_t state)
+static int pcspkr_suspend(struct device *dev)
 {
 	pcspkr_event(NULL, EV_SND, SND_BELL, 0);
 
@@ -127,14 +127,18 @@ static void pcspkr_shutdown(struct platform_device *dev)
 	pcspkr_event(NULL, EV_SND, SND_BELL, 0);
 }
 
+static struct dev_pm_ops pcspkr_pm_ops = {
+	.suspend = pcspkr_suspend,
+};
+
 static struct platform_driver pcspkr_platform_driver = {
 	.driver		= {
 		.name	= "pcspkr",
 		.owner	= THIS_MODULE,
+		.pm	= &pcspkr_pm_ops,
 	},
 	.probe		= pcspkr_probe,
 	.remove		= __devexit_p(pcspkr_remove),
-	.suspend	= pcspkr_suspend,
 	.shutdown	= pcspkr_shutdown,
 };
 
