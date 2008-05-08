Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbYEHRvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbYEHRvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbYEHRs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:48:29 -0400
Received: from mga07.intel.com ([143.182.124.22]:58663 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765243AbYEHRrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:47:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,455,1204531200"; 
   d="scan'208";a="243985787"
Date: Thu, 8 May 2008 10:54:57 -0700
From: mark gross <mgross@linux.intel.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: intel-iommu: CONFIG_DMAR*=y kills my box
Message-ID: <20080508175457.GA20253@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <48133A64.7020702@googlemail.com> <4813660E.8080609@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4813660E.8080609@googlemail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 07:27:42PM +0200, Gabriel C wrote:
> Gabriel C wrote:
> > Hi all,
> > 
> > On an kernel ( tested 2.6.25 , linux-next and latest -git ) with DMAR enabled my box won't boot unless I disable it with intel_iommu=off.
> > 
> > It hangs very early on boot and not even the reset button works anymore , all I get is an black screen , no message or alike and the box hangs.
> > Also it does not make any difference when enabling / disabling  DMAR_GFX_WA.
> > 
> > I would like to debug the problem but I have no idea on how to do it.
> > 
> > Also this box has an ASUS P5E-VM DO motherboard , latest BIOS , Q9300 Quad CPU and 4G RAM.
> > 
> > lspci :
> > 
> > 00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
> > 00:02.0 VGA compatible controller: Intel Corporation Integrated Graphics Controller (rev 02)
> > 00:03.0 Communication controller: Intel Corporation MEI Controller (rev 02)
> > 00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network Connection (rev 02)
> > 00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02)
> > 00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02)
> > 00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02)
> > 00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02)
> > 00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
> > 00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
> > 00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
> > 00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
> > 00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
> > 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> > 00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
> > 00:1f.2 SATA controller: Intel Corporation 6 port SATA AHCI Controller (rev 02)
> > 00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
> > 00:1f.6 Signal processing controller: Intel Corporation Thermal Subsystem (rev 02)
> > 
> > 
> 
> Got more infos on that.
> 
> After poking a lot around I found out the boot problem occurs when I have *any* usb devices inserted on boot ( really does not matter which ).
> 
> Removing these on boot ( mouse , keyboard and an 1G stick ) made it boot but I got an OOps on loading the parport_pc modules and box died :/
> 
> After blacklisting parport_pc box was up. Strange thing is now I can insert my USB devices and everything is working.
> 
> The OOPs is reproducible with modprobe too. 
> 
> New dmesg output : 
> ...
> 
> 
> [    0.000000] Linux version 2.6.25-05096-gb1721d0-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #793 SMP PREEMPT Sat Apr 26 18:07:59 CEST 2008
> [    0.000000] Command line: root=/dev/sdb1 ro debug vga=792 3

snip

