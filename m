Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYHSEsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYHSEsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYHSEsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:48:14 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:12451 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYHSEsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:48:13 -0400
Date: Tue, 19 Aug 2008 06:48:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
       David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rc2 when cross-building the kernel
Message-ID: <20080819044854.GA2276@uranus.ravnborg.org>
References: <48A63D98.3070900@lwfinger.net> <20080818193253.GA30856@uranus.ravnborg.org> <48A9FA05.9000601@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A9FA05.9000601@lwfinger.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 05:39:01PM -0500, Larry Finger wrote:
> Sam Ravnborg wrote:
> >
> >Can you try do do a "make V=1 modules_install install" and post the
> >output up to and including the first call to fixdep.
> >
> >Neither of these targets should use fixdep and I assume it is 
> >down in firmware/ but lets see.

And Larry log say it is so.

David - did you have a patch to fix this already?

[See details below]

	Sam

> 
> finger@mtech:/ide1/mtech/wireless-testing> sudo make V=1 
> modules_install install
> make -f /ide1/mtech/wireless-testing/scripts/Makefile.modinst
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/arch/x86/crypto; cp 
> arch/x86/crypto/aes-i586.ko 
> /lib/modules/2.6.27-rc2-wl/kernel/arch/x86/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/arch/x86/crypto/aes-i586.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/aead.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/aead.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/aes_generic.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/aes_generic.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/anubis.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/anubis.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/arc4.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/arc4.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/authenc.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/authenc.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/blowfish.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/blowfish.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/cast5.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/cast5.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/cast6.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/cast6.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp crypto/cbc.ko 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/cbc.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/crc32c.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/crc32c.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/crypto_blkcipher.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; 
> true /lib/modules/2.6.27-rc2-wl/kernel/crypto/crypto_blkcipher.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
> crypto/crypto_null.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/crypto/crypto_null.ko
> 
> -- snipped similar commands that were repeated --
> 
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/sound/pci/ac97; cp 
> sound/pci/ac97/snd-ac97-codec.ko 
> /lib/modules/2.6.27-rc2-wl/kernel/sound/pci/ac97 ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/sound/pci/ac97/snd-ac97-codec.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/sound/pci; cp 
> sound/pci/snd-es1938.ko /lib/modules/2.6.27-rc2-wl/kernel/sound/pci ; 
> true /lib/modules/2.6.27-rc2-wl/kernel/sound/pci/snd-es1938.ko
>   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/sound; cp 
> sound/soundcore.ko /lib/modules/2.6.27-rc2-wl/kernel/sound ; true 
> /lib/modules/2.6.27-rc2-wl/kernel/sound/soundcore.ko
> make -f /ide1/mtech/wireless-testing/scripts/Makefile.fwinst 
> obj=firmware __fw_modinst
>   gcc -Wp,-MD,firmware/.ihex2fw.d -Wall -Wstrict-prototypes -O2 
> -fomit-frame-pointer     -o firmware/ihex2fw firmware/ihex2fw.c
> /bin/sh: scripts/basic/fixdep: cannot execute binary file
> make[1]: *** [firmware/ihex2fw] Error 126
> make: *** [_modinst_post] Error 2
> 
> 
> As you suspected, it is when building firmware.
> 
> Larry
