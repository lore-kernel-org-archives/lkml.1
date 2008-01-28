Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYA1WUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYA1WUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761801AbYA1WN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:13:58 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1279 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762937AbYA1WNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:13:55 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.24-rc8-mm1: old sparc64 bug
Date: Mon, 28 Jan 2008 23:13:52 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>,
       perex@perex.cz
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <200801251934.35782.m.kozlowski@tuxland.pl> <s5hejc26u76.wl%tiwai@suse.de>
In-Reply-To: <s5hejc26u76.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282313.52670.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Takashi,

> > > > 	I was digging through the gentoo bugzilla and found this:
> > > > 
> > > > http://bugs.gentoo.org/show_bug.cgi?id=141823
> > > > 
> > > > As you see this bug is present since at least 2.6.17. I can reproduce
> > > > that here on my hardware with 2.6.24-rc8-mm1. All you need to do is install
> > > > mp3blaster on sparc64, run:
> > > > 
> > > > $ mp3blaster some_mp3_file.mp3 
> > > > 
> > > > and stop it by pressing ctrl-c. It oopses when you stop it. It doesn't happen
> > > > every time but it'll oops in a few tries.
> > > 
> > > This looks similar like a bug I fixed ago.  Damn, it's still there.
> > > 
> > > Could you build with CONFIG_SND_DEBUG=y ?  It addas some sanity checks
> > > and might catch the fatal condition.
> > 
> > Done. I don't think it changed much though :-/
> 
> OK, could you try the patch below?

Great news. It works fine now. I tested it for some time but I'll test it even more
tommorow.

Thanks,

	Mariusz

> 
> thanks,
> 
> Takashi
> 
> ---
> 
> diff -r edbe1b84179b sound/core/oss/pcm_oss.c
> --- a/sound/core/oss/pcm_oss.c	Mon Jan 28 12:30:17 2008 +0100
> +++ b/sound/core/oss/pcm_oss.c	Mon Jan 28 12:56:13 2008 +0100
> @@ -1621,6 +1621,7 @@ static int snd_pcm_oss_sync(struct snd_p
>  					snd_pcm_format_set_silence(runtime->format,
>  								   runtime->oss.buffer,
>  								   size1);
> +					size1 /= runtime->channels; /* frames */
>  					fs = snd_enter_user();
>  					snd_pcm_lib_write(substream, (void __user *)runtime->oss.buffer, size1);
>  					snd_leave_user(fs);
> 


