Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbXGAMTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbXGAMTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 08:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbXGAMTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 08:19:10 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:47240 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbXGAMTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 08:19:09 -0400
To: mista.tapas@gmx.net
CC: alan@lxorguk.ukuu.org.uk, bunk@stusta.de, nix@esperi.org.uk,
       galibert@pobox.com, tiwai@suse.de, kloczek@rudy.mif.pg.gda.pl,
       linux-kernel@vger.kernel.org
In-reply-to: <200707011346.52872.mista.tapas@gmx.net> (message from Florian
	Schmidt on Sun, 1 Jul 2007 13:46:52 +0200)
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <20070624200837.16e11305@the-village.bc.nu> <E1I4IoZ-0003Hm-00@dorka.pomaz.szeredi.hu> <E1I4J76-0003MW-00@dorka.pomaz.szeredi.hu> <200707011346.52872.mista.tapas@gmx.net>
Message-Id: <E1I4yMW-00078W-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 01 Jul 2007 14:17:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well, had a look at what FUSD does.  It assumes that the ioctl
> > argument is stuctured according to the command.  If all OSS ioctls are
> > like that, then fine, fuse can support it properly.
> >
> > The drawback of this is that ioctls which aren't structured properly
> > could cause weird failures due to wrong data being accessed by the
> > poor unknowing kernel.
> 
> Included with the docs there's a list of the OSS ioctls. I don't understand 
> enough of the problem to judge whether they are suitable to be handled by 
> FUSE:
> 
> http://manuals.opensound.com/developer/ioctl.html [version 4]
> http://www.4front-tech.com/pguide/oss.pdf [version 3]
> 
> I don't know which API version is supposed to be supported though.

Thanks, but these docs are about what the ioctls do, and I'm totally
uninterested in that.  What I'm interested is how the ioctl data is
_structured_.

OK, had a look at <linux/soundcard.h>, it does define a data
structuring based on the ioctl numbers, and it's just slightly
different from the structuring defined by <asm-generic/ioctl.h>.  Oh,
the beauty of the ioctls.

So answering my own question: no, it's not sanely possible to support
ioctls through fuse without userspace hacks or significant effort.

A possibly acceptable option is to add a plugin mechanism, whereby
people could write small ioctl interpreter kernel modules for their
specific needs (such as parsing OSS ioctls), which would
serialize/deserialize any type of ioctl input/output making them
suitable for transfering between the kernel and the userspace
filesystem.

Another, much more complex option is to design a generic ioctl data
interpreter language, and let the filesystem upload their ioctl
parsers into the kernel.

Miklos
