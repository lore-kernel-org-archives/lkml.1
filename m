Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbXK1Vch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbXK1Vch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXK1Vc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:32:27 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36931 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbXK1VcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:32:25 -0500
Date: Wed, 28 Nov 2007 13:31:47 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Alex Chiang <achiang@hp.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071128213147.GA6199@us.ibm.com>
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <20071127030454.GC23277@us.ibm.com> <20071127111136.77cb61fc@appleyard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127111136.77cb61fc@appleyard>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 11:11:36AM -0800, Kristen Carlson Accardi wrote:
> On Mon, 26 Nov 2007 19:04:54 -0800
> Gary Hade <garyhade@us.ibm.com> wrote:
> 
> > > Is this patchset appropriate for the -mm tree yet?  
> > 
> > I would defer to our illustrious maintainers on this one. :)
> > 
> > > Or do you think it still needs more work?  
> > 
> > I am now much more comfortable with your changes with respect
> > to acpiphp on the systems I worry about but others may have
> > concerns with respect to the other hotplug drivers, or even
> > acpiphp, on other systems.
> 
> I'm ok with adding it to my quilt tree (and into -mm) after Gary gets
> back to us later this week.

I'm getting back to you but unfortunately with not so good
news.  Sorry Alex.

On the x3950 (configured single node) I encountered the below
problem when attempting to hotplug a PCIe adapter when 'pci_slot'
was loaded prior to 'acpiphp'.  I did not see the problem when
the drivers were loaded in the opposite order.

After the messages appeared, the hotplug operation did not 
complete and I was unable to recover hotplug functionality
without a reboot.  I attempted recovery by unloading both
drivers and then reloading only 'acpiphp' but even though
an LED for the slot that had received the problem triggering
adapter indicated that the slot was receiving power, the
sysfs slot power file indicated otherwise (contained 0).
So, I was unable to power off the slot to allow the removal
and reinsertion of the adapter.

FYI, the node contains 2 hotpluggable PCIe slots and 5
non-hotpluggable PCIe slots but 'pci_slot' only exposed
the 2 hotpluggable slots.  This does not appear to be due
to a 'pci_slot' driver problem since I looked at the DSDT
and SSDT and found that there are currently no _SUN methods
for the non-hotpluggable slots.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

invalid opcode: 0000 [1] SMP 
CPU 1 
Modules linked in: acpiphp pci_slot e1000 aic79xx scsi_transport_spi shpchp dock pci_hotplug ipt_LOG xt_limit xt_pkttype button battery ac power_supply ip6t_REJECT xt_tcpudp ipt_REJECT iptable_mangle iptable_filter ip6table_mangle ip_tables ip6table_filter ip6_tables x_tables ipv6 usbhid ff_memless ext3 jbd loop dm_mod ehci_hcd uhci_hcd usbcore ide_cd bnx2 cdrom rng_core reiserfs ata_piix ahci libata thermal processor piix sg megaraid_sas fan edd sd_mod scsi_mod ide_disk ide_core
Pid: 121, comm: kacpi_notify Not tainted 2.6.24-rc3-gh-smp #1
RIP: 0010:[<ffffffff882c2344>]  [<ffffffff882c2344>] :pci_slot:__this_module+0x21c4/0xfffffffffffff204
RSP: 0018:ffff81103fa43ea8  EFLAGS: 00010216
RAX: ffff81103f944a18 RBX: ffff81103d4fe910 RCX: 000000000000000f
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8110400d13d0
RBP: ffffffff8032d97b R08: ffff8110400fc7e0 R09: 0000000000000002
R10: 0000000000000000 R11: ffffffff8021d193 R12: ffff811040105cf0
R13: ffffffffffffffff R14: ffffffff80635820 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8110400ed8c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002b266d876471 CR3: 000000103c825000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kacpi_notify (pid: 121, threadinfo ffff81103fa42000, task ffff81103f9f8040)
Stack:  ffffffff8033339c ffff81103d119a00 ffffffff8032d99e ffff81103f9fc540
 ffffffff8024618d ffff81103f9fc540 ffff81103f9fc540 ffffffff8024696c
 ffffffff80246a46 0000000000000000 ffff81103f9f8040 ffffffff80249ada
Call Trace:
 [<ffffffff8033339c>] acpi_ev_notify_dispatch+0x57/0x60
 [<ffffffff8032d99e>] acpi_os_execute_notify+0x23/0x2c
 [<ffffffff8024618d>] run_workqueue+0x7f/0x10b
 [<ffffffff8024696c>] worker_thread+0x0/0xe4
 [<ffffffff80246a46>] worker_thread+0xda/0xe4
 [<ffffffff80249ada>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802499bc>] kthread+0x47/0x73
 [<ffffffff8020cc98>] child_rip+0xa/0x12
 [<ffffffff80249975>] kthread+0x0/0x73
 [<ffffffff8020cc8e>] child_rip+0x0/0x12


Code: ff ff ff ff 40 23 2c 88 ff ff ff ff 00 c8 c6 3b 10 81 ff ff 
RIP  [<ffffffff882c2344>] :pci_slot:__this_module+0x21c4/0xfffffffffffff204
 RSP <ffff81103fa43ea8>

