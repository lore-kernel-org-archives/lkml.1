Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0CIRYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:24:14 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54704 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab0CIRWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:32 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 08/13] serial: bfin_sport_uart: zero sport_uart_port if allocated dynamically
Date: Tue,  9 Mar 2010 12:25:35 -0500
Message-Id: <1268155540-8241-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Need to initialize the SPORT state rather than using random memory.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index ba5a8b7..871f6fd 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -745,11 +745,11 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 
 	if (bfin_sport_uart_ports[pdev->id] == NULL) {
 		bfin_sport_uart_ports[pdev->id] =
-			kmalloc(sizeof(struct sport_uart_port), GFP_KERNEL);
+			kzalloc(sizeof(struct sport_uart_port), GFP_KERNEL);
 		sport = bfin_sport_uart_ports[pdev->id];
 		if (!sport) {
 			dev_err(&pdev->dev,
-				"Fail to kmalloc sport_uart_port\n");
+				"Fail to malloc sport_uart_port\n");
 			return -ENOMEM;
 		}
 
-- 
1.7.0.2

