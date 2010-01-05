Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228Ab0AELDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0AELDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898Ab0AELDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:03:53 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:54272 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab0AELDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:03:52 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: mingo@elte.hu
cc: linux-kernel@vger.kernel.org
Subject: Memory probing fails after 2.6.30 (bisected)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 05 Jan 2010 12:02:56 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.238.172
X-Scan-Result: No virus found in message 1NS7Bu-00048b-6Y.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1NS7Bu-00048b-6Y 8ed59687eaaa7255e8a0f0ba44384bb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Upgrading my laptop's kernel, I discovered that it reboots immediately after 
boot on .31 and later kernels. Grub loads it, but I cannot get one line of 
text out of it before it reboots, even using boot_delay.

Bisecting I came up with the following:

git bisect start
# good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
git bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
# bad: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
git bisect bad 74fca6a42863ffacaf7ba6f1936a9f228950f657
# bad: [925d74ae717c9a12d3618eb4b36b9fb632e2cef3] V4L/DVB (11736): videobuf: modify return value of VIDIOC_REQBUFS ioctl
git bisect bad 925d74ae717c9a12d3618eb4b36b9fb632e2cef3
# bad: [e349792a385ed47390d156155b1a1e19af1bf163] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad e349792a385ed47390d156155b1a1e19af1bf163
# bad: [c9059598ea8981d02356eead3188bf7fa4d717b8] Merge branch 'for-2.6.31' of git://git.kernel.dk/linux-2.6-block
git bisect bad c9059598ea8981d02356eead3188bf7fa4d717b8
# bad: [59c288ffb6dfb55bdd6bfe6826ab6203ff791930] Merge branches 'frv' and 'mn10300'
git bisect bad 59c288ffb6dfb55bdd6bfe6826ab6203ff791930
# bad: [3f6280ddf25fa656d0e17960588e52bee48a7547] Merge branch 'iommu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 3f6280ddf25fa656d0e17960588e52bee48a7547
# good: [c44e3ed539e4fc17d6bcb5eaecb894a94de4cc5f] Merge branch 'x86-cpu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good c44e3ed539e4fc17d6bcb5eaecb894a94de4cc5f
# bad: [be15f9d63b97da0065187696962331de6cd9de9e] Merge branch 'x86-xen-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad be15f9d63b97da0065187696962331de6cd9de9e
# bad: [9b29e8228a5c2a169436a1a90a60b1f88cb35cd1] Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 9b29e8228a5c2a169436a1a90a60b1f88cb35cd1
# bad: [35d5a9a61490bf39d2e48d7f499c8c801a39ebe9] x86: fix system without memory on node0 ---> Got a BIOS-88 map
git bisect bad 35d5a9a61490bf39d2e48d7f499c8c801a39ebe9
# bad: [45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90] x86, e820, pci: reserve extra free space near end of RAM ---> Got a BIOS-88 map
git bisect bad 45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90
# bad: [2b72394e4089643f11669d9610907a1442fe044a] x86: move max_pfn_mapped and max_low_pfn_mapped to setup.c ---> Got a BIOS-88 map
git bisect bad 2b72394e4089643f11669d9610907a1442fe044a
# good: [6424fb38667fffbbb1b90be0ffd9a0c540db6a4b] x86: remove (null) in /sys kernel_page_tables
git bisect good 6424fb38667fffbbb1b90be0ffd9a0c540db6a4b
# bad: [89388913f2c88a2cd15d24abab571b17a2596127] x86: unify noexec handling --> Got a BIOS-88 map
git bisect bad 89388913f2c88a2cd15d24abab571b17a2596127
# bad: [8ecee4620e76aae418bfa0e8cc830e92cb559bbb] Merge branch 'linus' into x86/mm ---> Got a BIOS-88 map
git bisect bad 8ecee4620e76aae418bfa0e8cc830e92cb559bbb


I've annotated some bad kernels, where I _do_ get it to start, but it only 
finds a BIOS-88 map (and hence only 16MB ram, and userspace triggers OOMK).

I found your name in the commit bisect fingered, hence I turn to you for help. 

Here's a dmesg from the last known good kernel :

Linux version 2.6.29-01001-g6424fb3 (root@korven) (gcc version 4.3.2 (Gentoo 4.3.2-r3 p1.6, pie-10.1.5) ) #22 SMP Tue Jan 5 11:12:56 CET 2010
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ae20 (usable)
 BIOS-e820: 000000000009ae20 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f7d0000 (usable)
 BIOS-e820: 000000007f7d0000 - 000000007f7e5600 (reserved)
 BIOS-e820: 000000007f7e5600 - 000000007f7f8000 (ACPI NVS)
 BIOS-e820: 000000007f7f8000 - 000000007f800000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9b000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x7f7d0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base F7F800000 mask FFF800000 uncachable
  2 base 0FEDA0000 mask FFFFE0000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled

I can produce a pic of the dmesg for the fingered commit of needed.

As the fingered commit was a merge one, I'm uncertain how to proceed.

Ideas?

--Anders


