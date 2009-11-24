Return-Path: <linux-kernel-owner+w=401wt.eu-S934118AbZKXVIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbZKXVIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934092AbZKXVIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:08:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44760 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934054AbZKXVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:43 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi@vger.kernel.org
Subject: [PATCH 19/38] move snirm710_driver_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:14 +0100
Message-Id: <1259096853-18909-19-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259096853-18909-18-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function snirm710_driver_remove is used only wrapped by __devexit_p
so define it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/scsi/sni_53c710.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 37b3359..c941a00 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -116,7 +116,7 @@ static int __init snirm710_probe(struct platform_device *dev)
 	return -ENODEV;
 }
 
-static int __exit snirm710_driver_remove(struct platform_device *dev)
+static int __devexit snirm710_driver_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
 	struct NCR_700_Host_Parameters *hostdata =
-- 
1.6.5.2

