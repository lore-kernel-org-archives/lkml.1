Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbXKMVdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbXKMVdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763262AbXKMVdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:33:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51623 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763255AbXKMVdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:33:01 -0500
Date: Tue, 13 Nov 2007 13:32:19 -0800
From: Greg KH <greg@kroah.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113213219.GB4194@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113211509.GB19146@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113211509.GB19146@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 03:15:09PM -0600, Matt Domsch wrote:
> On Tue, Nov 13, 2007 at 10:51:22AM -0800, Greg KH wrote:
> > On Tue, Nov 13, 2007 at 11:33:53AM -0700, Matthew Wilcox wrote:
> > > On Tue, Nov 13, 2007 at 09:01:29AM -0800, Greg KH wrote:
> > > > I'm still not sold on this idea at all.  I'm really betting that there
> > > > is a lot of incorrect acpi slot information floating around in machines
> > > > and odd things will show up in these slot entries.
> > > 
> > > Is that the end of the world?  Instead of having no information, we'll
> > > end up with odd information.  If people complain, we can always
> > > blacklist (indeed, won't the ACPI rolling blacklist catch the majority
> > > of these machines?)
> > 
> > I don't think the rolling blacklist will catch this, as the rest of the
> > ACPI code is "correct".
> > 
> > And yes, incorrect information exported by the kernel is not good at
> > all, especially if a user expects it to work properly :)
> > 
> > > > I say this because for a long time there was no "standard" acpi entries
> > > > for hotplug slots and different companies did different things.  Hence
> > > > the "odd" IBM acpi hotplug implementation as one example.  If this is
> > > > going to go anywhere, you need to get IBM to agree that it works
> > > > properly with all their machines...
> > > 
> > > Not in terms of slot names.  There were various things that ACPI didn't
> > > specify, like attention and latches, but the description of _SUN hasn't
> > > changed.
> > 
> > Ok, again, I want to see the IBM people sign off on this, after testing
> > on all of their machines, before I'll consider this, as I know the IBM
> > acpi tables are "odd".
> > 
> > Also, how about Dell machines?  I know they are probably not expecting
> > this information to show up and who knows if the numbering of their
> > slots match up with their physical diagrams (I say this based on all of
> > the eth0/eth1 "issues" with Dell machines over the years...)
> 
> 
> The only reported _SUN problems on Dell systems were on the PE6800 and
> PE6850 systems, which we've fixed with an updated BIOS several months
> ago.  IIRC the values weren't always unique which kind of defeated the
> purpose.

Heh, I can imagine :)

> The eth0/eth1 "issues" are completely separate, with no relation to
> ACPI.  That's purely a PCI tree depth-first discovery
> vs. breadth-first discovery (where it indeed seems everyone except
> Linux 2.6 uses and expects breadth-first).  We looked at extending
> ACPI to export device naming preference, but instead extended SMBIOS
> tables because we could get that change in far easier.

I know they are different, I was using that as an example of trying to
match up physical descriptions on a machine with the internal kernel
representation.  It isn't always easy and lots of times things go wrong,
if for no other reason than no one is checking these things.

thanks,

greg k-h
