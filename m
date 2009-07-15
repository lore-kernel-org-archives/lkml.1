Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZGOGaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZGOGaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZGOGay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:30:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:52700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbZGOGax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:30:53 -0400
Subject: sound/soc/codecs/wm9081.c compiler warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jul 2009 12:00:34 +0530
Message-Id: <1247639434.2437.14.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting this compiler warning in linus tree:

  CC [M]  sound/soc/codecs/wm9081.o
sound/soc/codecs/wm9081.c: In function ‘configure_clock’:
sound/soc/codecs/wm9081.c:674: warning: ‘new_sysclk’ may be used uninitialized in this function

This fixes the warning in my case, hope this will be helpful :

diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 86fc57e..77a7997 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -696,6 +696,7 @@ static int configure_clock(struct snd_soc_codec *codec)
 		 * not the case, though care must be taken with free
 		 * running mode.
 		 */
+		new_sysclk = 12288000;
 		if (wm9081->master && wm9081->bclk) {
 			/* Make sure we can generate CLK_SYS and BCLK
 			 * and that we've got 3MHz for optimal
@@ -714,8 +715,6 @@ static int configure_clock(struct snd_soc_codec *codec)
 				if (new_sysclk > 3000000)
 					break;
 			}
-		} else {
-			new_sysclk = 12288000;
 		}
 
 		ret = wm9081_set_fll(codec, WM9081_SYSCLK_FLL_MCLK,

--
JSR

