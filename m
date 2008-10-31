Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbYJaUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbYJaUVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJaUVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:21:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33263 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYJaUVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:21:08 -0400
Message-ID: <490B6872.10706@kernel.org>
Date: Fri, 31 Oct 2008 13:20:02 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>
CC: Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no> <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net> <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com> <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org> <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org> <20081031100040.1f0cf34f@bike.lwn.net> <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org> <20081031105105.092ebad3@bike.lwn.net> <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please try this on your system. it works with test case like

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 0000000000095800 (usable)
 BIOS-e820: 0000000000095800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000d7fa0000 (usable)
 BIOS-e820: 00000000d7fae000 - 00000000d7fb0000 (reserved)
 BIOS-e820: 00000000d7fb0000 - 00000000d7fbe000 (ACPI data)
 BIOS-e820: 00000000d7fbe000 - 00000000d7ff0000 (ACPI NVS)
 BIOS-e820: 00000000d7ff0000 - 00000000d8000000 (reserved)
 BIOS-e820: 00000000dc000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000004028000000 (usable)

        // test stub
        e820_add_region(0xf0000000, 0xd300000, E820_RESERVED);
        update_e820();

modified physical RAM map:
 modified: 0000000000000100 - 0000000000095800 (usable)
 modified: 0000000000095800 - 00000000000a0000 (reserved)
 modified: 00000000000e6000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 00000000d7fa0000 (usable)
 modified: 00000000d7fae000 - 00000000d7fb0000 (reserved)
 modified: 00000000d7fb0000 - 00000000d7fbe000 (ACPI data)
 modified: 00000000d7fbe000 - 00000000d7ff0000 (ACPI NVS)
 modified: 00000000d7ff0000 - 00000000d8000000 (reserved)
 modified: 00000000dc000000 - 00000000fd300000 (reserved)
 modified: 00000000fec00000 - 00000000fec01000 (reserved)
 modified: 00000000fee00000 - 00000000fee01000 (reserved)
 modified: 00000000ff700000 - 0000000100000000 (reserved)
 modified: 0000000100000000 - 0000004028000000 (usable)
Allocating PCI resources starting at d8400000 (gap: d8000000:4000000)


will get:

[    8.536336] modified physical RAM map:
[    8.540016]  modified: 0000000000000100 - 0000000000095800 (usable)
[    8.544900]  modified: 0000000000095800 - 00000000000a0000 (reserved)
[    8.549065]  modified: 00000000000e6000 - 0000000000100000 (reserved)
[    8.556015]  modified: 0000000000100000 - 00000000d7fa0000 (usable)
[    8.560892]  modified: 00000000d7fae000 - 00000000d7fb0000 (reserved)
[    8.565064]  modified: 00000000d7fb0000 - 00000000d7fbe000 (ACPI data)
[    8.569150]  modified: 00000000d7fbe000 - 00000000d7ff0000 (ACPI NVS)
[    8.573072]  modified: 00000000d7ff0000 - 00000000d8000000 (reserved)
[    8.580015]  modified: 00000000dc000000 - 00000000fb200000 (reserved)
[    8.585063]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    8.589064]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    8.596015]  modified: 00000000ff700000 - 0000000100000000 (reserved)
[    8.601063]  modified: 0000000100000000 - 0000004028000000 (usable)


d8000000-dfffffff : PCI Bus #00
  dc000000-dfffffff : GART
    dc000000-dfffffff : reserved
e0000000-efffffff : PCI MMCONFIG 0
  e0000000-efffffff : reserved
f0000000-fdffffff : PCI Bus #00
  f0000000-faefffff : reserved
  faf00000-fcffffff : PCI Bus 0000:01
    faf00000-fb1fffff : reserved
    fbfff000-fbffffff : 0000:01:06.0
    fc000000-fcffffff : 0000:01:06.0
  fd000000-fd2fffff : PCI Bus 0000:02
    fd000000-fd2fffff : PCI Bus 0000:03
      fd000000-fd1fffff : PCI Bus 0000:04
        fd160000-fd17ffff : 0000:04:00.1
          fd160000-fd17ffff : e1000e
        fd180000-fd19ffff : 0000:04:00.1
          fd180000-fd19ffff : e1000e
        fd1a0000-fd1bffff : 0000:04:00.0
        fd1c0000-fd1dffff : 0000:04:00.0
          fd1c0000-fd1dffff : e1000e
        fd1e0000-fd1fffff : 0000:04:00.0
          fd1e0000-fd1fffff : e1000e
      fd200000-fd2fffff : PCI Bus 0000:05
        fd280000-fd29ffff : 0000:05:00.1
          fd280000-fd29ffff : e1000e
        fd2a0000-fd2bffff : 0000:05:00.1
          fd2a0000-fd2bffff : e1000e
        fd2c0000-fd2dffff : 0000:05:00.0
          fd2c0000-fd2dffff : e1000e
        fd2e0000-fd2fffff : 0000:05:00.0
          fd2e0000-fd2fffff : e1000e




[PATCH] x86: remove PCI bar range from e820 reserved entries

Impact: clean up buggy e820 tables

so make those ranges can be claimed by drivers
acctually BIOS is not supposed to put resource in pci BAR in reserved entries of e820.
e820 entries should only include reserved range include mmconfig, lapic, ... and others
that are not in BARs

