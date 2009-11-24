Return-Path: <linux-kernel-owner+w=401wt.eu-S933982AbZKXVI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbZKXVI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933934AbZKXVIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:08:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44545 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381AbZKXVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:18 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Kumar Gala <galak@kernel.crashing.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss@lists.ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 32/38] don't use __exit_p to wrap plat_mpc8xxx_spi_remove
Date: Tue, 24 Nov 2009 22:07:27 +0100
Message-Id: <1259096853-18909-32-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-31-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-14-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-16-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-17-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-18-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-19-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-20-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-21-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-22-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-23-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-24-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-25-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-26-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-27-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-28-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-29-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-30-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-31-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function plat_mpc8xxx_spi_remove is defined using __devexit, so don't
use __exit_p but __devexit_p to wrap it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi_mpc8xxx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 0fd0ec4..1d98be9 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -900,7 +900,7 @@ static int __devexit plat_mpc8xxx_spi_remove(struct platform_device *pdev)
 MODULE_ALIAS("platform:mpc8xxx_spi");
 static struct platform_driver mpc8xxx_spi_driver = {
 	.probe = plat_mpc8xxx_spi_probe,
-	.remove = __exit_p(plat_mpc8xxx_spi_remove),
+	.remove = __devexit_p(plat_mpc8xxx_spi_remove),
 	.driver = {
 		.name = "mpc8xxx_spi",
 		.owner = THIS_MODULE,
-- 
1.6.5.2

