Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYEEGnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYEEGnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYEEGnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:43:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52678 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYEEGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:43:08 -0400
Date: Mon, 5 May 2008 08:43:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-05-05 07:05, Linus Torvalds wrote:
>On Mon, 5 May 2008, Rusty Russell wrote:
>
>And I don't build initrd's etc crap, very much on purpose. I want to
>replace the kernel, nothing else, so my /etc/grub.conf file just
>replaces the distro kernel with my own, and keeps everything else
>untouched. [...] I want my own kernel, no other changes. That means
>that I run the distro initrd, which has its modules for bringing
>stuff up with distro kernels.

That's not good procedure IMO. You always want to keep a known good
(=booting) kernel, and the distro-provided one might just be that.
So it's like:
	<hack hack hack>
	make modules_install
	cp arch/x86/boot/bzImage /boot/mykernel
	cp System.map /boot/System.map-2.6.26.1
	mkinitrd -i /boot/myinitrd -k /boot/mykernel # suse, fedora might slightly different
and you can constantly replace mykernel (resp. myinitrd via mkinitrd)
without having to touch grub.conf (that is, if you keep the name
'my*' over the development period), have modules, and the right ones
at that.
