Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZEYWku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZEYWku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZEYWkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:40:43 -0400
Received: from luminismail.carleton.ca ([134.117.2.27]:48118 "EHLO
	luminismail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZEYWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:40:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Message-id: <4A1B1E6A.7060205@superonline.com>
Date: Mon, 25 May 2009 18:40:42 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
To: linux-kernel@vger.kernel.org
Subject: Re: [Bisected regression] Microphone no longer works on Toshiba
 Satellite A100
References: <4A196CF5.8010504@superonline.com> <s5hskiuv4d2.wl%tiwai@suse.de>
 <4A198CAD.6090109@superonline.com> <s5hk545d8sc.wl%tiwai@suse.de>
In-reply-to: <s5hk545d8sc.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
>>> [snip]
> Thanks.  Does the patch below work?

Yes, I just tried it by compiling alsa-driver-1.0.20 after applying
the patch you provided, and I can happily say that it works beautifully.

Thank you so much! I really hope that this patch will be included in
the next ALSA release and the next -rc release for 2.6.30.

> 
> (snip)
>> When one first boots this laptop, alsamixer does not show PCM playback and
>> Digital Input capture channels. However, if I run a ALSA-compatible program
>> which uses the PCM playback (such as mpg321) or the Digital Input capture
>> channel (such as arecord), then the respective channels appear in alsamixer.
>> Does this mean that a new "model=..." quirk needs to be written for this
>> this laptop? ("model=toshiba" does not work properly.)
> 
> The PCM and Digital Capture Volume are implemented in alsa-lib softvol
> plugin and is irrelevant with the driver model.  They appear either
> when you first use PCM via alsa-lib with that configuration, or when
> you restore the previous volume setting via alsactl.
> 
> Usually distro udev or init script restores the previous volume via
> alsactl, so this will appear after the very first use after the
> installation...

That clears up a lot of things. I am sorry if this was already documented
in the ALSA documentation/wiki and I missed it.

> thanks,
> 
> Takashi

Thank you once again,

M. Vefa Bicakci


> ---
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index bcbb736..0fd258e 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -776,6 +776,12 @@ static void alc_set_input_pin(struct hda_codec *codec, hda_nid_t nid,
>  		pincap = (pincap & AC_PINCAP_VREF) >> AC_PINCAP_VREF_SHIFT;
>  		if (pincap & AC_PINCAP_VREF_80)
>  			val = PIN_VREF80;
> +		else if (pincap & AC_PINCAP_VREF_50)
> +			val = PIN_VREF50;
> +		else if (pincap & AC_PINCAP_VREF_100)
> +			val = PIN_VREF100;
> +		else if (pincap & AC_PINCAP_VREF_GRD)
> +			val = PIN_VREFGRD;
>  	}
>  	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, val);
>  }
> 
> 
> 
