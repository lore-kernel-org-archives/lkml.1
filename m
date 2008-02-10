Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbYBJD3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbYBJD3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 22:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbYBJD3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 22:29:09 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:56682 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754983AbYBJD3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 22:29:07 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/video/em28xx/: Fix undefined symbol error with CONFIG_SND=N
Date: Sun, 10 Feb 2008 05:27:23 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: mchehab@infradead.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802100527.25823.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch fixes following undefined symbol errors with CONFIG_SND=N

ERROR: "snd_pcm_period_elapsed" [drivers/media/video/em28xx/em28xx-alsa.ko] undefined!
ERROR: "snd_pcm_hw_constraint_integer" [drivers/media/video/em28xx/em28xx-alsa.ko] undefined!
ERROR: "snd_pcm_set_ops" [drivers/media/video/em28xx/em28xx-alsa.ko] undefined!
ERROR: "snd_pcm_lib_ioctl" [drivers/media/video/em28xx/em28xx-alsa.ko] undefined!
ERROR: "snd_card_new" [drivers/media/video/em28xx/em28xx-alsa.ko] undefined!
ERROR: "snd_card_free" [drivers/media/video/em28xx/em28xx-alsa.ko] undefined!
ERROR: "snd_card_register" [drivers/media/video/em28xx/em28xx-alsa.ko] undefined!
ERROR: "snd_pcm_new" [drivers/media/video/em28xx/em28xx-alsa.ko] undefined!

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr> 
 
 drivers/media/video/em28xx/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
index abbd38c..0f7a0bd 100644
--- a/drivers/media/video/em28xx/Kconfig
+++ b/drivers/media/video/em28xx/Kconfig
@@ -13,7 +13,8 @@ config VIDEO_EM28XX
 	  module will be called em28xx
 
 config VIDEO_EM28XX_ALSA
-	depends on VIDEO_EM28XX
+	depends on VIDEO_EM28XX && SND
+	select SND_PCM
 	tristate "Empia EM28xx ALSA audio module"
 	---help---
 	  This is an ALSA driver for some Empia 28xx based TV cards.

Cheeer
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
