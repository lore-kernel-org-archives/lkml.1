Return-Path: <linux-kernel-owner+w=401wt.eu-S1762508AbYGOTUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762508AbYGOTUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbYGOTUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:20:30 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51111 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbYGOTU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:20:29 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <200807151757.10626.elendil@planet.nl>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:20:37 +0200
Message-Id: <1216149637.27242.65.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

> > On Mon, 14 Jul 2008, Jeff Garzik wrote:
> >> IMO the newly added /inability/ to build firmware into kernel modules
> >> is a clear regression.
> > 
> > IMO you're being stupid.
> > 
> > How about explainign why it makes any difference what-so-ever?
> > 
> > If you can load the module, you can load the firmware. Claiming anything
> > else is just _stupid_.
> 
> Sure, in theory it's that simple. Here's a concrete example that shows how 
> things are harder in practice.
> 
> I use the 'make deb-pkg' target (from scripts/package) to build my Debian 
> kernel packages from git. So that needs to be adapted to include
> /lib/firmware. No real problem so far.
> 
> So then I build 2.6.27-rc1 and install it. Great.
> 
> You release 2.6.27-rc2 and I build it. Ouch! It fails to install, at least 
> if I want to install it _alongside_ 2.6.27-rc1 or other kernels (which I 
> do!). Why does it fail? Because dpkg's package management does not allow 
> one package to overwrite files already "owned" by another package.
> 
> So, how is this solved by Debian for already existing firmware packages? 
> Basically by making a separate package for each firmware file (or 
> driver). This works because there are not too many of them, but having a 
> huge number of tiny packages is a nightmare by itself.
> 
> But anyway, the dep-pkg target will have to be made smarter than it is now 
> if it's to deal with this [1]. And at least currently it is broken.
> 
> If I were able to compile firmware into the modules, the problem would be 
> solved in one go.
> 
> I don't know how the Debian kernel team plans to deal with this for distro 
> kernel packages. They probably _do_ want to keep them separate [2]. Maybe 
> by grouping firmware for really common drivers into 
> firmware-basic-drivers or something along those lines.
> 
> Cheers,
> FJP
> 
> [1] Only quick solution I see is to have it install the firmware in a 
> versioned directory and have the postinst copy things from there to
> /lib/firmware.

using /lib/firmware/`uname -r`/ is actually not a bad idea. You only
have to fix udev to actually include this in the list of directories to
look for firmware files. Also Ubuntu is already doing this.

Regards

Marcel


