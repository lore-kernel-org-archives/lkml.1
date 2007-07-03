Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXGCTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXGCTcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbXGCTbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:31:53 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:57459 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbXGCTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:31:52 -0400
Date: Tue, 3 Jul 2007 20:31:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: Don't miss the ARM-scsi fix.
Message-ID: <20070703193104.GA27542@flint.arm.linux.org.uk>
References: <200707031503.56561.rob@landley.net> <20070703122145.447c7d2c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703122145.447c7d2c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 12:21:45PM -0700, Andrew Morton wrote:
> On Tue, 3 Jul 2007 15:03:56 -0400
> Rob Landley <rob@landley.net> wrote:
> 
> > Just making sure this fix winds up in 2.6.23:
> 
> 2.6.22?
> 
> > http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4454/1
> > 
> > It fixes a regression that occurred between 2.6.20 and 2.6.20-rc1.  Without 
> > it, qemu-system-arm can't use emulated SCSI drives.  It wasn't in -rc7, and 
> > the attached patch Works For Me (tm).
> 
> Should have cc'ed Russell?

It's been applied and is in my tree since yesterday.  I've no idea why
Rob feels that he needs to pull patches out of the patch system.

> > diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
> > index ba58223..ca82901 100644
> > --- a/arch/arm/mach-versatile/pci.c
> > +++ b/arch/arm/mach-versatile/pci.c
> > @@ -117,7 +117,10 @@ static int versatile_read_config(struct pci_bus *bus, unsigned int devfn, int wh
> >  	} else {
> >  		switch (size) {
> >  		case 1:
> > -			v = __raw_readb(addr);
> > +			v = __raw_readl(addr);
> > +			if (where & 2) v >>= 16;
> > +			if (where & 1) v >>= 8;
> 
> Someone's enter key broke?

Probably, but I'd rather have the fix in than worry about that at this
stage.
