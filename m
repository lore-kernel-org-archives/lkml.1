Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394Ab0ATXve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0ATXve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253Ab0ATXu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:50:56 -0500
Received: from kroah.org ([198.145.64.141]:33656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0ATXux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, Fabian Godehardt <fg@emlix.com>,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/8] serial: imx: bit &/| confusion
Date: Wed, 20 Jan 2010 15:50:01 -0800
Message-Id: <1264031403-32239-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234759.GC32068@kroah.com>
References: <20100120234759.GC32068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Since UCR1_UARTEN is defined 1, the port was always treated as enabled.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Acked-by: Oskar Schirmer <os@emlix.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabian Godehardt <fg@emlix.com>
Cc: Daniel Glöckner <dg@emlix.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 18130f1..60d665a 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -1088,7 +1088,7 @@ imx_console_get_options(struct imx_port *sport, int *baud,
 			   int *parity, int *bits)
 {
 
-	if ( readl(sport->port.membase + UCR1) | UCR1_UARTEN ) {
+	if (readl(sport->port.membase + UCR1) & UCR1_UARTEN) {
 		/* ok, the port was enabled */
 		unsigned int ucr2, ubir,ubmr, uartclk;
 		unsigned int baud_raw;
-- 
1.6.5.7

