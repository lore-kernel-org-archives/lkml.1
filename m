Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZALWpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZALWpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbZALWaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:30:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49338 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017AbZALWaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:30:24 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2009 23:24:56 +0100
Message-Id: <1231799107-20136-51-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] move snd_powermac's probe function to .devinit.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to snd_pmac_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (when having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 sound/ppc/powermac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index c936225..c95c30d 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -51,7 +51,7 @@ static struct platform_device *device;
 /*
  */
 
-static int __init snd_pmac_probe(struct platform_device *devptr)
+static int __devinit snd_pmac_probe(struct platform_device *devptr)
 {
 	struct snd_card *card;
 	struct snd_pmac *chip;
-- 
1.5.6.5

