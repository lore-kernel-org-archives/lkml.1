Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbZJAIcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbZJAIcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbZJAIcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:32:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56644 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbZJAI3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:38 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 21/34] wrap sc26xx_driver_remove by __exit_p
Date: Thu,  1 Oct 2009 10:28:25 +0200
Message-Id: <1254385718-14254-21-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
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

sc26xx_driver_remove is defined using __exit, so wrap it's usage by
__exit_p.  This fixes compiling as builtin.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
---
 drivers/serial/sc26xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index 75038ad..8ff13eb 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -729,7 +729,7 @@ static int __exit sc26xx_driver_remove(struct platform_device *dev)
 
 static struct platform_driver sc26xx_driver = {
 	.probe	= sc26xx_probe,
-	.remove	= __devexit_p(sc26xx_driver_remove),
+	.remove	= __exit_p(sc26xx_driver_remove),
 	.driver	= {
 		.name	= "SC26xx",
 		.owner	= THIS_MODULE,
-- 
1.6.4.3

