Return-Path: <linux-kernel-owner+w=401wt.eu-S933119AbXK3BT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119AbXK3BT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbXK3BTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:19:45 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11132 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbXK3BTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:19:43 -0500
Date: Thu, 29 Nov 2007 18:19:41 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071130011941.GG24707@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <20071127030454.GC23277@us.ibm.com> <20071127111136.77cb61fc@appleyard> <20071128213147.GA6199@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128213147.GA6199@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

First, thanks for all the help and testing -- I really appreciate
it.

* Gary Hade <garyhade@us.ibm.com>:
> 
> I'm getting back to you but unfortunately with not so good
> news.  Sorry Alex.

:-/

> On the x3950 (configured single node) I encountered the below
> problem when attempting to hotplug a PCIe adapter when 'pci_slot'
> was loaded prior to 'acpiphp'.  I did not see the problem when
> the drivers were loaded in the opposite order.

Very bizarre, especially given the stack trace below, which
doesn't really make any sense to me at all.

> FYI, the node contains 2 hotpluggable PCIe slots and 5
> non-hotpluggable PCIe slots but 'pci_slot' only exposed
> the 2 hotpluggable slots.  This does not appear to be due
> to a 'pci_slot' driver problem since I looked at the DSDT
> and SSDT and found that there are currently no _SUN methods
> for the non-hotpluggable slots.

Ok, this is not too surprising, but it's a different can o'
worms. ;) Let's save this for another day...

> invalid opcode: 0000 [1] SMP 
> CPU 1 
> Modules linked in: acpiphp pci_slot e1000 aic79xx scsi_transport_spi shpchp dock pci_hotplug ipt_LOG xt_limit xt_pkttype button battery ac power_supply ip6t_REJECT xt_tcpudp ipt_REJECT iptable_mangle iptable_filter ip6table_mangle ip_tables ip6table_filter ip6_tables x_tables ipv6 usbhid ff_memless ext3 jbd loop dm_mod ehci_hcd uhci_hcd usbcore ide_cd bnx2 cdrom rng_core reiserfs ata_piix ahci libata thermal processor piix sg megaraid_sas fan edd sd_mod scsi_mod ide_disk ide_core
> Pid: 121, comm: kacpi_notify Not tainted 2.6.24-rc3-gh-smp #1
> RIP: 0010:[<ffffffff882c2344>]  [<ffffffff882c2344>] :pci_slot:__this_module+0x21c4/0xfffffffffffff204
> RSP: 0018:ffff81103fa43ea8  EFLAGS: 00010216
> RAX: ffff81103f944a18 RBX: ffff81103d4fe910 RCX: 000000000000000f
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8110400d13d0
> RBP: ffffffff8032d97b R08: ffff8110400fc7e0 R09: 0000000000000002
> R10: 0000000000000000 R11: ffffffff8021d193 R12: ffff811040105cf0
> R13: ffffffffffffffff R14: ffffffff80635820 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8110400ed8c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00002b266d876471 CR3: 000000103c825000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kacpi_notify (pid: 121, threadinfo ffff81103fa42000, task ffff81103f9f8040)
> Stack:  ffffffff8033339c ffff81103d119a00 ffffffff8032d99e ffff81103f9fc540
>  ffffffff8024618d ffff81103f9fc540 ffff81103f9fc540 ffffffff8024696c
>  ffffffff80246a46 0000000000000000 ffff81103f9f8040 ffffffff80249ada
> Call Trace:
>  [<ffffffff8033339c>] acpi_ev_notify_dispatch+0x57/0x60
>  [<ffffffff8032d99e>] acpi_os_execute_notify+0x23/0x2c
>  [<ffffffff8024618d>] run_workqueue+0x7f/0x10b
>  [<ffffffff8024696c>] worker_thread+0x0/0xe4
>  [<ffffffff80246a46>] worker_thread+0xda/0xe4
>  [<ffffffff80249ada>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff802499bc>] kthread+0x47/0x73
>  [<ffffffff8020cc98>] child_rip+0xa/0x12
>  [<ffffffff80249975>] kthread+0x0/0x73
>  [<ffffffff8020cc8e>] child_rip+0x0/0x12

Maybe we're trying to kick off a hotplug event on the wrong slot?
I really have no idea...

> Code: ff ff ff ff 40 23 2c 88 ff ff ff ff 00 c8 c6 3b 10 81 ff ff 
> RIP  [<ffffffff882c2344>] :pci_slot:__this_module+0x21c4/0xfffffffffffff204
>  RSP <ffff81103fa43ea8>

Can you apply this debug patch on top of your tree, and send me
the output?

I'd be curious to see the output for your failure case:

  # modprobe pci_slot debug=1
  # modprobe acpiphp debug=1

Thanks.

