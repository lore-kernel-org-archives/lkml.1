Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbXKMVPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbXKMVPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760769AbXKMVPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:15:24 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:54045 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760518AbXKMVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:15:21 -0500
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=ypde5bZP6N6tFkwUmSQY/UY5U9M7qXF3nH2n0DHwN+VNxaSa/t96jzeCElU9FqH0ZTOuLSCcCtoQdKCa4HQDoZ8uouXI/OLZ+eyPTf53rd24UnB+YqtUvqzURjNyX96u;
X-IronPort-AV: E=Sophos;i="4.21,411,1188795600"; 
   d="scan'208";a="415593455"
Date: Tue, 13 Nov 2007 15:15:09 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113211509.GB19146@auslistsprd01.us.dell.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113185122.GA22536@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 10:51:22AM -0800, Greg KH wrote:
> On Tue, Nov 13, 2007 at 11:33:53AM -0700, Matthew Wilcox wrote:
> > On Tue, Nov 13, 2007 at 09:01:29AM -0800, Greg KH wrote:
> > > I'm still not sold on this idea at all.  I'm really betting that there
> > > is a lot of incorrect acpi slot information floating around in machines
> > > and odd things will show up in these slot entries.
> > 
> > Is that the end of the world?  Instead of having no information, we'll
> > end up with odd information.  If people complain, we can always
> > blacklist (indeed, won't the ACPI rolling blacklist catch the majority
> > of these machines?)
> 
> I don't think the rolling blacklist will catch this, as the rest of the
> ACPI code is "correct".
> 
> And yes, incorrect information exported by the kernel is not good at
> all, especially if a user expects it to work properly :)
> 
> > > I say this because for a long time there was no "standard" acpi entries
> > > for hotplug slots and different companies did different things.  Hence
> > > the "odd" IBM acpi hotplug implementation as one example.  If this is
> > > going to go anywhere, you need to get IBM to agree that it works
> > > properly with all their machines...
> > 
> > Not in terms of slot names.  There were various things that ACPI didn't
> > specify, like attention and latches, but the description of _SUN hasn't
> > changed.
> 
> Ok, again, I want to see the IBM people sign off on this, after testing
> on all of their machines, before I'll consider this, as I know the IBM
> acpi tables are "odd".
> 
> Also, how about Dell machines?  I know they are probably not expecting
> this information to show up and who knows if the numbering of their
> slots match up with their physical diagrams (I say this based on all of
> the eth0/eth1 "issues" with Dell machines over the years...)


The only reported _SUN problems on Dell systems were on the PE6800 and
PE6850 systems, which we've fixed with an updated BIOS several months
ago.  IIRC the values weren't always unique which kind of defeated the
purpose.

The eth0/eth1 "issues" are completely separate, with no relation to
ACPI.  That's purely a PCI tree depth-first discovery
vs. breadth-first discovery (where it indeed seems everyone except
Linux 2.6 uses and expects breadth-first).  We looked at extending
ACPI to export device naming preference, but instead extended SMBIOS
tables because we could get that change in far easier.

The other bit that looks at slot numbers is the old PCI IRQ Routing
Table, which still exists on Dell systems.

> > We should, IMO, be improving the way we tell users which device has
> > a problem.  'tulip7', 'eth4', 'pci 0000:04:1e.3' ... all the user wants
> > to know is which damn card it is so they can replace it.  And slot name
> > tells them that.
> 
> Not if the slot information is incorrect :)
> 
> That's my main concern.

Again, I've only seen this be incorrect on those two models of Dell
servers with outdated BIOS versions.

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
