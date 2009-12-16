Return-Path: <linux-kernel-owner+w=401wt.eu-S934955AbZLPQKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955AbZLPQKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934591AbZLPQKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:10:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41239 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934911AbZLPQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:10:35 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       "David S. Miller" <davem@davemloft.net>,
       Wolfgang Grandegger <wg@grandegger.com>,
       Kurt Van Dijck <kurt.van.dijck@eia.be>, netdev@vger.kernel.org
Subject: [PATCH 4/7] can/at91: don't check platform_get_irq's return value against zero
Date: Wed, 16 Dec 2009 17:10:06 +0100
Message-Id: <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_get_irq returns -ENXIO on failure, so !irq was probably
always true.  Better use (int)irq <= 0.  Note that a return value of
zero is still handled as error even though this could mean irq0.

This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
changed the return value of platform_get_irq from 0 to -ENXIO on error.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Vrabel <dvrabel@arcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Urs Thuermann <urs.thuermann@volkswagen.de>
Cc: Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>
Cc: netdev@vger.kernel.org
---
 drivers/net/can/at91_can.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index cbe3fce..631d404 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1037,7 +1037,7 @@ static int __init at91_can_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
-	if (!res || !irq) {
+	if (!res || irq <= 0) {
 		err = -ENODEV;
 		goto exit_put;
 	}
-- 
1.6.5.2

