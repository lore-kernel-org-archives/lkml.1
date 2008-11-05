Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYKEWha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYKEWha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYKEWhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:37:18 -0500
Received: from mail.queued.net ([207.210.101.209]:4983 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbYKEWhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:37:17 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2008 17:37:17 EST
Date: Wed, 5 Nov 2008 17:30:30 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/4] ALSA: cs5535audio: suspend/resume callbacks are only
 defined with CONFIG_PM
Message-ID: <20081105173030.2bcf1039@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


snd_cs5535audio_suspend and snd_cs5535audio_resume are only defined when
CONFIG_PM is set; make that clear in the header file.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 57e9c65..1aa1e2b 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -94,8 +94,11 @@ struct cs5535audio {
 	struct cs5535audio_dma dmas[NUM_CS5535AUDIO_DMAS];
 };
 
+#ifdef CONFIG_PM
 int snd_cs5535audio_suspend(struct pci_dev *pci, pm_message_t state);
 int snd_cs5535audio_resume(struct pci_dev *pci);
+#endif
+
 int __devinit snd_cs5535audio_pcm(struct cs5535audio *cs5535audio);
 
 #endif /* __SOUND_CS5535AUDIO_H */
-- 
1.5.6.5

