Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZCIQCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZCIQCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZCIQCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:02:21 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47345 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCIQCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:02:21 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Ville Syrjala <syrjala@sci.fi>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH] drivers/w1/masters/w1-gpio.c: fix read_bit()
Date: Mon,  9 Mar 2009 17:02:10 +0100
Message-Id: <1236614530-11153-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W1 master implementations are expected to return 0 or 1 from their
read_bit() function. However, not all platforms do return these values
from gpio_get_value() - namely PXAs won't. Hence the w1 gpio-master
needs to break the result down to 0 or 1 itself.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/w1-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 9e1138a..a411702 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -39,7 +39,7 @@ static u8 w1_gpio_read_bit(void *data)
 {
 	struct w1_gpio_platform_data *pdata = data;
 
-	return gpio_get_value(pdata->pin);
+	return gpio_get_value(pdata->pin) ? 1 : 0;
 }
 
 static int __init w1_gpio_probe(struct platform_device *pdev)
-- 
1.6.1.3

