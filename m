Return-Path: <linux-kernel-owner+w=401wt.eu-S936506AbYD1UCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936506AbYD1UCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933712AbYD1UCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:02:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:54712 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505AbYD1UCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sya+7qT95PgL1teYODqZXx7UfmGKtPvOj4ma1S3p+s/SGCuTXgtWzmamRgX/eC091lriG+6BsPxZUUJVgMIxk0KNxYi6ycEZ5L1ugzB1u0DkIutl+vLrpkafDaSOpkUQ+kcbJTtUJk0rTttj13E8K2ZWE0UVToQE9hjp1YNwuwk=
Message-ID: <9a8748490804281302w11a9ade5x8211d7f6ef5519ed@mail.gmail.com>
Date: Mon, 28 Apr 2008 22:02:25 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: Build error; sound/built-in.o:(.data+0x388): undefined reference to `snd_pcm_lib_ioctl'
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stas Sergeev" <stsp@aknet.ru>
In-Reply-To: <s5hprsai864.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490804271620v79715767n862fac6aa0cc79f7@mail.gmail.com>
	 <s5hprsai864.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/28 Takashi Iwai <tiwai@suse.de>:
> At Mon, 28 Apr 2008 01:20:08 +0200,
>
>
> Jesper Juhl wrote:
>  >
>  > FYI
>  >
>  > With the attached .config I'm getting the following build error :
...
>  > undefined reference to `snd_pcm_lib_preallocate_pages_for_all'
>  > sound/built-in.o:(.data+0x388): undefined reference to `snd_pcm_lib_ioctl'
>  > make: *** [.tmp_vmlinux1] Error 1
>
>  Does the patch below fix the problem?
>
>
>  thanks,
>
>  Takashi
>
>  ---
>  diff --git a/sound/drivers/Kconfig b/sound/drivers/Kconfig
>  index fe85af1..a78a8d0 100644
>  --- a/sound/drivers/Kconfig
>  +++ b/sound/drivers/Kconfig
>  @@ -8,6 +8,8 @@ config SND_PCSP
>         tristate "Internal PC speaker support"
>         depends on X86_PC && HIGH_RES_TIMERS
>         depends on INPUT
>  +       depends on SND
>  +       select SND_PCM
>         help
>           If you don't have a sound card in your computer, you can include a
>           driver for the PC speaker which allows it to act like a primitive
>


Yes. That solves the problem.

Thank you Takashi.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