/ac

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index 724f4f0..5a62def 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -30,12 +30,16 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+static int debug;
+
 #define DRIVER_VERSION 	"0.1"
 #define DRIVER_AUTHOR	"Alex Chiang <achiang@hp.com>"
 #define DRIVER_DESC	"ACPI PCI Slot Detection Driver"
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
+module_param(debug, bool, 0644);
 
 #define _COMPONENT		ACPI_PCI_COMPONENT
 ACPI_MODULE_NAME("pci_slot");
@@ -43,6 +47,12 @@ ACPI_MODULE_NAME("pci_slot");
 #define MY_NAME "pci_slot"
 #define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
 #define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
+#define dbg(format, arg...)					\
+	do {							\
+		if (debug)					\
+			printk(KERN_DEBUG "%s: " format,	\
+				MY_NAME , ## arg);		\
+	} while (0)
 
 static int acpi_pci_slot_add(acpi_handle handle);
 static void acpi_pci_slot_remove(acpi_handle handle);
@@ -125,6 +135,9 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (IS_ERR(pci_slot))
 		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
 
+	dbg("pci_slot: %#lx, pci_bus: %x, device: %d, name: %s\n",
+		(uint64_t)pci_slot, pci_bus->number, device, name);
+
 	return AE_OK;
 }
 
@@ -174,6 +187,7 @@ walk_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (!dev || !dev->subordinate)
 		goto out;
 
+	dbg("p2p bridge walk, pci_bus = %x\n", dev->subordinate->number);
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				     user_function, dev->subordinate, NULL);
 	if (ACPI_FAILURE(status))
@@ -231,6 +245,7 @@ walk_root_bridge(acpi_handle handle, acpi_walk_callback user_function)
 	if (!pci_bus)
 		return 0;
 
+	dbg("root bridge walk, pci_bus = %x\n", pci_bus->number);
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				     user_function, pci_bus, NULL);
 	if (ACPI_FAILURE(status))
@@ -283,7 +298,6 @@ acpi_pci_slot_init(void)
 	return 0;
 }
 
-
 static void __exit
 acpi_pci_slot_exit(void)
 {
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index f16e0af..80c4928 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -9,6 +9,15 @@
 #include <linux/pci.h>
 #include "pci.h"
 
+static int pci_slot_debug;
+#define MY_NAME "slot"
+#define dbg(format, arg...)					\
+	do {							\
+		if (pci_slot_debug)				\
+			printk(KERN_DEBUG "%s: " format,	\
+				MY_NAME , ## arg);		\
+	} while (0)
+
 struct kset pci_slots_subsys;
 EXPORT_SYMBOL_GPL(pci_slots_subsys);
 
@@ -63,6 +72,9 @@ static void pci_slot_release(struct kobject *kobj)
 	struct pci_slot **pprev;
 	struct pci_slot *slot = to_pci_slot(kobj);
 
+	dbg("%s: releasing pci_slot on %x:%d\n", __FUNCTION__,
+		slot->bus->number, slot->number);
+
 	for (pprev = &slot->bus->slot; *pprev; pprev = &(*pprev)->next) {
 		if (*pprev == slot) {
 			*pprev = slot->next;
@@ -103,15 +115,19 @@ int pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
 		}
 
 	if (!found) {
+		dbg("%s: slot not found\n", __FUNCTION__);
 		retval = -EEXIST;
 		goto out;
 	}
 
 	if (slot->release) {
+		dbg("%s: already claimed\n", __FUNCTION__);
 		retval = -EBUSY;
 		goto out;
 	}
 
+	dbg("%s: adding release function to %x:%d\n", 
+		__FUNCTION__, parent->number, slot_nr);
 	slot->release = release;
  out:
 	up_write(&pci_bus_sem);
@@ -131,6 +147,9 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 	for (slot = parent->slot; slot; slot = slot->next) {
 		if (slot->number == slot_nr) {
 			kobject_get(&slot->kobj);
+			dbg("%s: bumped refcount to %d on %x:%d\n",
+				__FUNCTION__, slot->kobj.kref.refcount,
+				parent->number, slot_nr);
 			goto out;
 		}
 	}
@@ -159,6 +178,9 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 	slot->next = parent->slot;
 	parent->slot = slot;
 
+	dbg("%s: created pci_slot on %x:%d\n", 
+		__FUNCTION__, parent->number, slot_nr);
+
  out:
 	up_write(&pci_bus_sem);
 	return slot;
@@ -175,6 +197,10 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
 int pci_destroy_slot(struct pci_slot *slot)
 {
 	kobject_put(&slot->kobj);
+
+	dbg("%s: decreased refcount to %d on %x:%d\n", __FUNCTION__,
+		slot->kobj.kref.refcount, slot->bus->number, slot->number);
+
 	if (atomic_read(&slot->kobj.kref.refcount) == 1)
 		kobject_unregister(&slot->kobj);
 
@@ -186,6 +212,8 @@ static int pci_slot_init(void)
 {
 	int result;
 
+	pci_slot_debug = 1;
+
 	kobj_set_kset_s(&pci_slots_subsys, pci_bus_type.subsys);
 	result = subsystem_register(&pci_slots_subsys);
 	if (result)
