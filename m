Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbYCSVh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbYCSVh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYCSUIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:08:49 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31324 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763967AbYCSUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:08:47 -0400
Date: Tue, 18 Mar 2008 19:52:06 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/3, v10] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080319015206.GE30421@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	warthog19@eaglescrag.net, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <20080319005535.GB424@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319005535.GB424@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

* Matthew Wilcox <matthew@wil.cx>:
> On Tue, Mar 18, 2008 at 03:05:39PM -0600, Alex Chiang wrote:
> > Also, v10 should fix the "pci_slot module changes the sysfs
> > name" issue that Kenji-san was seeing.
> 
> I thought we agreed that the current names are wrong, and we
> shouldn't consider this 'different name' an issue.

I did see some discussion around this, but wasn't actually sure
what we decided on. For v10, the little adjustment I made keeps
the existing userspace names for pciehp, but doesn't affect
shpchp.

[The example that Kenji-san sent out earlier showed that his
pciehp slot names changed depending on the order of module
loading between pciehp and pci_slot; his shpchp slot names did
not change.]

Injecting my thoughts into the exchange between Kenji-san and
Kristen earlier on this subject...

> > * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> * Kristen Carlson Accardi <kristen.c.accardi@intel.com>:
* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > >     Though I don't have any specific idea about this,
> > >     folliwings might be candidates.                                                           
> > >                                                                              
> > >     - Override slot names with hotplug driver's slot names                   
> > I think this should be done - if the pci slot driver detects
> > that a hotplug driver is controlling a slot, it should allow
> > that driver to set the name of the slot.                                                     
> 
> Yes, it is what I thought.  But maybe we should try unifying
> slots names first, I think.

This is the tweak I added in v10.

> > >     - Unify slot names among all hotplug drivers                             
> > I'm not sure if we can do this, since slot name might depend
> > on what spec people are implementing.                                                 
> 
> I'm not sure too. But I think we can unify the slot names using
> the combination of chassis number and slot number among the
> controllers which is based on PCI Hot-Plug spec.

I could take this approach instead, but it will definitely change
what userspace sees. I'd like to get an ACK from Kristen before
starting down this path.

Actually, my real preference would be to save it for a future
patch set, while I work on getting this one into the tree. ;)

> > >     - Stop automatic loading of ACPI PCI slot driver                         
> > I think we should definitely implement this one ^^^. 

I don't think that should be happening anyway. On my Fedora Core
8 userspace, pci_slot doesn't get loaded until I modprobe it.

Maybe Kenji-san is building it into his kernel?

/ac

