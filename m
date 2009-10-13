Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbZJMI3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbZJMI3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbZJMI3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:29:42 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37352 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188AbZJMI3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:29:40 -0400
Date: Tue, 13 Oct 2009 10:29:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091013082903.GQ9228@kernel.dk>
References: <20091012120620.GG9228@kernel.dk> <20091012145254.GA1517@kroah.com> <20091012145700.GJ9228@kernel.dk> <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012214854.GA14102@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12 2009, Alex Chiang wrote:
> > >>> On Mon, Oct 12, 2009 at 02:06:20PM +0200, Jens Axboe wrote:
> > >>>> I'm trying to get pci-express hotplug working in a box here. I don't
> > >>>> really care about the hotplug aspect, I just want the darn pci-e slots
> > >>>> that are designated hotplug slots to actually WORK. When I load pciehp,
> > >>>> I get:
> > >>>>
> > >>>> Firmware did not grant requested _OSC control
> > >>>> Firmware did not grant requested _OSC control
> > >>>> Firmware did not grant requested _OSC control
> > >>>> Firmware did not grant requested _OSC control
> 
> This isn't just a benign message. It means the OS asked to take
> over control of the slots and firmware really did say, "nope,
> sorry".
> 
> Which means that this:
> 
> > On Mon, Oct 12 2009, Mark Lord wrote:
> > > Tried this yet:
> > >
> > >   options pciehp pciehp_force=1
> 
> Is generally a bad idea.
> 
> Don't do it unless you really know your platform well.

Since I had nothing to lose, I tried it. This is what it prints:

Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
pciehp 0000:00:05.0:pcie04: Bypassing BIOS check for pciehp use on 0000:00:05.0
pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
pciehp 0000:00:05.0:pcie04: Power fault on Slot(1)
pciehp 0000:00:05.0:pcie04: Power fault bit 0 set

and modprobe is continually in msleep() afterwards.

> > >> On Mon, Oct 12 2009, Greg KH wrote:
> > >>> Can you try the acpiphp driver instead?  That's usually the
> > >>> driver you want to use for "modern" systems (i.e. anything
> > >>> made in the past 5 years.)
> > >>
> > >> I should have mentioned that I tried that too. It doesn't
> > >> complain, but I don't see my cards anywhere afterwards. I'm
> > >> a hotplug newbie, do I need to do anything else?
> 
> Can you modprobe acpiphp with debug=1? And send the output?

acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
acpiphp: Slot [1] registered
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
acpiphp: Slot [2] registered
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
acpiphp: Slot [6] registered
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
acpiphp: Slot [7] registered
acpiphp_glue: Bus 0000:87 has 1 slot
acpiphp_glue: Bus 0000:84 has 1 slot
acpiphp_glue: Bus 0000:0b has 1 slot
acpiphp_glue: Bus 0000:08 has 1 slot
acpiphp_glue: Total 4 slots

-- 
Jens Axboe

