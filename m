Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZJAI3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZJAI3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbZJAI3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:29:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56692 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbZJAI3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:46 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       "Figo.zhang" <figo1802@gmail.com>, alsa-devel@alsa-project.org
Subject: [PATCH 24/34] don't use __devexit_p to wrap snd_sgio2audio_remove
Date: Thu,  1 Oct 2009 10:28:28 +0200
Message-Id: <1254385718-14254-24-git-send-email-u.kleine-koenig@pengutronix.de>
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

The function snd_sgio2audio_remove is defined using __exit, so don't use
__devexit_p but __exit_p to wrap it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Figo.zhang <figo1802@gmail.com>
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
---
 sound/mips/sgio2audio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/mips/sgio2audio.c b/sound/mips/sgio2audio.c
index e497525..e24ba5a 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -984,7 +984,7 @@ static int __exit snd_sgio2audio_remove(struct platform_device *pdev)
 
 static struct platform_driver sgio2audio_driver = {
 	.probe	= snd_sgio2audio_probe,
-	.remove	= __devexit_p(snd_sgio2audio_remove),
+	.remove	= __exit_p(snd_sgio2audio_remove),
 	.driver = {
 		.name	= "sgio2audio",
 		.owner	= THIS_MODULE,
-- 
1.6.4.3

