Return-Path: <linux-kernel-owner+w=401wt.eu-S1765774AbXJROzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765774AbXJROzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXJROzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:55:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbXJROzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:55:04 -0400
Date: Thu, 18 Oct 2007 16:54:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] snd: fix build bug with
	CONFIG_SND_HDA_CODEC_SIGMATEL=y && !CONFIG_SND_HDA_GENERIC
Message-ID: <20071018145458.GA1040@elte.hu>
References: <20071018095042.GA21361@elte.hu> <s5h64141r2z.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h64141r2z.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> +++ b/sound/pci/hda/patch_sigmatel.c	Thu Oct 18 16:23:22 2007 +0200
> @@ -3062,9 +3062,16 @@ static int patch_stac9872(struct hda_cod
>  	board_config = snd_hda_check_board_config(codec, STAC_9872_MODELS,
>  						  stac9872_models,
>  						  stac9872_cfg_tbl);
> -	if (board_config < 0)
> +	if (board_config < 0) {
> +		printk(KERN_WARNING "hda-codec: "
> +		       "found unknown STAC9872 device\n");
> +#ifdef CONFIG_SND_HDA_GENERIC
>  		/* unknown config, let generic-parser do its job... */
>  		return snd_hda_parse_generic_codec(codec);
> +#else
> +		return -ENODEV;
> +#endif

pushing an #ifdef into a driver is quite unclean, if then you should 
define snd_hda_parse_generic_codec() in a header as a -ENODEV inline 
function if !CONFIG_SND_HDA_GENERIC.

	Ingo
