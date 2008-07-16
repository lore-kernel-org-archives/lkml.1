Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbYGPBET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbYGPBET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYGPBEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:04:10 -0400
Received: from mercury.sdinet.de ([193.103.161.30]:43006 "EHLO
	mercury.sdinet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYGPBEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:04:09 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2008 21:04:09 EDT
Date: Wed, 16 Jul 2008 02:55:32 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <1216159959.26991.48.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.1.10.0807160241060.21568@mercury.sdinet.de>
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>  <487C585C.2060002@garzik.org>  <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>  <487CD7FE.9010209@garzik.org>  <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
  <487CDEC0.3090004@garzik.org>  <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>  <487CEA73.9000408@garzik.org>  <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>  <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu> 
 <487CF70C.1030309@garzik.org>  <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>  <487D1327.7090805@garzik.org>  <alpine.LFD.1.10.0807151420550.2867@woody.linux-foundation.org>  <487D1925.50008@garzik.org>
 <1216159959.26991.48.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, David Woodhouse wrote:

> On Tue, 2008-07-15 at 17:39 -0400, Jeff Garzik wrote:
> > 
> > 'make modules_install && make install' will
> >         * install modules in /lib
> >         * install firmware in /lib      [2.6.27 only]
> >         * install kernel
> >         * update grub
> >         * rebuild initrd
> > 
> > Do this, under both 2.6.26 and 2.6.27.
> > 
> > 2.6.26 will put a working driver into initrd.
> > 
> > 2.6.27 will put a dead driver into initrd (because no firmware got 
> > copied into initrd image).
> 
> I believe your claim is untrue. It uses the distribution's tool to
> create the initrd, doesn't it? And those tools _do_ handle the
> MODULE_FIRMWARE() tags and pull in appropriate firmware. They've had to
> get that right for _years_ already.

Something from the non-development world:

At least the initramfs-tools (which contains mkinitrd) of Debian Etch do 
not do this (the current testing/development version Lenny does) - no 
firmware support in the initrd at all - and not needed for booting until 
now.
(It has /lib/firmware support after the initrd for the not-so-important
stuff like usb/sound/video/wireless)

Yes, it may be nearly ancient by now, but for servers it contains all we 
need, and most certainly would not want to use something that changes and 
needs checking/hand-fixing every month - I expect this version to be still 
in use a year from now, then just gradually being updated to the next 
debian version.

Currently we use 2.6.24, and I expect to use some newer kernel to support 
newer replacement hardware before all installs are upgraded. So having the 
firmware-inside-module support would be a help for us when modules are 
starting to be needed for disk or network access, keeping from the need to 
try backporting huge initrd/make-kpkg changes.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around
it. (John Gilmore on http://www.cygnus.com/~gnu/)
