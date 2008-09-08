Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYIHSvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYIHSvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYIHSv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:51:28 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:54971 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755305AbYIHSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:51:26 -0400
Date: Mon, 8 Sep 2008 20:51:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Jaroslav Kysela <perex@perex.cz>, Brian Avery <b.avery@hp.com>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RESEND, PATCH] Fix section for sa11xx-uda1341 platform driver
Message-ID: <20080908185123.GA22076@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	linux-kernel@vger.kernel.org,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Jaroslav Kysela <perex@perex.cz>, Brian Avery <b.avery@hp.com>,
	alsa-devel@alsa-project.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080902210501.GA4306@informatik.uni-freiburg.de> <1220876004-5784-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1220876004-5784-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use __init but __devinit to define probe function.  A pointer to
sa11xx_uda1341_probe is passed to the core via platform_driver_register and
so the function must not disappear after the module is loaded.  Using __init
and having HOTPLUG=y and SND_SA11XX_UDA1341=m the following probably oopses:

	echo -n sa11xx_uda1341.1 > /sys/bus/platform/driver/sa11xx_uda1341/unbind
	echo -n sa11xx_uda1341.1 > /sys/bus/platform/driver/sa11xx_uda1341/bind

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Brian Avery <b.avery@hp.com>
Cc: alsa-devel@alsa-project.org
Cc: Andrew Morton <akpm@linux-foundation.org>

---
Hello,

uups, I forgot to add the right cc:.  Sorry.

@Andrew,  I have a few more patches of this type pending.  Is it OK for
you if they go via you?  This would ease the process a bit for me.

Uwe

 sound/arm/sa11xx-uda1341.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/arm/sa11xx-uda1341.c b/sound/arm/sa11xx-uda1341.c
index b9c51bf..da25b41 100644
--- a/sound/arm/sa11xx-uda1341.c
+++ b/sound/arm/sa11xx-uda1341.c
@@ -879,7 +879,7 @@ void snd_sa11xx_uda1341_free(struct snd_card *card)
 	audio_dma_free(&chip->s[SNDRV_PCM_STREAM_CAPTURE]);
 }
 
-static int __init sa11xx_uda1341_probe(struct platform_device *devptr)
+static int __devinit sa11xx_uda1341_probe(struct platform_device *devptr)
 {
 	int err;
 	struct snd_card *card;
-- 
tg: (7686ad5..) t/sectionfixes/sa11xx_uda1341 (depends on: t/sectionfixes/sa11xx_uda1341)

-- 
Uwe Kleine-König

http://www.google.com/search?q=1+electron+mass%3D