> [    0.350277] usbcore: registered new interface driver hub
> [    0.350344] usbcore: registered new device driver usb
> [    0.350619] PCI: Using ACPI for IRQ routing
> [    0.357951] DMAR:Host address width 36
> [    0.357958] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed90000
> [    0.357967] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed91000
> [    0.357976] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed92000
> [    0.357986] DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed93000
> [    0.357994] DMAR:RMRR base: 0x00000000000ed000 end: 0x00000000000effff
> [    0.358011] DMAR:RMRR base: 0x00000000cf600000 end: 0x00000000cfffffff
> [    0.358020] DMAR:RMRR base: 0x00000000cf5e0000 end: 0x00000000cf5effff
> [    0.358078] IOMMU: Setting identity map for device 0000:00:1d.0 [0xcf5e0000 - 0xcf5f0000]
> [    0.358107] IOMMU: Setting identity map for device 0000:00:1d.1 [0xcf5e0000 - 0xcf5f0000]
> [    0.358129] IOMMU: Setting identity map for device 0000:00:1d.2 [0xcf5e0000 - 0xcf5f0000]
> [    0.358151] IOMMU: Setting identity map for device 0000:00:1d.7 [0xcf5e0000 - 0xcf5f0000]
> [    0.358176] IOMMU: Setting identity map for device 0000:00:1a.0 [0xcf5e0000 - 0xcf5f0000]
> [    0.358198] IOMMU: Setting identity map for device 0000:00:1a.1 [0xcf5e0000 - 0xcf5f0000]
> [    0.358232] IOMMU: Setting identity map for device 0000:00:1a.2 [0xcf5e0000 - 0xcf5f0000]
> [    0.358260] IOMMU: Setting identity map for device 0000:00:1a.7 [0xcf5e0000 - 0xcf5f0000]
> [    0.358284] IOMMU: Setting identity map for device 0000:00:02.0 [0xcf600000 - 0xd0000000]
> [    0.358842] IOMMU: Setting identity map for device 0000:00:1d.0 [0xed000 - 0xf0000]
> [    0.358856] IOMMU: Setting identity map for device 0000:00:1d.1 [0xed000 - 0xf0000]
> [    0.358869] IOMMU: Setting identity map for device 0000:00:1d.2 [0xed000 - 0xf0000]
> [    0.358883] IOMMU: Setting identity map for device 0000:00:1d.7 [0xed000 - 0xf0000]
> [    0.358900] IOMMU: Setting identity map for device 0000:00:1a.0 [0xed000 - 0xf0000]
> [    0.358913] IOMMU: Setting identity map for device 0000:00:1a.1 [0xed000 - 0xf0000]
> [    0.358926] IOMMU: Setting identity map for device 0000:00:1a.2 [0xed000 - 0xf0000]
> [    0.358939] IOMMU: Setting identity map for device 0000:00:1a.7 [0xed000 - 0xf0000]
> [    0.358954] IOMMU: gfx device 0000:00:02.0 1-1 mapping
> [    0.358959] IOMMU: Setting identity map for device 0000:00:02.0 [0x0 - 0x9cc00]
> [    0.359005] IOMMU: Setting identity map for device 0000:00:02.0 [0x100000 - 0xcf550000]
> [    0.542673] IOMMU: Setting identity map for device 0000:00:02.0 [0x100000000 - 0x12c000000]
> [    0.581575] IOMMU: Prepare 0-16M unity mapping for LPC
> [    0.581583] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
> [    0.581583] DMAR:[DMA Write] Request device [00:02.0] fault addr ffffff000 
> [    0.581584] DMAR:[fault reason 05] PTE Write access is not set
> [    0.582922] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> [    0.582937] PCI-GART: No AMD northbridge found.

snip

