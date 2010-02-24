Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab0BXXpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 18:45:36 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:39120 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758553Ab0BXXpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 18:45:34 -0500
Date: Wed, 24 Feb 2010 18:45:05 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
Message-ID: <20100224184505.1d8d3380@droptest.queued.net>
In-Reply-To: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously the MIC GPIO was set to output mode, and when checking the status
after setting it we were checking OUTPUT_VAL.  This worked, though I'm not
quite sure why.  Instead, if we actually check the READ_BACK value, it
doesn't work unless the GPIO is in bidirectional mode.  Thus, enable
input mode as well.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 sound/pci/cs5535audio/cs5535audio_olpc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 50da49b..f5574f2 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -157,6 +157,7 @@ int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 		return -EIO;
 	}
 	gpio_direction_output(OLPC_GPIO_MIC_AC, 0);
+	gpio_direction_input(OLPC_GPIO_MIC_AC);
 
 	/* drop the original AD1888 HPF control */
 	memset(&elem, 0, sizeof(elem));
-- 
1.5.6.5

