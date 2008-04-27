Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYD0EXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYD0EXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 00:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYD0EXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 00:23:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:53881 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYD0EXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 00:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=okCcNCiWuTAuvm1U+r1IUkAYJKrHS8wyF7UQZmR0P9X8N1sJLtyOERb1+AM8qMuKNaEeWUFCpQBWM8NsRYu24BPp9LcJ//Wvg8KCTstLZOv9rCCBg2bmhr4EMV9cOLWEJ67Mx4WoXs/FPGnytjSb8pbEOPHbbqux27jD03W2xfU=
Date: Sun, 27 Apr 2008 00:23:31 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Dmitry Torokhov <dtor-oss@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] pcspkr: fix dependancies
Message-ID: <20080427042331.GB29127@anvil.corenet.prv>
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4813BD39.1080105@aknet.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 03:39:37AM +0400, Stas Sergeev wrote:
> Hello.
> 
> Dmitry Torokhov wrote:
> > No, not another config option please. Either make pcspkr platform
> > device be created unconditionally
> I also think this would be the best
> fix. But this will return us to the
> state of 2.6.24. Presumably the dependancy
> was added for the reason, even if I
> fail to see one.
> But in any case, the patch is attached.
> 
> > or if either pcspkr or snd-pcsp
> > is selected.
> I don't think it is correct, but if
> people think it is, then this can be
> done.
> 

It looks like the change was introduced by commit

67926892ef7a7fbc76de607120d44416019fdf07

I think that we should register devices even if there is no driver in
the kernel for it because driver may be compiled at later time or be out
of tree. Adding patch author and other people that signed off the patch
to CC...

> 
> ---
> Compile pcspkr platform device unconditionally.
> That allows snd-pcsp to work.
> 
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>

> --- a/arch/x86/kernel/Makefile	2008-04-26 13:40:06.000000000 +0400
> +++ b/arch/x86/kernel/Makefile	2008-04-26 18:22:49.000000000 +0400
> @@ -83,9 +83,7 @@
>  obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
>  obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
>  
> -ifdef CONFIG_INPUT_PCSPKR
>  obj-y				+= pcspeaker.o
> -endif
>  
>  obj-$(CONFIG_SCx200)		+= scx200.o
>  scx200-y			+= scx200_32.o


-- 
Dmitry