> [   19.684279] eth0: 10/100 speed: disabling TSO
> [   21.030925] fuse init (API version 7.9)
> [  118.660390] ppdev: user-space parallel port driver
> [  138.724111] lp: driver loaded but no devices found
> [  178.888281] parport_pc 00:06: reported by Plug and Play ACPI
> [  178.888385] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
> [  178.888968] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> [  178.890214] IP: [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
> [  178.890214] PGD 128f5a067 PUD 1274e1067 PMD 0 
> [  178.890214] Oops: 0000 [1] PREEMPT SMP 
> [  178.890214] CPU 0 
> [  178.890214] Modules linked in: parport_pc(+) lp ppdev parport fuse loop pata_acpi button i2c_i801 sr_mod evdev
> [  178.890214] Pid: 4286, comm: modprobe Not tainted 2.6.25-05096-gb1721d0-dirty #793
> [  178.890214] RIP: 0010:[<ffffffff80365eaf>]  [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
> [  178.890214] RSP: 0018:ffff8101274c5ab8  EFLAGS: 00010246
> [  178.890214] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  178.890214] RDX: 0000000000000000 RSI: 0000000000000030 RDI: ffff81012be17f80
> [  178.890214] RBP: 0000000000001000 R08: 0000000000000000 R09: ffff810128f99000
> [  178.890214] R10: 0000000000000000 R11: ffffffff8036fd80 R12: 0000000000000030
> [  178.890214] R13: ffff81012be17f80 R14: ffff81012be18000 R15: ffff81012be17f80
> [  178.890214] FS:  00007f66267e76f0(0000) GS:ffffffff8071d000(0000) knlGS:0000000000000000
> [  178.890214] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  178.890214] CR2: 0000000000000038 CR3: 0000000129719000 CR4: 00000000000006e0
> [  178.890214] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  178.890214] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  178.890214] Process modprobe (pid: 4286, threadinfo ffff8101274c4000, task ffff81012a452000)
> [  178.890214] Stack:  000000002700205d ffffffff8036e708 0000000000000001 ffffffff80783f40
> [  178.896962]  0000000000000001 0000004400000001 000210d000000000 ffffffff806b0a28
> [  178.896969]  0000000000000002 ffffffff806afd80 0000000000000000 0000000000000000
> [  178.896973] Call Trace:
> [  178.896976]  [<ffffffff8036e708>] ? get_domain_for_dev+0x78/0x6b0
> [  178.896979]  [<ffffffff8036f077>] ? get_valid_domain_for_dev+0x17/0x150
> [  178.896981]  [<ffffffff8036fc5d>] ? intel_map_single+0x3d/0x160
> [  178.896982]  [<ffffffff8036fdfe>] ? intel_alloc_coherent+0x7e/0xc0
> [  178.896987]  [<ffffffffa00434b9>] ? :parport_pc:parport_pc_probe_port+0x799/0xe20
> [  178.896991]  [<ffffffffa0043c3f>] ? :parport_pc:parport_pc_pnp_probe+0xff/0x140
> [  178.896993]  [<ffffffff803a828d>] ? pnp_device_probe+0x9d/0x130
> [  178.896996]  [<ffffffff803ddcee>] ? driver_probe_device+0x9e/0x1d0
> [  178.896998]  [<ffffffff803ddeab>] ? __driver_attach+0x8b/0x90
> [  178.897000]  [<ffffffff803dde20>] ? __driver_attach+0x0/0x90
> [  178.897002]  [<ffffffff803dd48b>] ? bus_for_each_dev+0x5b/0x80
> [  178.897005]  [<ffffffff802a4267>] ? kmem_cache_alloc+0x67/0xa0
> [  178.897007]  [<ffffffff803dcd58>] ? bus_add_driver+0x208/0x280
> [  178.897008]  [<ffffffff803de04f>] ? driver_register+0x3f/0x100
> [  178.897011]  [<ffffffffa004e648>] ? :parport_pc:parport_pc_init+0x5a3/0x5ba
> [  178.897014]  [<ffffffff8025f274>] ? sys_init_module+0x184/0x1da0
> [  178.897018]  [<ffffffff8023dd00>] ? __request_region+0x0/0x120
> [  178.897020]  [<ffffffff802a9bc8>] ? vfs_read+0xc8/0x180
> [  178.897023]  [<ffffffff8020b80b>] ? system_call_after_swapgs+0x7b/0x80
> [  178.897025] 
> [  178.897025] 
> [  178.897026] Code: 94 c0 0f b6 c0 c3 66 0f 1f 44 00 00 48 83 ec 08 f6 87 61 05 00 00 08 75 33 31 d2 eb 0a 0f 1f 80 00 00 00 00 48 89 fa 48 8b 47 10 <48> 8b 78 38 48 85 ff 74 28 f6 87 61 05 00 00 08 74 e7 48 89 f8 
> [  178.897037] RIP  [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
> [  178.897039]  RSP <ffff8101274c5ab8>
> 
> ...
> 
> It seems parport* is orphaned , I will add Andrew to CC , maybe he knows someone who still cares about =)
> 
>

Gabriel,
I don't have any idea how the parport_pc probe is triggering a PCIE bus
walk seeing that its a legacy device.  (isn't it?  I don't see a PCI
P-port card in the lspci dump you sent).

Can you send (off list) your .config file used to recreate this Ooops?

Also the following is a short patch to help gaurd the walking off a null
pointer in drivers/pci/search.c  (which is what I see happening when you
load the parap_pc module.


Signed-Off-By: mark gross <mgross@linux.intel.com>

------


Index: linux-next/drivers/pci/search.c
===================================================================
--- linux-next.orig/drivers/pci/search.c	2008-05-08 09:53:30.000000000 -0700
+++ linux-next/drivers/pci/search.c	2008-05-08 10:03:35.000000000 -0700
@@ -29,6 +29,11 @@
 	if (pdev->is_pcie)
 		return NULL;
 	while (1) {
+		if (!pdev | !pdev->bus) {
+			WARN_ON(1); /* this shouldn't happen */
+			return NULL;
+		}
+
 		if (!pdev->bus->self)
 			break;
 		pdev = pdev->bus->self;
