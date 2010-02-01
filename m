Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab0BAO5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:57:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40409 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0BAO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:57:52 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Richard Zhao <linuxzsc@gmail.com>,
       Darius Augulis <augulis.darius@gmail.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Greg KH <gregkh@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] i2c/imx: don't add probe function to the driver struct
Date: Mon,  1 Feb 2010 15:57:25 +0100
Message-Id: <1265036245-32235-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100130204425.GA16345@pengutronix.de>
References: <20100130204425.GA16345@pengutronix.de>
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

Having a pointer to the probe function is unnecessary when using
platform_driver_probe and yields a section mismatch warning after
removing the white list entry "*driver" for
{ .data$, .data.rel$ } -> { .init.* } mismatches in modpost.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this is a new section mismatch found by modpost after my patches.

Best regards
Uwe

 drivers/i2c/busses/i2c-imx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 75bf820..32375bd 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -627,7 +627,6 @@ static int __exit i2c_imx_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver i2c_imx_driver = {
-	.probe		= i2c_imx_probe,
 	.remove		= __exit_p(i2c_imx_remove),
 	.driver	= {
 		.name	= DRIVER_NAME,
-- 
1.6.6

