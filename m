Return-Path: <linux-kernel-owner+w=401wt.eu-S1764083AbZC0XqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764083AbZC0XqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761445AbZC0X2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48489 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761430AbZC0X1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:41 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: [PATCH 49/58] move snd_powermac's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:10 +0100
Message-Id: <1238196439-16535-49-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090327232153.GA16348@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
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
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 sound/ppc/powermac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index 5a92906..a2b69b8 100644
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
1.6.2