---
 arch/x86/kernel/e820.c |   70 +++++++++++++++++++++++++++++++++++--------------
 arch/x86/pci/i386.c    |   55 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1271,35 +1271,43 @@ static inline const char *e820_type_to_s
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
-static struct resource __initdata *e820_res;
 void __init e820_reserve_resources(void)
 {
-	int i;
 	struct resource *res;
+	int i, count = 0;
 	u64 end;
 
-	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
-	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
-		if (end != (resource_size_t)end) {
-			res++;
+		if (end != (u64)(resource_size_t)end)
 			continue;
-		}
-		res->name = e820_type_to_string(e820.map[i].type);
-		res->start = e820.map[i].addr;
-		res->end = end;
+		if (e820.map[i].type != E820_RESERVED ||
+		    e820.map[i].addr < (1ULL<<20))
+			count++;
+	}
 
-		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	res = alloc_bootmem_low(sizeof(struct resource) * count);
+	for (i = 0; i < e820.nr_map; i++) {
+		end = e820.map[i].addr + e820.map[i].size - 1;
+		if (end != (u64)(resource_size_t)end)
+			continue;
 
 		/*
-		 * don't register the region that could be conflicted with
-		 * pci device BAR resource and insert them later in
+		 * don't register the region that could be conflicted
+		 * with pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
+		if (e820.map[i].type != E820_RESERVED ||
+		    e820.map[i].addr < (1ULL<<20)) {
+			res->name = e820_type_to_string(e820.map[i].type);
+			res->start = e820.map[i].addr;
+			res->end = end;
+
+			res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+
 			insert_resource(&iomem_resource, res);
-		res++;
+			res++;
+		}
 	}
 
 	for (i = 0; i < e820_saved.nr_map; i++) {
@@ -1312,13 +1320,37 @@ void __init e820_reserve_resources(void)
 
 void __init e820_reserve_resources_late(void)
 {
-	int i;
 	struct resource *res;
+	int i, count = 0;
+	u64 end;
 
-	res = e820_res;
+	/* only insert reserved entries here, also need to recount them */
 	for (i = 0; i < e820.nr_map; i++) {
-		if (!res->parent && res->end)
-			reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
+		end = e820.map[i].addr + e820.map[i].size - 1;
+		if (end != (u64)(resource_size_t)end)
+			continue;
+		if (e820.map[i].type != E820_RESERVED ||
+		    e820.map[i].addr < (1ULL<<20))
+			continue;
+		count++;
+	}
+
+	res = kzalloc(sizeof(struct resource) * count, GFP_KERNEL);
+	for (i = 0; i < e820.nr_map; i++) {
+		end = e820.map[i].addr + e820.map[i].size - 1;
+		if (end != (u64)(resource_size_t)end)
+			continue;
+
+		if (e820.map[i].type != E820_RESERVED ||
+		    e820.map[i].addr < (1ULL<<20))
+			continue;
+
+		res->name = e820_type_to_string(e820.map[i].type);
+		res->start = e820.map[i].addr;
+		res->end = end;
+
+		reserve_region_with_split(&iomem_resource, res->start,
+					  res->end, res->name);
 		res++;
 	}
 }
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -194,6 +194,60 @@ static void __init pcibios_allocate_reso
 	}
 }
 
+static __initdata u64 real_removed_size;
+static void __init e820_remove_bus_overlap(struct list_head *bus_list)
+{
+	struct pci_bus *bus;
+	struct pci_dev *dev;
+	int idx;
+	struct resource *r;
+
+	/* Depth-First Search on bus tree */
+	list_for_each_entry(bus, bus_list, node) {
+		dev = bus->self;
+		if (dev) {
+			for (idx = PCI_BRIDGE_RESOURCES;
+			    idx < PCI_NUM_RESOURCES; idx++) {
+				r = &dev->resource[idx];
+				if (!(r->flags & IORESOURCE_MEM))
+					continue;
+				real_removed_size += e820_remove_range(r->start,
+							 r->end - r->start + 1,
+							 E820_RESERVED, 1);
+			}
+		}
+		e820_remove_bus_overlap(&bus->children);
+	}
+}
+static void __init e820_remove_bar_overlap(void)
+{
+	struct pci_dev *dev = NULL;
+	int idx;
+	struct resource *r;
+
+	real_removed_size = 0;
+
+	e820_remove_bus_overlap(&pci_root_buses);
+
+	for_each_pci_dev(dev) {
+		for (idx = 0; idx < PCI_ROM_RESOURCE; idx++) {
+			r = &dev->resource[idx];
+			if (!r->start)	/* Address not assigned at all */
+				continue;
+			if (!(r->flags & IORESOURCE_MEM))
+				continue;
+			real_removed_size += e820_remove_range(r->start,
+						 r->end - r->start + 1,
+						 E820_RESERVED, 1);
+		}
+	}
+
+	if (real_removed_size)
+		update_e820();
+
+}
+
+
 static int __init pcibios_assign_resources(void)
 {
 	struct pci_dev *dev = NULL;
@@ -229,6 +283,7 @@ void __init pcibios_resource_survey(void
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
 
+	e820_remove_bar_overlap();
 	e820_reserve_resources_late();
 }
 

