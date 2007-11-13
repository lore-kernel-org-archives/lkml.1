Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbXKMXIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbXKMXIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760744AbXKMXIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:08:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59925 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760838AbXKMXII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:08:08 -0500
Date: Tue, 13 Nov 2007 15:08:04 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, richard.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113230804.GA14570@us.ibm.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113201102.GK17785@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113201102.GK17785@parisc-linux.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:11:02PM -0700, Matthew Wilcox wrote:
> On Tue, Nov 13, 2007 at 10:51:22AM -0800, Greg KH wrote:
> > Ok, again, I want to see the IBM people sign off on this, after testing
> > on all of their machines, before I'll consider this, as I know the IBM
> > acpi tables are "odd".
> 
> That seems a little higher standard than patches are normally held to.
> How about the patches get sent to the appropriate people at IBM (who are
> they?) 

I be one of them. :)  I have been involved in many (but not all)
of IBM's x86 based (IBM System x) servers with hotplug capable
PCI slots.  I have mostly worked on 'acpiphp' associated issues.

> and if we haven't heard a NAK from them after a month, then they
> get applied?

I am not fundamentally opposed to this new capability but
share the same concerns that Greg and others have expressed.
So far, I have only tried the changes on one single node
system (IBM x3850) but the below NAK-worthy result supports
the idea that the changes need to be well and widely tested.

Have you possibly considered a kernel option as a kinder and
gentler way of introducing the changes?

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

====
IBM x3850
Slots 1-2: PCI-X under PCI root bridges
Slots 3-6: PCIe under transparent P2P bridges
Slot 1: PCI-X - populated
Slot 2: PCI-X - !populated
Slot 3: PCIe -  populated
Slot 4: PCIe -  !populated
Slot 5: PCIe -  !populated
Slot 6: PCIe -  populated

result is with 2.6.24-rc2 plus all 4 proposed patches
problem: acpiphp failed to register empty PCIe slots 4 and 5
====

# dmesg
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: found PCI host-bus bridge with hot-pluggable slots
acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:02:01
acpiphp: Slot [1] registered
acpiphp_glue: found PCI host-bus bridge with hot-pluggable slots
acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:06:01
acpiphp: Slot [2] registered
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:0a:00.0
acpiphp_glue: found ACPI PCI Hotplug slot 3 at PCI 0000:0b:00
acpiphp: Slot [3] registered
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:0f:00.0
acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:14:00.0
acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
acpiphp: pci_hp_register failed with error -17
acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:19:00.0
acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:1a:00
acpiphp: Slot [6] registered
acpiphp_glue: Bus 0000:1a has 1 slot
acpiphp_glue: Bus 0000:15 has 0 slots
acpiphp_glue: Bus 0000:10 has 0 slots
acpiphp_glue: Bus 0000:0b has 1 slot
acpiphp_glue: Bus 0000:06 has 1 slot
acpiphp_glue: Bus 0000:02 has 1 slot
acpiphp_glue: Total 4 slots

# find /sys/bus/pci/slots
/sys/bus/pci/slots
/sys/bus/pci/slots/1
/sys/bus/pci/slots/1/address
/sys/bus/pci/slots/1/power
/sys/bus/pci/slots/1/attention
/sys/bus/pci/slots/1/latch
/sys/bus/pci/slots/1/adapter
/sys/bus/pci/slots/2
/sys/bus/pci/slots/2/address
/sys/bus/pci/slots/2/power
/sys/bus/pci/slots/2/attention
/sys/bus/pci/slots/2/latch
/sys/bus/pci/slots/2/adapter
/sys/bus/pci/slots/3
/sys/bus/pci/slots/3/address
/sys/bus/pci/slots/3/power
/sys/bus/pci/slots/3/attention
/sys/bus/pci/slots/3/latch
/sys/bus/pci/slots/3/adapter
/sys/bus/pci/slots/4
/sys/bus/pci/slots/4/address
/sys/bus/pci/slots/5
/sys/bus/pci/slots/5/address
/sys/bus/pci/slots/6
/sys/bus/pci/slots/6/address
/sys/bus/pci/slots/6/power
/sys/bus/pci/slots/6/attention
/sys/bus/pci/slots/6/latch
/sys/bus/pci/slots/6/adapter

