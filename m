Return-Path: <linux-kernel-owner+w=401wt.eu-S934067AbXCTU2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbXCTU2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934068AbXCTU2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:28:42 -0400
Received: from mail.suse.de ([195.135.220.2]:58009 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934067AbXCTU2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:28:42 -0400
Date: Tue, 20 Mar 2007 13:26:52 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Yeisley <dan.yeisley@unisys.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] I/O space boot parameter
Message-ID: <20070320202652.GA15439@suse.de>
References: <1174407505.23830.14.camel@localhost.localdomain> <20070320180020.GB21470@suse.de> <1174411538.23830.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174411538.23830.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 01:25:38PM -0400, Daniel Yeisley wrote:
> On Tue, 2007-03-20 at 11:00 -0700, Greg KH wrote:
> > On Tue, Mar 20, 2007 at 12:18:24PM -0400, Daniel Yeisley wrote:
> > > It has been mentioned before that large systems with a lot of PCI buses
> > > have issues with the 64k I/O space limit.  The ES7000 has a BIOS option
> > > to either assign I/O space to all adapters, or only to those that need
> > > it.  A list of supported adapters that don't need it is kept in the
> > > BIOS.  When this option is used, the kernel sees the BARs on the
> > > adapters and still tries to assign I/O space (until it runs out).  I've
> > > written a patch to implement a boot parameter that tells the kernel not
> > > to assign I/O space if the BIOS hasn't.  
> > 
> > How prelevant are machines like this?  And why are the BARs on these
> > devices wrong?
> > 
> I don't have any sales numbers, but I can tell you that our current
> systems can have up to 64 PCI buses.  
> 
> I've been working with Emulex cards, and my understanding is that the
> BARs on the devices aren't wrong, but we can't allocate 4k of I/O space
> for each one.  So we maintain a list in the BIOS of devices that don't
> actually need I/O space and then don't assign it.  I've tested an a
> x86_64 system with 20+ adapters and saw all the disks attached without
> any problems.

Ah.  Others are working on providing a fix for this too, but it is being
done in the drivers themselves, not in the pci core.  Look in the
linux-pci mailing list archives for those patches (I don't think they
every went into mainline for some reason, but I might be wrong...)

I suggest you work with those developers, as they have the same issue
that you are trying to solve here.

thanks,

greg k-h
