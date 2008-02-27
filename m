Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYB0UsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYB0UsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYB0UsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:48:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40632 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbYB0UsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:48:06 -0500
Date: Wed, 27 Feb 2008 20:44:07 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@brodo.de>
Subject: Re: [2.6 patch] the long overdue pcmcia_ioctl.c removal
Message-ID: <20080227204407.GA10455@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Dominik Brodowski <linux@brodo.de>
References: <20080213213115.GW3383@cs181133002.pp.htv.fi> <20080218050133.23454db1.akpm@linux-foundation.org> <20080227181303.GB29269@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227181303.GB29269@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 08:13:03PM +0200, Adrian Bunk wrote:
> On Mon, Feb 18, 2008 at 05:01:33AM -0800, Andrew Morton wrote:
> > On Wed, 13 Feb 2008 23:31:15 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > pcmcia_ioctl.c was scheduled for removal in 2005, and it has a 
> > > deprecation printk() since 2005 (sic).
> > > 
> > > This patch contains the long overdue removal and the cleanups that are 
> > > now possible.
> > 
> > I've had this in -mm for ages, with a note that Dominik had a problem with
> > it.  Maybe there are subtleties here, dunno.
> 
> This removal has bells and whistles and printk() since 2005...
> 
> Dominik, what exactly is the problem why we can't remove it now?

I've objected to it in the past because one of the machines I use
every week requires the ioctls to be able to work - the rootfs is on
a CF card and it uses an initrd to work out - at run time - whether
it's supposed to be running off the CF card or some other internal
memory.

Unfortunately, the project closed down, and I didn't have a chance
(nor the bandwidth) to take a copy of the CVS, which means I've *NO*
possibility to rebuild userspace - which effectively means I can't
change it.

Therefore, removal of the PCMCIA ioctls effectively bars me from
upgrading the kernel on this platform.

There are also other desktop GUI controls which talk to the kernel
PCMCIA subsystem via ioctls - which fall into the same "I can't fix
them" category - some of which are already broken through the removal
of the PCMCIA version reporting IOCTL.  Eg, it now thinks there's
always a wireless card plugged in.

TBH I've given up trying to fight this continue "lets remove these
IOCTLs which no one uses" crap.  Obviously, _I_ use them.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
