Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbXKMVdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbXKMVdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763047AbXKMVcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:32:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51604 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763017AbXKMVcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:32:45 -0500
Date: Tue, 13 Nov 2007 13:30:49 -0800
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113213049.GA4194@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113203645.GB22812@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113203645.GB22812@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:36:45PM -0700, Alex Chiang wrote:
> * Greg KH <greg@kroah.com>:
> > 
> > Ok, again, I want to see the IBM people sign off on this, after
> > testing on all of their machines, before I'll consider this, as
> > I know the IBM acpi tables are "odd".
> 
> Who would be a good contact at IBM to get some eyes / machine
> time on this?

The current 2.4 pci hotplug maintainer?  :)

> > Also, how about Dell machines?  I know they are probably not
> > expecting this information to show up and who knows if the
> > numbering of their slots match up with their physical diagrams 
> 
> Who would be a good contact at Dell for the same?

Matt has already spoken up for this...

> I don't have as much experience with oddball firmware from
> various vendors as others on this list, but given the rather
> stable definition of _SUN in the ACPI spec, I'd be surprised to
> see vendors abusing that method. [I fully accept the possibility
> that I'm just naive ;)]
> 
> More likely, a vendor will do what the HP Proliant folks did,
> that being simply omitting a _SUN method altogether.
> 
> One more thought on that -- at *worst* my patch series will do no
> worse than the status quo of what the acpiphp module is doing
> today. That module walks through the namespace looking for _SUN
> methods, and when it finds them, it creates an entry in exactly
> the same spot (/sys/bus/pci/slots/N) that my patch series does.

The acpiphp module is not loaded on zillions of non-pci-hotplug
machines...

> What this series adds beyond acpiphp is adding entries for slots
> that aren't hotpluggable.

How are you going to ensure that the userspace programs that use those
sysfs files are not going to break into tiny pieces now that you have
extended this to show all pci slots?

> > IBM sells a program that does this for server rooms.  It's
> > probably part of some Tivoli package somewhere, sorry I don't
> > remember the name.  I did see it working many years ago and it
> > required no kernel changes at all to work properly.
> 
> Like I said in an earlier email, HP ia64 systems will require a
> kernel change to get this information. Whether it comes via a
> generic ACPI access layer like dev_acpi, or something like this
> patch series, the kernel will still get touched.

And like I said, I'm pretty sure you don't need to touch the kernel
today as there are people doing this just fine from userspace without
any kernel changes needed :)

thanks,

greg k-h
