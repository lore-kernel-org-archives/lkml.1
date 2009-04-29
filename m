Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZD2LWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZD2LWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZD2LVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:21:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:24255 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbZD2LVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DfjjzPT5NHWlBQ18NYigOLP7K/9Jz2B5xe2nKR6iwdqunD3tE2BfhtYn1IMPVNh2YY
         NFX9h5HDW1U4Y9GqPBIM5H2Q6CK6GPLI1+PXJLoddTqgziWC4pmqnAoVmUa35B/FyTLO
         i1RE0Xez4p2MXw0zyofWBt6iaBUYK3y8WPdtY=
MIME-Version: 1.0
In-Reply-To: <7D4BD025A2554467AD77428C455E1FE0@avitech.sk>
References: <7D4BD025A2554467AD77428C455E1FE0@avitech.sk>
Date: Wed, 29 Apr 2009 13:21:47 +0200
X-Google-Sender-Auth: 85ed1b4e7d818ae9
Message-ID: <10f740e80904290421w3e914ebew94eb6081cbea1cdc@mail.gmail.com>
Subject: Re: Intel KMS + fbcon + Mplayer
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Hanzel <hanzelpeter@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 12:04, Peter Hanzel <hanzelpeter@gmail.com> wrote:
> I have tried Intel KMS in kernel 2.6.91.1 with fbcon. I am using only
> framebuffer console.
> Most fb apps works, but I have problem with mplayer.
> The init works but the video is badly displayed.
> I have investigated the problem and found, that for my laptop mode
> 1280x800-32.
>
> The ioctl on /dev/fb0 FBIOGET_VSCREENINFO returns.
> var.bits_per_pixel=32
> var.transp.length = 0.
>
> So the mplayer thinks we are in 24 bit mode (maybe this is bug in mplayer,
> because bits_per_pixel is 32).
>
> But next I have checked it with kernel vesafb and for same mode
> (1280x800-32, vga=0x362 )
> The fb ioctl returns
> var.bits_per_pixel=32
> var.transp.length = 8.
>
> So is this intentionally made so. Because I think this mode use only red,
> green,blue and no transp. But for one pixel you must write 4 bytes. (so
> transp is not used).

That must be a bug in mplayer, as var.bits_per_pixel = 32. If there's
no transparency, it's
correct to hav var.transp.length = 0 . The additional 8 bits may be unused.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
