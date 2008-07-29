Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbYG2U7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbYG2U7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbYG2U7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:59:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYG2U7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:59:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux v2.6.27-rc1: problem with firmware stuff
Date: Tue, 29 Jul 2008 23:01:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807292249.48050.rjw@sisk.pl>
In-Reply-To: <200807292249.48050.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807292301.36987.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 of July 2008, Rafael J. Wysocki wrote:
> On Tuesday, 29 of July 2008, Linus Torvalds wrote:
> > 
> > It's two weeks (and one day), and the merge window is over.
> > 
> > Finally. I don't know why, but this one really did feel pretty dang busy. 
> > And the size of the -rc1 patch bears that out - at 12MB, it's about 50% 
> > bigger than 26-rc1 (but not that much bigger than 24/25-rc1, so it's not 
> > like it's anything unheard of).
> > 
> > The pure size of the -rc's _is_ making me a bit nervous, though. Sure, it 
> > means that we are good at merging it all, but I have to say that I 
> > sometimes wonder if we don't merge too much in one go, and even our 
> > current (fairly short) release cycle is actually too big.
> > 
> > Anyway, that's a discussion for some other event.
> > 
> > Much of -rc1 was in linux-next, but certainly not everything. We'll see 
> > how that whole thing ends up evolving - it certainly didn't solve all 
> > problems, and there was some bickering about things that weren't there 
> > (and some things that mostly were ;), but maybe it helped.
> > 
> > There's a ton of new stuff in there, but at least personally the 
> > interesting things are the BKL pushdown and perhaps the introduction of 
> > the lockless get_user_pages_fast(). The build system also got updated to 
> > allow moving the architecture include files ("include/asm-xyz") into the 
> > architecture subdirectories ("arch/xyz/include/asm"), and sparc seems to 
> > have taken advantage of that already.
> > 
> > But those changes are just small details in the end. As usual, the bulk of 
> > changes are all to device drivers (roughly half, as usual), with the arch 
> > directory amounting to about half of the remainder. Dirstat:
> > 
> >    3.2% arch/arm/
> >    9.2% arch/ppc/
> >   24.6% arch/
> >    5.2% drivers/char/drm/
> >    6.3% drivers/char/
> >    4.5% drivers/gpu/drm/
> >    4.5% drivers/gpu/
> >    4.6% drivers/media/video/
> >    5.5% drivers/media/
> >    3.0% drivers/net/wireless/
> >   10.7% drivers/net/
> >    6.4% drivers/usb/misc/
> >    4.7% drivers/usb/serial/
> >   12.9% drivers/usb/
> >   51.2% drivers/
> >    4.4% firmware/
> >    3.7% fs/
> >    9.2% include/
> > 
> > where the bulk of that fs/ update is the merge of the UBI filesystem, to 
> > pick one fairly sizeable chunk outside of arch or drivers (there's omfs 
> > too, but that's tiny in comparison).
> > 
> > Other stuff? tracing. firmware loading.
> 
> That one happens to break things for me badly:
> 
> rafael@chimera:~/src/linux-2.6> make O=../build/mainline/chimera -j5
>   GEN     /home/rafael/src/build/mainline/chimera/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   Using /home/rafael/src/linux-2.6 as source for kernel
>   CALL    /home/rafael/src/linux-2.6/scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   Building modules, stage 2.
> Kernel: arch/x86/boot/bzImage is ready  (#208)
>   MODPOST 564 modules
>   IHEX2FW firmware/emi26/loader.fw
> Failed to open destination file: Permission deniedihex2fw: Convert ihex files into binary representation for use by Linux kernel
> usage: ihex2fw [<options>] <src.HEX> <dst.fw>
>        -w: wide records (16-bit length)
>        -s: sort records by address
>   IHEX2FW firmware/emi26/bitstream.fw
>   IHEX2FW firmware/emi26/firmware.fw
> Failed to open destination file: Permission deniedihex2fw: Convert ihex files into binary representation for use by Linux kernel
> usage: ihex2fw [<options>] <src.HEX> <dst.fw>
>        -w: wide records (16-bit length)
>        -s: sort records by address
> make[2]: *** [firmware/emi26/loader.fw] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[2]: *** [firmware/emi26/bitstream.fw] Error 1
> Failed to open destination file: Permission deniedihex2fw: Convert ihex files into binary representation for use by Linux kernel
> usage: ihex2fw [<options>] <src.HEX> <dst.fw>
>        -w: wide records (16-bit length)
>        -s: sort records by address
> make[2]: *** [firmware/emi26/firmware.fw] Error 1
> make[1]: *** [modules] Error 2
> make: *** [sub-make] Error 2

Actually, this happened due to some firmware files being created as root during
installations of pre-rc -git kernels from the O= directory.  So, not a real
problem, but somewhat confusing.

Thanks,
Rafael
