Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbXJWQLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbXJWQLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXJWQLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:11:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbXJWQLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:11:07 -0400
Date: Tue, 23 Oct 2007 09:10:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] lguest: paravirt boot code
In-Reply-To: <200710231603.21620.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.0.999.0710230903330.30120@woody.linux-foundation.org>
References: <200710221237.14542.rusty@rustcorp.com.au>
 <alpine.LFD.0.999.0710221927131.30120@woody.linux-foundation.org>
 <200710231603.21620.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Oct 2007, Rusty Russell wrote:
>
> Well, with that out the way, and some scatterlist fixups, please pull from
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest.git

Ok. However, please include a proper diffstat. And by proper, I mean:

	git diff -M --stat --summary

because right now your diffstat doesn't contain the final "total number of 
lines added/removed" (which is the easiest way for me to see that there 
isn't anything strange in there), and your diffstat doesn't do renames, so 
renames look like delete/create pairs. For example, you had:

>  arch/x86/lguest/boot.c                | 1070 ++++++++++++++++++++++
>  drivers/lguest/lguest.c               | 1108 ----------------------

but in reality it was not at all thousands of lines changed, but instead a 
rename with much smaller changes:

 drivers/lguest/lguest.c => arch/x86/lguest/boot.c  |  102 +-

which is a lot more readable and tells me much more about what is going 
on.

And at the end, I really do want to see the details like this:

	 70 files changed, 4822 insertions(+), 4401 deletions(-)
	 create mode 100644 arch/x86/lguest/Kconfig
	 create mode 100644 arch/x86/lguest/Makefile
	 rename drivers/lguest/lguest.c => arch/x86/lguest/boot.c (93%)
	 rename drivers/lguest/lguest_asm.S => arch/x86/lguest/i386_head.S (73%)
	 delete mode 100644 drivers/block/lguest_blk.c
	 create mode 100644 drivers/block/virtio_blk.c
	 delete mode 100644 drivers/char/hvc_lguest.c
	 create mode 100644 drivers/char/virtio_console.c
	 delete mode 100644 drivers/lguest/io.c
	 delete mode 100644 drivers/lguest/lguest_bus.c
	 create mode 100644 drivers/lguest/lguest_device.c
	 create mode 100644 drivers/lguest/x86/core.c
	 rename drivers/lguest/{switcher.S => x86/switcher_32.S} (99%)
	 delete mode 100644 drivers/net/lguest_net.c
	 create mode 100644 drivers/net/virtio_net.c
	 create mode 100644 drivers/virtio/Kconfig
	 create mode 100644 drivers/virtio/Makefile
	 create mode 100644 drivers/virtio/config.c
	 create mode 100644 drivers/virtio/virtio.c
	 create mode 100644 drivers/virtio/virtio_ring.c
	 create mode 100644 include/asm-x86/lguest.h
	 create mode 100644 include/asm-x86/lguest_hcall.h
	 delete mode 100644 include/linux/lguest_bus.h
	 create mode 100644 include/linux/virtio.h
	 create mode 100644 include/linux/virtio_blk.h
	 create mode 100644 include/linux/virtio_config.h
	 create mode 100644 include/linux/virtio_console.h
	 create mode 100644 include/linux/virtio_net.h
	 create mode 100644 include/linux/virtio_ring.h

which again gives a nice overview of what the heck is actually going on 
here. All of which you get for free if you use the above git command line.

Anyway, pulled. But just for future reference,

		Linus
