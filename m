Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbZJNQV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbZJNQV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbZJNQV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:21:57 -0400
Received: from www.sr71.net ([198.145.64.142]:36163 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761AbZJNQV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:21:57 -0400
From: Dave Hansen <dave@sr71.net>
To: dave@sr71.net
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
       Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH] leds-ss4200: Check pci_enable_device return
Date: Wed, 14 Oct 2009 09:20:47 -0700
Message-Id: <1255537247-17208-1-git-send-email-dave@sr71.net>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_enable_result is defined using the __must_check macro but
leds-ss4200 is not checking the return value.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
Signed-off-by: Dave Hansen <dave@sr71.net>
---
 drivers/leds/leds-ss4200.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index 0ec4ec3..c7f6347 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -344,10 +344,14 @@ static struct pci_dev *nas_gpio_pci_dev;
 static int __devinit ich7_lpc_probe(struct pci_dev *dev,
 				    const struct pci_device_id *id)
 {
-	int status = 0;
+	int status;
 	u32 gc = 0;
 
-	pci_enable_device(dev);
+	status = pci_enable_device(dev);
+	if (status) {
+		dev_err(&dev->dev, "pci_enable_device failed\n");
+		return;
+	}
 
 	nas_gpio_pci_dev = dev;
 	status = pci_read_config_dword(dev, PMBASE, &g_pm_io_base);
-- 
1.6.5.rc2

