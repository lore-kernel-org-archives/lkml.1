Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbZKXVIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbZKXVIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933941AbZKXVIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:08:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44560 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbZKXVIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:21 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Russell King <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>, Peter Korsgaard <jacmet@sunsite.dk>,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/38] move s3c_pwm_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:11 +0100
Message-Id: <1259096853-18909-16-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function s3c_pwm_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/plat-s3c/pwm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-s3c/pwm.c b/arch/arm/plat-s3c/pwm.c
index 4fdc5b3..ef019f2 100644
--- a/arch/arm/plat-s3c/pwm.c
+++ b/arch/arm/plat-s3c/pwm.c
@@ -368,7 +368,7 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int s3c_pwm_remove(struct platform_device *pdev)
+static int __devexit s3c_pwm_remove(struct platform_device *pdev)
 {
 	struct pwm_device *pwm = platform_get_drvdata(pdev);
 
-- 
1.6.5.2

