Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZHYU7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZHYU7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZHYU7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:59:39 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60645 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbZHYU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: tiwai@suse.de
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 4/4] SOUND: wm8900, use uninitialized_var(fll_div)
Date: Tue, 25 Aug 2009 22:59:37 +0200
Message-Id: <1251233977-5819-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251233977-5819-1-git-send-email-jirislaby@gmail.com>
References: <1251233977-5819-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid a wrong compiler warning, use unitialized_var(fll_div) in
wm8900_set_fll.

If fll_div members are unitialized, we return before their use due to
error.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
---
 sound/soc/codecs/wm8900.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index 5e9c855..255210a 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -747,7 +747,7 @@ static int wm8900_set_fll(struct snd_soc_codec *codec,
 	int fll_id, unsigned int freq_in, unsigned int freq_out)
 {
 	struct wm8900_priv *wm8900 = codec->private_data;
-	struct _fll_div fll_div;
+	struct _fll_div uninitialized_var(fll_div);
 	unsigned int reg;
 
 	if (wm8900->fll_in == freq_in && wm8900->fll_out == freq_out)
-- 
1.6.3.3

