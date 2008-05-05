Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYEEQCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYEEQCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYEEQBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:01:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42485 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYEEQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:01:54 -0400
Date: Mon, 5 May 2008 18:01:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Dave Jones <davej@codemonkey.org.uk>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <20080505153230.GA25704@codemonkey.org.uk>
Message-ID: <alpine.LNX.1.10.0805051755460.11757@fbirervta.pbzchgretzou.qr>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org> <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr> <20080505153230.GA25704@codemonkey.org.uk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 2008-05-05 17:32, Dave Jones wrote:
>On Mon, May 05, 2008 at 08:43:06AM +0200, Jan Engelhardt wrote:
> 
> > So it's like:
> > 	<hack hack hack>
> > 	make modules_install
> > 	cp arch/x86/boot/bzImage /boot/mykernel
> > 	cp System.map /boot/System.map-2.6.26.1
> > 	mkinitrd -i /boot/myinitrd -k /boot/mykernel # suse, fedora might slightly different
>
>For Fedora (and many other distros), you can replace the last three 
>lines with 'make install'

I don't trust that command. It might edit grub.conf in a way 
that somehow impacts the regular workflow. (Like, overwriting an old 
image, or creating oodles of entries in grub.conf.)
And say I had both lilo and grub installed (on the filesystem), with 
grub in the bootloader; I'd fear that make install might run lilo and 
trash grub in the MBR. No thanks, too much clouds. Also, it can't 
possibly know how to call mkinitrd, because every distro has its own 
stupid required flags (SUSE: requires none and tries to be smart, 
though it will be thankful if you pass it -i and -k, whereas on Fedora 
you need to specify the version, sigh.)

>It'll do everything. Construct the initrd. Install it & the vmlinuz, 
>point grub.conf at it. etc.
