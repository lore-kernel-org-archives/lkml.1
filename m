Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293Ab0AWUkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0AWUkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908Ab0AWUfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:35:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50465 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0AWUfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:51 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Dmitri Vorobiev <dmitri.vorobiev@movial.fi>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Andrew Morton <akpm@linux-foundation.org>, peter fuerst <post@pfrst.de>,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 22/29] move sgiwd93's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:30 +0100
Message-Id: <1264278937-19675-22-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to sgiwd93_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: peter fuerst <post@pfrst.de>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/scsi/sgiwd93.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 0807b26..fef0e3c 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -226,7 +226,7 @@ static struct scsi_host_template sgiwd93_template = {
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
-static int __init sgiwd93_probe(struct platform_device *pdev)
+static int __devinit sgiwd93_probe(struct platform_device *pdev)
 {
 	struct sgiwd93_platform_data *pd = pdev->dev.platform_data;
 	unsigned char *wdregs = pd->wdregs;
-- 
1.6.6

