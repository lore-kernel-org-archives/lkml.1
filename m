Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbZJFQHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbZJFQHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbZJFQHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:07:44 -0400
Received: from relay.atmel.no ([80.232.32.139]:52439 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbZJFQHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:07:43 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: Fix bad BUILD_BUG_ON() usage
Date: Tue,  6 Oct 2009 18:06:47 +0200
Message-Id: <1254845207-7608-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_power_of_2() appears not to be constant enough for BUILD_BUG_ON()
after the latest rework, so replace it with an open-coded test.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 3551c5c..9d948bc 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1531,7 +1531,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	void *data;
 	int ret;
 
-	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
+	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
 
 	port = &atmel_ports[pdev->id];
 	port->backup_imr = 0;
-- 
1.6.0.4

