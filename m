Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbZJ0IeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbZJ0IeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbZJ0IeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:34:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbZJ0IeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:34:16 -0400
Date: Tue, 27 Oct 2009 09:34:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091027083419.GU10727@kernel.dk>
References: <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <20091027024841.GA30509@ldl.fc.hp.com> <20091027082635.GS10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027082635.GS10727@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27 2009, Jens Axboe wrote:
> On Mon, Oct 26 2009, Alex Chiang wrote:
> > * Jens Axboe <jens.axboe@oracle.com>:
> > > > > acpiphp: enable_slot - physical_slot = 1
> > > > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > > > acpiphp: enable_slot - physical_slot = 2
> > > > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > > > acpiphp: enable_slot - physical_slot = 6
> > > > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > > > acpiphp: enable_slot - physical_slot = 7
> > > > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > > 
> > > > Hm, so for some reason, firmware on your machine is telling us
> > > > that it doesn't think cards are present and/or enabled.
> > > > 
> > > > Unfortunately, I don't know why your firmware would be saying
> > > > that. We could add some more debug printks to see what firmware
> > > > thinks about your system... Or we could just wait and see what
> > > > happens after you get your hardware replaced.
> > 
> > Let's try and find out why firmware is telling us that we didn't
> > get ACPI_STA_ALL.
> > 
> > Can you please apply this debug patch and send the output? Again,
> > please modprobe with debug=1.
> 
> acpiphp: enable_slot - physical_slot = 1
> power_on_slot
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
> get_slot_status
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL

Since this is a new board and BIOS, below is the info from loading
acpiphp with debug enabled and acpi debug enabled.

acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:05.0
acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:08:00
get_slot_status
get_slot_status
acpiphp: Slot [1] registered
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:07.0
acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:0b:00
get_slot_status
get_slot_status
acpiphp: Slot [2] registered
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:07.0
acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:84:00
get_slot_status
get_slot_status
acpiphp: Slot [6] registered
acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:80:09.0
acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:87:00
get_slot_status
get_slot_status
acpiphp: Slot [7] registered
acpiphp_glue: Bus 0000:87 has 1 slot
acpiphp_glue: Bus 0000:84 has 1 slot
acpiphp_glue: Bus 0000:0b has 1 slot
acpiphp_glue: Bus 0000:08 has 1 slot
acpiphp_glue: Total 4 slots
acpiphp: Slot [1] unregistered
acpiphp: release_slot - physical_slot = 1
acpiphp: Slot [2] unregistered
acpiphp: release_slot - physical_slot = 2
acpiphp: Slot [6] unregistered
acpiphp: release_slot - physical_slot = 6
acpiphp: Slot [7] unregistered
acpiphp: release_slot - physical_slot = 7

-- 
Jens Axboe

