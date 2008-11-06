Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbYKFVxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbYKFVxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYKFVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:53:19 -0500
Received: from mail.queued.net ([207.210.101.209]:2012 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbYKFVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:53:18 -0500
Date: Thu, 6 Nov 2008 16:53:11 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 11/14] ALSA: cs5535audio: for OLPC, default to Analog Input
 being off
Message-ID: <20081106165311.299dd338@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 63190cd..7777037 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -108,12 +108,16 @@ void olpc_mic_bias(struct snd_ac97 *ac97, int on);
 
 static inline void olpc_capture_open(struct snd_ac97 *ac97)
 {
+	/* default to Analog Input off */
+	olpc_analog_input(ac97, 0);
 	/* enable MIC Bias for recording */
 	olpc_mic_bias(ac97, 1);
 }
 
 static inline void olpc_capture_close(struct snd_ac97 *ac97)
 {
+	/* disable Analog Input */
+	olpc_analog_input(ac97, 0);
 	/* disable the MIC Bias (so the recording LED turns off) */
 	olpc_mic_bias(ac97, 0);
 }
-- 
1.5.6.5

