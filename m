Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZG2AAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZG2AAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZG1Xtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:52 -0400
Received: from kroah.org ([198.145.64.141]:35713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZG1Xtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:54 2009
Message-Id: <20090728234154.401549123@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 21/71] ALSA: ca0106 - Fix the max capture buffer size
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=alsa-ca0106-fix-the-max-capture-buffer-size.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 34fdeb2d07102e07ecafe79dec170bd6733f2e56 upstream.

The capture buffer size with 64kB seems broken with CA0106.
At least, either the update timing or the DMA position is wrong,
and this screws up pulseaudio badly.

This patch restricts the max buffer size less than that to make life
a bit easier.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ca0106/ca0106_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -325,9 +325,9 @@ static struct snd_pcm_hardware snd_ca010
 	.rate_max =		192000,
 	.channels_min =		2,
 	.channels_max =		2,
-	.buffer_bytes_max =	((65536 - 64) * 8),
+	.buffer_bytes_max =	65536 - 128,
 	.period_bytes_min =	64,
-	.period_bytes_max =	(65536 - 64),
+	.period_bytes_max =	32768 - 64,
 	.periods_min =		2,
 	.periods_max =		2,
 	.fifo_size =		0,


