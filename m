Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYBYTr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYBYTr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYBYTqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:46:39 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50338 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653AbYBYTqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:46:37 -0500
Message-Id: <1203968796.24935.1239027765@webmail.messagingengine.com>
X-Sasl-Enc: Vh55WTA4IdovrHQW3FYGtrwcdQkfYaCAsRqbPI9uUhIw 1203968796
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com>
   <1203958478.20033.1239002461@webmail.messagingengine.com>
   <20080225170134.GA15839@elte.hu>
   <20080225180750.GA31054@mailshack.com> <47C3053D.5060504@zytor.com>
Subject: Re: [PATCH] reserve_early end-of-conventional-memory to 1MB
In-Reply-To: <47C3053D.5060504@zytor.com>
Date: Mon, 25 Feb 2008 20:46:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 10:13:17 -0800, "H. Peter Anvin" <hpa@zytor.com>
said:
> Alexander van Heukelum wrote:
> > 
> >  arch/x86/kernel/head64.c |   45 +++++++++++++++++++++++++++------------------
> >  1 files changed, 27 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> > index 38f32e7..b684552 100644
> > --- a/arch/x86/kernel/head64.c
> > +++ b/arch/x86/kernel/head64.c
> > @@ -49,33 +49,42 @@ static void __init copy_bootdata(char *real_mode_data)
> >  	}
> >  }
> >  
> > -#define EBDA_ADDR_POINTER 0x40E
> > +#define BIOS_EBDA_SEGMENT 0x40E
> > +#define BIOS_LOWMEM_KILOBYTES 0x413
> >  
> 
> Linus has specific comments in the 32-bit code that states we do not 
> want to use address 0x413 for anything - if nothing else because it's 
> often lowered when there is boottime code involved like CD-ROM booting 
> or PXE.

Hello hpa,

I failed to find a comment referring to 0x413 or int 0x12 in
arch/x86/kernel. I do know the comment in Documentation/i386/boot.txt,
however, suggesting that "INT 12h" _should_ be used, but that it would
be pointless for zImage and old bzImage kernels, because they _have_
to be started from 0x90000 anyway. New bzImage kernels do not have
this limitation, and smart bootloaders simply put them at much
lower addresses, like 0x40000. (I know: you know.) My point is just
that the argument not to use 0x413 in the bootloader is not valid
for this case.

That leaves the possibility that code/data is inserted at the top of
conventional memory by either the BIOS or some kind of bootloader.
My view on this is that this code/data should be preserved: it
was specifically asked from us by lowering 0x413. One just loses
a tiny bit of usable memory, and if the program booting the kernel
knows better it can unload the driver if it wants to. It's just
not a kernel problem.

> Either way, the code should be shared between 32 and 64 bits.
> There is nothing bitsize-specific about it!

Of course. That's also why I already added the old-Dell case ;).
But one problem at a time, please!

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - I mean, what is it about a decent email service?

