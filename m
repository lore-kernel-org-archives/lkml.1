Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbXKMSwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbXKMSwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762958AbXKMSvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:51:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39454 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762953AbXKMSvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:51:48 -0500
Date: Tue, 13 Nov 2007 10:51:22 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alex Chiang <achiang@hp.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113185122.GA22536@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113183353.GE17785@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 11:33:53AM -0700, Matthew Wilcox wrote:
> On Tue, Nov 13, 2007 at 09:01:29AM -0800, Greg KH wrote:
> > I'm still not sold on this idea at all.  I'm really betting that there
> > is a lot of incorrect acpi slot information floating around in machines
> > and odd things will show up in these slot entries.
> 
> Is that the end of the world?  Instead of having no information, we'll
> end up with odd information.  If people complain, we can always
> blacklist (indeed, won't the ACPI rolling blacklist catch the majority
> of these machines?)

I don't think the rolling blacklist will catch this, as the rest of the
ACPI code is "correct".

And yes, incorrect information exported by the kernel is not good at
all, especially if a user expects it to work properly :)

> > I say this because for a long time there was no "standard" acpi entries
> > for hotplug slots and different companies did different things.  Hence
> > the "odd" IBM acpi hotplug implementation as one example.  If this is
> > going to go anywhere, you need to get IBM to agree that it works
> > properly with all their machines...
> 
> Not in terms of slot names.  There were various things that ACPI didn't
> specify, like attention and latches, but the description of _SUN hasn't
> changed.

Ok, again, I want to see the IBM people sign off on this, after testing
on all of their machines, before I'll consider this, as I know the IBM
acpi tables are "odd".

Also, how about Dell machines?  I know they are probably not expecting
this information to show up and who knows if the numbering of their
slots match up with their physical diagrams (I say this based on all of
the eth0/eth1 "issues" with Dell machines over the years...)

> > Also, some companies already provide userspace tools to get all of this
> > information about the different slots in a system and what is where,
> > from userspace, no kernel changes are needed.  So, why add all this
> > extra complexity to the kernel if it is not needed?
> 
> Do you have any examples of this?

IBM sells a program that does this for server rooms.  It's probably part
of some Tivoli package somewhere, sorry I don't remember the name.  I
did see it working many years ago and it required no kernel changes at
all to work properly.

> We should, IMO, be improving the way we tell users which device has
> a problem.  'tulip7', 'eth4', 'pci 0000:04:1e.3' ... all the user wants
> to know is which damn card it is so they can replace it.  And slot name
> tells them that.

Not if the slot information is incorrect :)

That's my main concern.

thanks,

greg k-h
