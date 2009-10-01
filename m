Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbZJAIbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbZJAIbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbZJAI3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:29:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56683 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbZJAI3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:45 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi@vger.kernel.org
Subject: [PATCH 25/34] don't use __devexit_p to wrap snirm710_driver_remove
Date: Thu,  1 Oct 2009 10:28:29 +0200
Message-Id: <1254385718-14254-25-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function snirm710_driver_remove is defined using __exit, so don't
use __devexit_p but __exit_p to wrap it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/sni_53c710.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 37b3359..491a088 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -133,7 +133,7 @@ static int __exit snirm710_driver_remove(struct platform_device *dev)
 
 static struct platform_driver snirm710_driver = {
 	.probe	= snirm710_probe,
-	.remove	= __devexit_p(snirm710_driver_remove),
+	.remove	= __exit_p(snirm710_driver_remove),
 	.driver	= {
 		.name	= "snirm_53c710",
 		.owner	= THIS_MODULE,
-- 
1.6.4.3

