Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0CIRWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:22:39 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54678 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0CIRW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:28 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 04/13] serial: bfin_sport_uart: add missing mapbase initialization
Date: Tue,  9 Mar 2010 12:25:31 -0500
Message-Id: <1268155540-8241-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The driver doesn't care about this, but the common serial core wants it.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 8b0df19..18bc4a3 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -711,6 +711,7 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 			ret = -ENXIO;
 			goto out_error_free_peripherals;
 		}
+		sport->port.mapbase = res->start;
 
 		sport->port.irq = platform_get_irq(pdev, 0);
 		if (sport->port.irq < 0) {
@@ -808,7 +809,7 @@ static int __init sport_uart_init(void)
 {
 	int ret;
 
-	pr_info("Serial: Blackfin uart over sport driver\n");
+	pr_info("Blackfin uart over sport driver\n");
 
 	ret = uart_register_driver(&sport_uart_reg);
 	if (ret) {
-- 
1.7.0.2

