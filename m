Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZFFQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZFFQMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 12:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZFFQMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 12:12:45 -0400
Received: from mail1.perex.cz ([212.20.107.53]:41747 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZFFQMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 12:12:45 -0400
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jun 2009 12:12:45 EDT
Date: Sat, 6 Jun 2009 17:52:44 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sound] mpd loops on current -next
In-Reply-To: <4A2A8F6A.80705@gmail.com>
Message-ID: <alpine.LNX.2.00.0906061752040.4067@eeebox2.perex-int.cz>
References: <4A2A8F6A.80705@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009, Jiri Slaby wrote:

> Hi,
>
> I found a regression in current -next caused by
> c44941e05900fe85f6091456f9e313b446a97ae9
> (PCM midlevel: Do not update hw_ptr_jiffies when hw_ptr is not changed)

Oops. It seems like typo. Could you try this patch, please?

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index dd9126b..bf34603 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -371,7 +371,7 @@ int snd_pcm_update_hw_ptr(struct snd_pcm_substream *substream)
  	    runtime->silence_size > 0)
  		snd_pcm_playback_silence(substream, new_hw_ptr);

-	if (runtime->status->hw_ptr != new_hw_ptr)
+	if (runtime->status->hw_ptr == new_hw_ptr)
  		return 0;

  	runtime->hw_ptr_base = hw_base;

 					Thanks,
 						Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

