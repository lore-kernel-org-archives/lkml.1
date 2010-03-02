Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab0CBXse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:48:34 -0500
Received: from kroah.org ([198.145.64.141]:51629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab0CBXhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Maxime Bizon <mbizon@freebox.fr>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/36] serial: bcm63xx_uart: don't use kfree() on non kmalloced area.
Date: Tue,  2 Mar 2010 15:36:31 -0800
Message-Id: <1267573003-782-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bcm63xx_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bcm63xx_uart.c b/drivers/serial/bcm63xx_uart.c
index 37ad0c4..f78ede8 100644
--- a/drivers/serial/bcm63xx_uart.c
+++ b/drivers/serial/bcm63xx_uart.c
@@ -830,7 +830,7 @@ static int __devinit bcm_uart_probe(struct platform_device *pdev)
 
 	ret = uart_add_one_port(&bcm_uart_driver, port);
 	if (ret) {
-		kfree(port);
+		ports[pdev->id].membase = 0;
 		return ret;
 	}
 	platform_set_drvdata(pdev, port);
-- 
1.7.0.1

