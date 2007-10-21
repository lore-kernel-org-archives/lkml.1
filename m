Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbXJUPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbXJUPm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 11:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXJUPmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 11:42:52 -0400
Received: from www17.your-server.de ([213.133.104.17]:48580 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXJUPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 11:42:52 -0400
Message-ID: <471B7370.7070009@m3y3r.de>
Date: Sun, 21 Oct 2007 17:42:40 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: hda-intel: no soundcard with current linus' git tree
References: <471538C2.80806@m3y3r.de>	<200710180353.08638.maximlevitsky@gmail.com>	<s5hd4vdc6d4.wl%tiwai@suse.de>	<200710181621.59795.maximlevitsky@gmail.com> <s5h4pgo1qjh.wl%tiwai@suse.de>
In-Reply-To: <s5h4pgo1qjh.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai schrieb:
>
> Both are handled as patch_stac925x.  That's what I meant.  With your
> patch, there will be no master any more.
>
> So, how about the patch below?
>
>
> Takashi
>
> diff -r fb9512ce24e0 pci/hda/patch_sigmatel.c
> --- a/pci/hda/patch_sigmatel.c	Thu Oct 18 10:48:43 2007 +0200
> +++ b/pci/hda/patch_sigmatel.c	Thu Oct 18 16:36:35 2007 +0200
> @@ -111,6 +111,7 @@ struct sigmatel_spec {
>  	unsigned int alt_switch: 1;
>  	unsigned int hp_detect: 1;
>  	unsigned int gpio_mute: 1;
> +	unsigned int no_vol_knob :1;
>  
>  	unsigned int gpio_mask, gpio_data;
>  
> @@ -1930,7 +1931,8 @@ static int stac92xx_auto_create_hp_ctls(
>  	}
>  	if (spec->multiout.hp_nid) {
>  		const char *pfx;
> -		if (old_num_dacs == spec->multiout.num_dacs)
> +		if (old_num_dacs == spec->multiout.num_dacs &&
> +		    spec->no_vol_knob)
>  			pfx = "Master";
>  		else
>  			pfx = "Headphone";
> @@ -2487,6 +2489,7 @@ static int patch_stac9200(struct hda_cod
>  	codec->spec = spec;
>  	spec->num_pins = ARRAY_SIZE(stac9200_pin_nids);
>  	spec->pin_nids = stac9200_pin_nids;
> +	spec->no_vol_knob = 1;
>  	spec->board_config = snd_hda_check_board_config(codec, STAC_9200_MODELS,
>  							stac9200_models,
>  							stac9200_cfg_tbl);
> @@ -2541,6 +2544,7 @@ static int patch_stac925x(struct hda_cod
>  	codec->spec = spec;
>  	spec->num_pins = ARRAY_SIZE(stac925x_pin_nids);
>  	spec->pin_nids = stac925x_pin_nids;
> +	spec->no_vol_knob = 1;
>  	spec->board_config = snd_hda_check_board_config(codec, STAC_925x_MODELS,
>  							stac925x_models,
>
>   
Thanks. Soundcard is back and my "multimedia" keys for configuring the
master volume are working again with alsa 1.0.15 and above patch.

mfg
thomas

