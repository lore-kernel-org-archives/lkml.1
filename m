Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYHSPyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYHSPyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYHSPyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:54:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:7870 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYHSPyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FxKuKL+cSl2u9n0t7qnWbl71GZIZKwhaCtSVBKfiN1EG2vd1D8OjowPMB5aCS6r1tI
         vGFcu7xIH3dwrW9dXGOItUJ9kIyn1gfM+664Kl4khNSW4Y+tyx3jZt2vaQoEiQvmyGkn
         W7mTrtXpi543iU4HQcUrxwUik1D1Nm2vRCJQM=
Message-ID: <48AAEC92.8050108@gmail.com>
Date: Tue, 19 Aug 2008 11:53:54 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Johannes Berg <johannes@sipsolutions.net>, linuxppc-dev@ozlabs.org,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [alsa-devel] [PATCH v2] duplicate SNDRV_PCM_FMTBIT_S{16,24}_BE
References: <48AA407C.8090409@gmail.com>	<3ef3fed769e5aa57681bacea1230e82b.squirrel@secure.sipsolutions.net> <s5hbpzpxrfh.wl%tiwai@suse.de>
In-Reply-To: <s5hbpzpxrfh.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Tue, 19 Aug 2008 08:15:05 +0200 (CEST),
> Johannes Berg wrote:
>> roel kluin wrote:
>>> untested, is it correct?
>> not a clue, do you know how long ago that was? :)
>> does the driver check endianness anywhere?
> 
> AFAIK snd-aoa supports only bit-endian formats (at least in
> sound/aoa/soundbus/i2sbus-pcm.c), so this addition makes little
> sense.
> 
> Better to drop the duplicated words there.

Thanks Johannes and Takashi,

FWIW this removes the duplicates.
---
Remove duplicate assignment of SNDRV_PCM_FMTBIT_S{16,24}_BE bits

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/sound/aoa/codecs/snd-aoa-codec-tas.c b/sound/aoa/codecs/snd-aoa-codec-tas.c
index 7a16a33..6c515b2 100644
--- a/sound/aoa/codecs/snd-aoa-codec-tas.c
+++ b/sound/aoa/codecs/snd-aoa-codec-tas.c
@@ -654,15 +654,13 @@ static struct snd_kcontrol_new bass_control = {
 static struct transfer_info tas_transfers[] = {
 	{
 		/* input */
-		.formats = SNDRV_PCM_FMTBIT_S16_BE | SNDRV_PCM_FMTBIT_S16_BE |
-			   SNDRV_PCM_FMTBIT_S24_BE | SNDRV_PCM_FMTBIT_S24_BE,
+		.formats = SNDRV_PCM_FMTBIT_S16_BE | SNDRV_PCM_FMTBIT_S24_BE,
 		.rates = SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000,
 		.transfer_in = 1,
 	},
 	{
 		/* output */
-		.formats = SNDRV_PCM_FMTBIT_S16_BE | SNDRV_PCM_FMTBIT_S16_BE |
-			   SNDRV_PCM_FMTBIT_S24_BE | SNDRV_PCM_FMTBIT_S24_BE,
+		.formats = SNDRV_PCM_FMTBIT_S16_BE | SNDRV_PCM_FMTBIT_S24_BE,
 		.rates = SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000,
 		.transfer_in = 0,
 	},

