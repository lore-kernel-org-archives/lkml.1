Return-Path: <linux-kernel-owner+w=401wt.eu-S1750832AbXBKVKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750832AbXBKVKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXBKVKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:10:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40374 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750832AbXBKVKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:10:53 -0500
Date: Sun, 11 Feb 2007 22:10:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Daniel Barkalow <barkalow@iabervon.org>, nigel@nigel.suspend2.net,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, pm list <linux-pm@lists.osdl.org>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Message-ID: <20070211211038.GD15445@elf.ucw.cz>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702101130.44471.rjw@sisk.pl> <Pine.LNX.4.64.0702101231281.20138@iabervon.org> <200702102050.28218.rjw@sisk.pl> <20070211065404.GA943@1wt.eu> <20070211121339.GB4204@srcf.ucam.org> <20070211130943.GA1868@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211130943.GA1868@1wt.eu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > instead of modifying all drivers to explicitly state that they don't support
> > > it, we should start with a test of the NULL pointer for .suspend which should
> > > mean exactly the same without modifying the drivers. I find it obvious that
> > > a driver which does provide a suspend function will not support it. And if
> > > some drivers (eg /dev/null) can support it anyway, it's better to change
> > > *those* drivers to explicitly mark them as compatible.
> > 
> > No, that doesn't work. In the absence of suspend/resume methods, the PCI 
> > layer will implement basic PM itself. In some cases, this works. In 
> > others, it doesn't. There's no way to automatically determine which is 
> > which without modifying the drivers.
> 
> Then change the PCI layer to do the basic PM only for known compatible
> drivers, and modify only the known-compatible drivers to mark them
> explicitly compatible. IMHO, it generally is a bad idea to require that
> any driver explicitly states what it *does not* support. It's the reason
> why users encounter problem on new features with old drivers. For instance,
> do you know if the old ISA NE2000 driver breaks suspend ? I don't know,
> but I would at least expect it not to support it by default. It's best
> to announce what *is* supported and consider everything unimplemented
> otherwise explicitly stated.

Actually, ne2k driver is okay. ne2k cards are notoriously buggy, so it
responds with "****, that damn card has just locked up again, lets
reset it". Ok, it takes timeout to realize card is "locked up",
so it could be improved...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
