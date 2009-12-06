Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbZLFXij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbZLFXij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbZLFXig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:38:36 -0500
Received: from kroah.org ([198.145.64.141]:33753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807AbZLFXig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:36 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:08 2009
Message-Id: <20091206233208.133827759@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>
Subject: [01/20] ALSA: AACI: fix AC97 multiple-open bug
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=alsa-aaci-fix-ac97-multiple-open-bug.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 4acd57c3de62374fe5bb52e5cd24538190f4eab2 upstream.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/arm/aaci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/arm/aaci.c
+++ b/sound/arm/aaci.c
@@ -504,6 +504,10 @@ static int aaci_pcm_hw_params(struct snd
 	int err;
 
 	aaci_pcm_hw_free(substream);
+	if (aacirun->pcm_open) {
+		snd_ac97_pcm_close(aacirun->pcm);
+		aacirun->pcm_open = 0;
+	}
 
 	err = devdma_hw_alloc(NULL, substream,
 			      params_buffer_bytes(params));


