Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZLMOJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZLMOJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 09:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZLMOJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 09:09:35 -0500
Received: from mx.sz.bfs.de ([194.94.69.70]:40829 "HELO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751382AbZLMOJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 09:09:34 -0500
Message-ID: <4B24F58C.4050502@bfs.de>
Date: Sun, 13 Dec 2009 15:09:16 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/9] sound/soc/codecs: Correct code taking the size of
 a pointer
References: <Pine.LNX.4.64.0912131242570.24267@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912131242570.24267@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Julia Lawall schrieb:
> From: Julia Lawall <julia@diku.dk>
> 
> sizeof(codec->reg_cache) is just the size of the pointer.  Elsewhere in the
> file, codec->reg_cache is used with sizeof(wm8900_reg_defaults), so the
> code is changed to do the same here.
> 
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression *x;
> expression f;
> type T;
> @@
> 
> *f(...,(T)x,...)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  sound/soc/codecs/wm8900.c           |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
> index c9438dd..dbc368c 100644
> --- a/sound/soc/codecs/wm8900.c
> +++ b/sound/soc/codecs/wm8900.c
> @@ -199,7 +199,7 @@ static void wm8900_reset(struct snd_soc_codec *codec)
>  	snd_soc_write(codec, WM8900_REG_RESET, 0);
>  
>  	memcpy(codec->reg_cache, wm8900_reg_defaults,
> -	       sizeof(codec->reg_cache));
> +	       sizeof(wm8900_reg_defaults));
>  }

I do not think that this was the intention of the original author,
I guess the idea behind sizeof(*codec->reg_cache) was to protect
the area behind it (in case wm8900_reg_defaults are badly defined).

re,
 wh

