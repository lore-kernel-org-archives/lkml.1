Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbXCFCJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbXCFCJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965740AbXCFCJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:09:07 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:52897 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736AbXCFCJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:09:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cnQO76wiQ35Cc1oCLdpD7dOocyKvZP/91sDsQyTCzzC8+uZDEDKMO/6AH7qTQCsaepwwa9Tz3BFFh+xcXPIP6dQu1n1YSdrNDtt6a9RhIqYB4vmskq3qki4Hv0E8x3F1z50Tzwein7iZQE0AgLFQv6CTaNkXpJh0snuAVGQuJBE=
Message-ID: <8bd0f97a0703051809n1762e8e3gce4ddb7af8d3882a@mail.gmail.com>
Date: Mon, 5 Mar 2007 21:09:05 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Cc: bryan.wu@analog.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703032330.50116.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172722480.5264.75.camel@roc-desktop>
	 <200703032330.50116.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Arnd Bergmann <arnd@arndb.de> wrote:
> > +#if defined(CONFIG_MTD_UCLINUX)
> > +     /* generic memory mapped MTD driver */
> > +     memory_mtd_end = memory_end;
> > +
> > +     mtd_phys = _ramstart;
> > +     mtd_size = PAGE_ALIGN(*((unsigned long *)(mtd_phys + 8)));
> > +
> > +# if defined(CONFIG_EXT2_FS) || defined(CONFIG_EXT3_FS)
> > +     if (*((unsigned short *)(mtd_phys + 0x438)) == EXT2_SUPER_MAGIC)
> > +             mtd_size =
> > +                 PAGE_ALIGN(*((unsigned long *)(mtd_phys + 0x404)) << 10);
> > +# endif
> > +
> > +# if defined(CONFIG_CRAMFS)
> > +     if (*((unsigned long *)(mtd_phys)) == CRAMFS_MAGIC)
> > +             mtd_size = PAGE_ALIGN(*((unsigned long *)(mtd_phys + 0x4)));
> > +# endif
> > +
> > +# if defined(CONFIG_ROMFS_FS)
> > +     if (((unsigned long *)mtd_phys)[0] == ROMSB_WORD0
> > +         && ((unsigned long *)mtd_phys)[1] == ROMSB_WORD1)
> > +             mtd_size =
> > +                 PAGE_ALIGN(be32_to_cpu(((unsigned long *)mtd_phys)[2]));
>
> This detection seems to me like a strange thing to do in setup_arch().
> It should be possible to do this much later, at a point where the system
> is much less fragile and e.g. printk works. It could even be moved into
> some place in the mtd code itself, since other architectures might want
> to do the same thing.

the MTD code already does this ... the difference is that the blackfin
port changes the memory layout dynamically by relocating the rootfs
from the end of its data section to the end of memory ... that's why
it's done so early in the boot process, it shrinks the memory pool
available to the kernel allocator

> > +#define TCGETS               0x5401
> > +#define TCSETS               0x5402
> > +#define TCSETSW              0x5403
> > +#define TCSETSF              0x5404
> > +#define TCGETA               0x5405
> > +#define TCSETA               0x5406
> > +#define TCSETAW              0x5407
> > +#define TCSETAF              0x5408
> > +#define TCSBRK               0x5409
> > +#define TCXONC               0x540A
> > +#define TCFLSH               0x540B
> > +#define TIOCEXCL     0x540C
> > +#define TIOCNXCL     0x540D
> > +#define TIOCSCTTY    0x540E
> > +#define TIOCGPGRP    0x540F
> > +#define TIOCSPGRP    0x5410
> > +#define TIOCOUTQ     0x5411
> > +#define TIOCSTI              0x5412
> > +#define TIOCGWINSZ   0x5413
> > +#define TIOCSWINSZ   0x5414
> > +#define TIOCMGET     0x5415
> > +#define TIOCMBIS     0x5416
> > +#define TIOCMBIC     0x5417
> > +#define TIOCMSET     0x5418
> > +#define TIOCGSOFTCAR 0x5419
> > +#define TIOCSSOFTCAR 0x541A
> > +#define FIONREAD     0x541B
> > +#define TIOCINQ              FIONREAD
> > +#define TIOCLINUX    0x541C
> > +#define TIOCCONS     0x541D
> > +#define TIOCGSERIAL  0x541E
> > +#define TIOCSSERIAL  0x541F
> > +#define TIOCPKT              0x5420
> > +#define FIONBIO              0x5421
> > +#define TIOCNOTTY    0x5422
> > +#define TIOCSETD     0x5423
> > +#define TIOCGETD     0x5424
> > +#define TCSBRKP              0x5425  /* Needed for POSIX tcsendbreak() */
> > +#define TIOCTTYGSTRUCT       0x5426  /* For debugging only */
> > +#define TIOCSBRK     0x5427  /* BSD compatibility */
> > +#define TIOCCBRK     0x5428  /* BSD compatibility */
> > +#define TIOCGSID     0x5429  /* Return the session ID of FD */
> > +#define TIOCGPTN     _IOR('T',0x30, unsigned int)    /* Get Pty Number (of pty-mux
> device) */
> > +#define TIOCSPTLCK   _IOW('T',0x31, int)     /* Lock/unlock Pty */
>
> These look like another good candidate for an asm-generic version.

yeah, most everyone has the same ioctl values for terminal cruft

> > These macros allow us to work around hardware bugs when accessing the
> > registers by simply redefining the accessor to do something more
> > complex.
>
> If there is a bug in the hardware, the workaround belongs into the
> driver. You can then still define a special inline function to
> access that particular register.

not when it's an anomaly in a register that is not driver specific
(like the VR_CTL register), or it's a peripheral that has no generic
driver [yet] (like the SPORT or PPI)
-mike
