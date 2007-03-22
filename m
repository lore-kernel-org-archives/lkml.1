Return-Path: <linux-kernel-owner+w=401wt.eu-S934114AbXCVQlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114AbXCVQlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934116AbXCVQlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:41:44 -0400
Received: from usea-naimss1.unisys.com ([192.61.61.103]:4445 "EHLO
	usea-naimss1.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114AbXCVQln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:41:43 -0400
Subject: Re: [PATCH] I/O space boot parameter
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20070321235759.GB30283@suse.de>
References: <1174407505.23830.14.camel@localhost.localdomain>
	 <20070320180020.GB21470@suse.de>
	 <1174411538.23830.28.camel@localhost.localdomain>
	 <20070320202652.GA15439@suse.de>
	 <1174484272.6299.24.camel@localhost.localdomain>
	 <20070321235759.GB30283@suse.de>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 11:08:57 -0400
Message-Id: <1174576138.22379.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2007 16:41:37.0746 (UTC) FILETIME=[F5C84B20:01C76CA0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 16:57 -0700, Greg KH wrote:
> On Wed, Mar 21, 2007 at 09:37:52AM -0400, Daniel Yeisley wrote:
> > On Tue, 2007-03-20 at 13:26 -0700, Greg KH wrote:
> > > On Tue, Mar 20, 2007 at 01:25:38PM -0400, Daniel Yeisley wrote:
> > > > On Tue, 2007-03-20 at 11:00 -0700, Greg KH wrote:
> > > > > On Tue, Mar 20, 2007 at 12:18:24PM -0400, Daniel Yeisley wrote:
> > > > > > It has been mentioned before that large systems with a lot of PCI buses
> > > > > > have issues with the 64k I/O space limit.  The ES7000 has a BIOS option
> > > > > > to either assign I/O space to all adapters, or only to those that need
> > > > > > it.  A list of supported adapters that don't need it is kept in the
> > > > > > BIOS.  When this option is used, the kernel sees the BARs on the
> > > > > > adapters and still tries to assign I/O space (until it runs out).  I've
> > > > > > written a patch to implement a boot parameter that tells the kernel not
> > > > > > to assign I/O space if the BIOS hasn't.  
> > > > > 
> > > > > How prelevant are machines like this?  And why are the BARs on these
> > > > > devices wrong?
> > > > > 
> > > > I don't have any sales numbers, but I can tell you that our current
> > > > systems can have up to 64 PCI buses.  
> > > > 
> > > > I've been working with Emulex cards, and my understanding is that the
> > > > BARs on the devices aren't wrong, but we can't allocate 4k of I/O space
> > > > for each one.  So we maintain a list in the BIOS of devices that don't
> > > > actually need I/O space and then don't assign it.  I've tested an a
> > > > x86_64 system with 20+ adapters and saw all the disks attached without
> > > > any problems.
> > > 
> > > Ah.  Others are working on providing a fix for this too, but it is being
> > > done in the drivers themselves, not in the pci core.  Look in the
> > > linux-pci mailing list archives for those patches (I don't think they
> > > every went into mainline for some reason, but I might be wrong...)
> > > 
> > > I suggest you work with those developers, as they have the same issue
> > > that you are trying to solve here.
> > > 
> > 
> > I have seen some patches that make the drivers I/O port free here:
> > http://lkml.org/lkml/2006/2/26/261
> 
> Ah, yes, those are the ones.
> 
> > I checked and they still aren't in the mainline.  
> 
> Poke the developer to get them there :)
> 
> > I don't know that it matters though because I see all the disks attached
> > to the system regardless of whether or not the adapters get I/O space.
> > The real issue I have is with all the error messages I get at boot.  I
> > see 40+ messages that say "PCI: Failed to allocate I/O
> > resource..." (from setup-res.c) when the kernel tries to allocate the
> > I/O space and can't.  The modules load fine.  I see all the disks just
> > fine.  But that many error messages tends to raise concerns and causes
> > support calls from customers.
> 
> If this isn't an issue for functionality, why not fix your BIOS then?

I'm not sure what there is to fix in the BIOS.  It can't assign more
than 64k of I/O space any more than the kernel can.  

> 
> And doesn't the above linked patch set also solve your issue with the
> noise in the syslog?
> 

I did try the patches and the modules load and don't request I/O space,
although I only see 17 of 29 disks (I'll have to look into that more).
I still get the "Failed to allocate I/O..." messages (long before the
modules are loaded).  

> thanks,
> 
> greg k-h

