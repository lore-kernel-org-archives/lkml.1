Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYC2WwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYC2WwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 18:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYC2WwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 18:52:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39468 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYC2WwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 18:52:15 -0400
Date: Sat, 29 Mar 2008 23:35:40 +0100
From: Pavel Machek <pavel@suse.cz>
To: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Trivial patch monkey <trivial@kernel.org>
Subject: usb audio: make quirk handling more readable, and fix
	commented-out code
Message-ID: <20080329223540.GA5506@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


usb audio contains useful  debugging code, protected by #if
0. Unfortunately, it will not compile because variable names changed;
fix it.

Dallas workaround is formatted in a way where it is not quite obvious
what is normal code and what is quirk. Reformat it to make it obvious.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 257a4e1..b6b2490 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -1427,9 +1433,9 @@ static int set_format(struct snd_usb_sub
 
 	subs->cur_audiofmt = fmt;
 
-#if 0
-	printk("setting done: format = %d, rate = %d, channels = %d\n",
-	       fmt->format, fmt->rate, fmt->channels);
+#if 0
+	printk("setting done: format = %d, rate = %d..%d, channels = %d\n",
+	       fmt->format, fmt->rate_min, fmt->rate_max, fmt->channels);
 	printk("  datapipe = 0x%0x, syncpipe = 0x%0x\n",
 	       subs->datapipe, subs->syncpipe);
 #endif
@@ -2464,11 +2470,12 @@ static int parse_audio_format_i_type(str
 		}
 		break;
 	case USB_AUDIO_FORMAT_PCM8:
-		/* Dallas DS4201 workaround */
+		pcm_format = SNDRV_PCM_FORMAT_U8;
+
+		/* Dallas DS4201 workaround: it advertises U8 format, but really
+		   supports S8. */
 		if (chip->usb_id == USB_ID(0x04fa, 0x4201))
 			pcm_format = SNDRV_PCM_FORMAT_S8;
-		else
-			pcm_format = SNDRV_PCM_FORMAT_U8;
 		break;
 	case USB_AUDIO_FORMAT_IEEE_FLOAT:
 		pcm_format = SNDRV_PCM_FORMAT_FLOAT_LE;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
