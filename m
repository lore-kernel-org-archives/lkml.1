Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbYGAT2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbYGAT2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYGAT2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:28:37 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33637 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbYGAT2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:28:36 -0400
Date: Tue, 1 Jul 2008 21:29:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH linux-next 1/1] cris: look for linker scripts in srctree not in objtree
Message-ID: <20080701192922.GA10350@uranus.ravnborg.org>
References: <4849213A.4080001@cetrtapot.si> <486A3A6C.4000506@cetrtapot.si> <20080701160240.GD3921@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701160240.GD3921@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 06:02:41PM +0200, Jesper Nilsson wrote:
> Hi!
> 
> On Tue, Jul 01, 2008 at 04:08:44PM +0200, Hinko Kocevar wrote:
> > When building kernel with O= linker looks for linker scripts in output tree, while they are located in source tree.
> >
> > Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
> 
> I think this would be cleaner:
> 
> diff --git a/arch/cris/arch-v10/boot/compressed/Makefile b/arch/cris/arch-v10/boot/compressed/Makefile
> --- a/arch/cris/arch-v10/boot/compressed/Makefile
> +++ b/arch/cris/arch-v10/boot/compressed/Makefile
> @@ -4,7 +4,7 @@
>  
>  asflags-y += $(LINUXINCLUDE)
>  ccflags-y += -O2 $(LINUXINCLUDE)
> -ldflags-y += -T $(obj)/decompress.ld
> +ldflags-y += -T $(srctree)/$(src)/decompress.ld
>  OBJECTS = $(obj)/head.o $(obj)/misc.o
>  OBJCOPYFLAGS = -O binary --remove-section=.bss
>  

linker scripts are by definition named *.lds in the kernel.
And if you need to preprocess them then name them *.lds.S as
we do in arch/$ARCH/kernel/*

As this is not a generated linker script then the $(srctree)/$(src) prefix
is correct and the $(obj) prefix was plain wrong.

So:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
