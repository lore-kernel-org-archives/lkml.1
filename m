Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYHCR2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYHCR2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYHCR2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:28:04 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:43141 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbYHCR2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:28:02 -0400
Date: Sun, 3 Aug 2008 19:27:52 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] ALSA: pcm_native: remove unused label
In-Reply-To: <20080803164719.GA5414@joi>
Message-ID: <alpine.LNX.1.10.0808031921280.7765@titan.stealer.net>
References: <20080803164719.GA5414@joi>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 03 Aug 2008 17:28:00 +0000
	Bayes: 0.0000 Tokens: new, 190; hammy, 8; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Spam-Signature: d865ac9019443a6aa9183014f90b66d16f44ec1c
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2008, Marcin Slusarz wrote:

> gcc warns about it:
> sound/core/pcm_native.c: In function 'snd_pcm_fasync':
> sound/core/pcm_native.c:3262: warning: label 'out' defined but not used
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Jaroslav Kysela <perex@perex.cz>
> ---
>  sound/core/pcm_native.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index c49b9d9..333cff6 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -3259,7 +3259,6 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
>  	runtime = substream->runtime;
>  
>  	err = fasync_helper(fd, file, on, &runtime->fasync);
> -out:
>  	unlock_kernel();
>  	if (err < 0)
>  		return err;

Uhm, no, there's

snd_assert(substream != NULL, goto out);

one line above your context. The snd_assert() macro will only include the 
second argument with CONFIG_SND_DEBUG, without CONFIG_SND_DEBUG it just 
evaulates the first parameter and triggers the warning.

Sven
