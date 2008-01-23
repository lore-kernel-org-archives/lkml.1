Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYAWHZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYAWHZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 02:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYAWHZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 02:25:32 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55902 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbYAWHZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 02:25:31 -0500
Date: Wed, 23 Jan 2008 08:25:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, perex@perex.cz,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] sound: fix cs5535 section mismatch
Message-ID: <20080123072539.GB19132@uranus.ravnborg.org>
References: <20080122213943.939bc1cb.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122213943.939bc1cb.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 09:39:43PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> snd_cs5535audio_mixer() is only called by __devinit snd_cs5535audio_probe(),
> so the mixer function can also be __devinit.
> 
> WARNING: vmlinux.o(.text+0xfdbba0): Section mismatch: reference to .init.data:ac97_quirks (between 'snd_cs5535audio_mixer' and 'process_bm0_irq')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  sound/pci/cs5535audio/cs5535audio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.24-rc8-git5.orig/sound/pci/cs5535audio/cs5535audio.c
> +++ linux-2.6.24-rc8-git5/sound/pci/cs5535audio/cs5535audio.c
> @@ -145,7 +145,7 @@ static unsigned short snd_cs5535audio_ac
>  	return snd_cs5535audio_codec_read(cs5535au, reg);
>  }
>  
> -static int snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
> +static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
>  {
>  	struct snd_card *card = cs5535au->card;
>  	struct snd_ac97_bus *pbus;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
