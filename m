Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbZBZDqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbZBZDqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZBZDq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:46:29 -0500
Received: from smtp5.Stanford.EDU ([171.67.219.85]:41201 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbZBZDq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:46:27 -0500
Subject: Re: [Announce] 2.6.29-rc6-rt3 (was 2.6.29-rc6-rt2)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: nando@ccrma.Stanford.EDU, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tracey Hytry <shakti@bayarea.net>
In-Reply-To: <1235595160.9252.49.camel@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
	 <1235513895.3816.11.camel@localhost.localdomain>
	 <1235595160.9252.49.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 19:45:22 -0800
Message-Id: <1235619922.31774.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 12:52 -0800, Fernando Lopez-Lezcano wrote:
> On Tue, 2009-02-24 at 14:18 -0800, Fernando Lopez-Lezcano wrote:
> > On Tue, 2009-02-24 at 17:30 +0100, Thomas Gleixner wrote:
> > > On Tue, 24 Feb 2009, Thomas Gleixner wrote:
> > > > >  [<c0440ef1>] internal_add_timer+0x88/0x8c
> > > > 
> > > > Can you try to enable the following config options:
> > > > 
> > > > CONFIG_DEBUG_OBJECTS
> > > > CONFIG_DEBUG_OBJECTS_FREE
> > > > CONFIG_DEBUG_OBJECTS_TIMERS
> > > > CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT
> > > 
> > > Don't bother. Just noticed that this is nf_conntrack context. Working
> > > on that right now.
> > 
> > I'm running rc6-rt3 and that problem seem to be gone (uptime of 2.5
> > hours in my desktop, 1.33 hours on my laptop, both running FC9 with a
> > 2.6.29 version of the Planet CCRMA rt kernel). So far so good!
> 
> I see this when going through a suspend/wakeup cycle on my laptop (but
> no side effects I can see):
> 
> BUG: sleeping function called from invalid context at
> kernel/rtmutex.c:683
> in_atomic(): 0, irqs_disabled(): 1, pid: 8829, name: pm-suspend
> Pid: 8829, comm: pm-suspend Not tainted

One of my Planet CCRMA users tried the rc6-rt3 kernel and...
Traceys says:

> My only problem was that I couldn't compile the rpm-fusion/nvidia
> drivers so I had to use fc9's "nv" xorg drivers which still don't work
> properly with an SLI vidio system(I only use one card).  As is the
> usual I had to be very careful not to crash the X system, but I
> managed to get some good results and some kernel debug info from a
> "non-tainted" kernel.  The "warning" only happens once at boot.  I'm
> going to paste part of dmesg below.
> 
> If you could try to put together the same kernel for fc9, that would
> be nice?  So I can see if the same error shows up?  I'm pretty sure
> the error is about the "forcedeth" ethernet driver and the rt patches
> because of the way networking worked afterwards(I had to cold boot to
> get the ethernet going again in a regular fc9 kernel). 

This is similar to what was happening to me with rc6-rt2, maybe another
driver with a similar problem?

> Anyway, here it is:

[MUNCH]

ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
  alloc irq_desc for 19 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ohci1394 0000:01:0b.0: PCI INT A -> Link[APC4] -> GSI 19 (level, low) ->
IRQ 19
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[fdeff000-fdeff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.62.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
forcedeth 0000:00:08.0: PCI INT A -> Link[APCH] -> GSI 22 (level, low)
-> IRQ 22
forcedeth 0000:00:08.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
ck804xrom ck804xrom_init_one(): Unable to register resource
0x00000000ff000000-0x00000000ffffffff - kernel bug?
resource map sanity check conflict: 0xff000000 0xffffffff 0xfff80000
0xfff80fff pnp 00:0e
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:208 __ioremap_caller+0xec/0x2e1()
Hardware name: System Product Name
Info: mapping multiple BARs. Your kernel is fine.Modules linked in:
ck804xrom(+) snd_rawmidi parport mtd chipreg ohci1394 snd_seq_device
i2c_nforce2(+) usb_storage pcspkr i2c_core map_funcs snd_hwdep snd
k8temp(+) forcedeth(+) pata_amd hwmon pata_jmicron soundcore sata_nv
pata_acpi ata_generic
Pid: 803, comm: modprobe Not tainted
2.6.29-0.1.rt3.1.rc6.fc10.ccrma.x86_64.rt #1
Call Trace:
 [<ffffffff81059746>] warn_slowpath+0xcc/0x11c
 [<ffffffff81035bce>] ? default_spin_lock_flags+0x1c/0x36
 [<ffffffff81432fa3>] ? __spin_unlock_irqrestore+0x6d/0x91
 [<ffffffffa0023000>] ? init_ck804xrom+0x0/0x57a [ck804xrom]
 [<ffffffff8103c114>] __ioremap_caller+0xec/0x2e1
 [<ffffffffa002326b>] ? init_ck804xrom+0x26b/0x57a [ck804xrom]
 [<ffffffff81368e7e>] ? pci_write+0x3a/0x50
 [<ffffffffa0023000>] ? init_ck804xrom+0x0/0x57a [ck804xrom]
 [<ffffffff8103c460>] ioremap_nocache+0x25/0x3b
 [<ffffffffa002326b>] init_ck804xrom+0x26b/0x57a [ck804xrom]
 [<ffffffffa0023000>] ? init_ck804xrom+0x0/0x57a [ck804xrom]
 [<ffffffff8100a092>] do_one_initcall+0x65/0x15c
 [<ffffffff8108b8df>] sys_init_module+0xb8/0x1ed
 [<ffffffff81013732>] system_call_fastpath+0x16/0x1b
---[ end trace fab354474480faa9 ]---
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 1, addr
00:1a:92:f0:1a:e3
forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim
msi desc-v3
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum
#141
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
ACPI: I/O resource nForce2_smbus [0x1c40-0x1c7f] conflicts with ACPI
region SM01 [0x1c40-0x1c45]
ACPI: Device needs an ACPI driver
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c40
ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 21
forcedeth 0000:00:09.0: PCI INT A -> Link[AMC1] -> GSI 21 (level, low)
-> IRQ 21
forcedeth 0000:00:09.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
Found: SST 49LF040B
ck804xrom @fff80000: Found 1 x8 devices at 0x0 in 8-bit bank
using fwh lock/unlock method
number of JEDEC chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
ppdev: user-space parallel port driver
forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x5043 @ 1, addr
00:1a:92:f0:23:df
forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim
msi desc-v3
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800014184cf]
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
  alloc irq_desc for 17 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ICE1712 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) ->
IRQ 17
usbcore: registered new interface driver snd-usb-audio


