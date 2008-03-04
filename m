Return-Path: <linux-kernel-owner+w=401wt.eu-S933978AbYCDW6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbYCDW6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761199AbYCDW6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:58:33 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:7069 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYCDW6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:58:32 -0500
Date: Tue, 4 Mar 2008 15:58:30 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080304225830.GC3694@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
	Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
	warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002938.GE21420@ldl.fc.hp.com> <20080301052542.GD19353@suse.de> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304054927.GA15566@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Sat, Mar 01, 2008 at 07:43:07AM -0700, Matthew Wilcox wrote:
> > On Fri, Feb 29, 2008 at 09:25:42PM -0800, Greg KH wrote:
> > > What is the guarantee that the names of these slots are correct

No guarantee there. We report whatever firmware tells us.

> > > and do not happen to be the same as the hotpluggable ones?

Stronger guarantee here, since both pci_slot and <foo>hp driver
will be getting the name of the slot from the same place.

> > That would be a bug -- and yes, bugs happen, and we have to deal with
> > them.
> 
> My main concern is that BIOS vendors will not fix these bugs, as no
> other OS cares/does this kind of thing today.  The ammount of bad
> information out there might be quite large, and I think this was
> confirmed by some initial testing of IBM systems, right?

We saw problems on Fujitsu machines, where they return an error
code when the _SUN method is called on a slot that exists in the
namespace but isn't actually present.

After discussing with Kenji-san about specs, we came to the
agreement that he was ok with this behavior because he had the
option to not load pci_slot on his machines.

I agree that there might be lots of buggy firmwares out there,
but we won't know for certain until we get some exposure. And I
think the upside is worth it.

Kristen suggested the linux-next tree. That sounds viable to
me...

> > > Why show this information on machines that can not do
> > > anything with these slots at all?  Will that not just
> > > confuse people?
> > 
> > Only for people who think that /sys/bus/pci/slots/ is for
> > hotpluggable slots only.  There is plenty of useful
> > information available for slots that aren't hotpluggable (eg
> > bus address, speed, width, error status).
> 
> Can the userspace tools that are using the existing directories
> thinking that only hotplug slots are there, handle
> "non-hotplug" slots showing up in this location?

Of course we shouldn't break userspace, no one wants that. But
nothing about that name (/sys/bus/pci/slots/) implies "hotplug
only", and we have no idea how big the problem might be.

Again, I'm thinking more exposure in linux-next might be a
reasonable way for us to figure out how bad (or good) the
situation might really be out there.

Thanks.

/ac

