Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbZJAIcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbZJAIcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932353AbZJAIcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:32:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56647 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbZJAI3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:38 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>, linux-scsi@vger.kernel.org
Subject: [PATCH 23/34] don't use __devexit_p to wrap sgiwd93_remove
Date: Thu,  1 Oct 2009 10:28:27 +0200
Message-Id: <1254385718-14254-23-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function sgiwd93_remove is defined using __exit, so don't use
__devexit_p but __exit_p to wrap it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/sgiwd93.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 0807b26..2f28ec4 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -312,7 +312,7 @@ static int __exit sgiwd93_remove(struct platform_device *pdev)
 
 static struct platform_driver sgiwd93_driver = {
 	.probe  = sgiwd93_probe,
-	.remove = __devexit_p(sgiwd93_remove),
+	.remove = __exit_p(sgiwd93_remove),
 	.driver = {
 		.name   = "sgiwd93",
 		.owner	= THIS_MODULE,
-- 
1.6.4.3

