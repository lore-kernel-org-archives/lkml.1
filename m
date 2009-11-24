Return-Path: <linux-kernel-owner+w=401wt.eu-S934098AbZKXVKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098AbZKXVKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934080AbZKXVIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:08:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44745 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934047AbZKXVIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:42 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Florian Fainelli <florian@openwrt.org>,
       Eugene Konev <ejka@imfi.kspu.ru>, Julia Lawall <julia@diku.dk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       openwrt-devel@lists.openwrt.org
Subject: [PATCH 26/38] move vlynq_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:21 +0100
Message-Id: <1259096853-18909-26-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-25-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function vlynq_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Eugene Konev <ejka@imfi.kspu.ru>
Cc: Julia Lawall <julia@diku.dk>
Cc: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: linux-kernel@vger.kernel.org
Cc: openwrt-devel@lists.openwrt.org
---
 drivers/vlynq/vlynq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index 9554ad5..3ae6e86 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -756,7 +756,7 @@ fail_request:
 	return result;
 }
 
-static int vlynq_remove(struct platform_device *pdev)
+static int __devexit vlynq_remove(struct platform_device *pdev)
 {
 	struct vlynq_device *dev = platform_get_drvdata(pdev);
 
-- 
1.6.5.2

