Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZDXOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZDXOw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZDXOwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:52:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52340 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbZDXOwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:52:17 -0400
Date: Sat, 25 Apr 2009 00:52:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: slab tree boot failure
Message-Id: <20090425005206.943530b6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__25_Apr_2009_00_52_06_+1000_H2tL0sy5U.X4UDNr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__25_Apr_2009_00_52_06_+1000_H2tL0sy5U.X4UDNr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The last few days linux-next trees have failed to boot on one of our
PowerPC Power6 servers.  The partial boot log looks like this (full
log below):

memory layout at init:
  alloc_bottom : 0000000004dd4000
  alloc_top    : 0000000008000000
  alloc_top_hi : 0000000008000000
  rmo_top      : 0000000008000000
  ram_top      : 0000000008000000

physicalMemorySize            =3D 0x80000000

Zone PFN ranges:
  DMA      0x00000000 -> 0x00080000
  Normal   0x00080000 -> 0x00080000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    1: 0x00000000 -> 0x00080000
Could not find start_pfn for node 0
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 510976
Policy zone: DMA
Kernel command line: root=3D/dev/VolGroup00/LogVol00 ro console=3Dhvc0  aut=
obench_args: root=3D/dev/sdb1 ABAT:1240566469 initcall_debug=20

Mount-cache hash table entries: 256
Unable to handle kernel paging request for data at address 0x00000008
Faulting instruction address: 0xc000000000100524
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D128 NUMA pSeries
Modules linked in:
NIP: c000000000100524 LR: c0000000001004f4 CTR: 0000000000000001
REGS: c000000000aef690 TRAP: 0300   Not tainted  (2.6.30-rc1-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 48000082  XER: 00000005
DAR: 0000000000000008, DSISR: 0000000042000000
TASK =3D c0000000009bedd0[0] 'swapper' THREAD: c000000000aec000 CPU: 0
GPR00: c00000007e001030 c000000000aef910 c000000000aeae68 c000000000b32680=
=20
GPR04: c00000007e001000 c0000000009bf718 0000000000000002 c0000000009bf718=
=20
GPR08: 000000000000001a 0000000000000001 0000000000000000 0000000000000001=
=20
GPR12: 0000000088000084 c000000000b3b280 0000000000000000 0000000003500000=
=20
GPR16: c0000000006b4088 c0000000006b27e8 0000000000000000 00000000003d3800=
=20
GPR20: 0000000003cae870 c0000000007ae870 0000000000000010 0000000000000000=
=20
GPR24: c000000000b4d6f0 f000000003347488 c000000000b32680 f000000003347488=
=20
GPR28: c00000007e001180 c00000007e001000 c000000000a56788 f0000000033474a8=
=20
NIP [c000000000100524] .__slab_alloc_page+0x380/0x3dc
LR [c0000000001004f4] .__slab_alloc_page+0x350/0x3dc
Call Trace:
[c000000000aef910] [c0000000001004f4] .__slab_alloc_page+0x350/0x3dc (unrel=
iable)
[c000000000aef9d0] [c000000000100f14] .__remote_slab_alloc+0x60/0x138
[c000000000aefa80] [c00000000010284c] .__kmalloc_track_caller+0xb4/0x23c
[c000000000aefb30] [c0000000000df258] .kstrdup+0x4c/0x13c
[c000000000aefbd0] [c000000000128504] .alloc_vfsmnt+0xb0/0x178
[c000000000aefc70] [c00000000010dfdc] .vfs_kern_mount+0x40/0xf8
[c000000000aefd10] [c0000000007954a4] .sysfs_init+0x90/0x108
[c000000000aefdb0] [c00000000079409c] .mnt_init+0xbc/0x254
[c000000000aefe50] [c000000000793afc] .vfs_caches_init+0x150/0x184
[c000000000aefee0] [c000000000777a08] .start_kernel+0x420/0x48c
[c000000000aeff90] [c000000000008368] .start_here_common+0x1c/0x34
Instruction dump:
60000000 e93d0040 e97d0028 381d0030 7fa4eb78 e95d0030 7f43d378 39290001=20
396b0001 f93d0040 f97d0028 f95b0020 <fbea0008> fbfd0030 f81f0008 4bfffb59=20
---[ end trace 31fd0ba7d8756001 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Call Trace:
[c000000000aef2f0] [c00000000000fcb8] .show_stack+0x70/0x184 (unreliable)
[c000000000aef3a0] [c00000000005ace8] .panic+0x80/0x1b4
[c000000000aef440] [c00000000005f330] .do_exit+0x84/0x6f0
[c000000000aef500] [c0000000000242ac] .die+0x24c/0x27c
[c000000000aef5a0] [c00000000002c154] .bad_page_fault+0xb8/0xd4
[c000000000aef620] [c00000000000534c] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .__slab_alloc_page+0x380/0x3dc
    LR =3D .__slab_alloc_page+0x350/0x3dc
[c000000000aef9d0] [c000000000100f14] .__remote_slab_alloc+0x60/0x138
[c000000000aefa80] [c00000000010284c] .__kmalloc_track_caller+0xb4/0x23c
[c000000000aefb30] [c0000000000df258] .kstrdup+0x4c/0x13c
[c000000000aefbd0] [c000000000128504] .alloc_vfsmnt+0xb0/0x178
[c000000000aefc70] [c00000000010dfdc] .vfs_kern_mount+0x40/0xf8
[c000000000aefd10] [c0000000007954a4] .sysfs_init+0x90/0x108
[c000000000aefdb0] [c00000000079409c] .mnt_init+0xbc/0x254
[c000000000aefe50] [c000000000793afc] .vfs_caches_init+0x150/0x184
[c000000000aefee0] [c000000000777a08] .start_kernel+0x420/0x48c
[c000000000aeff90] [c000000000008368] .start_here_common+0x1c/0x34
Rebooting in 180 seconds..

I bisected it down to this:

commit d8895be47d51305a48dec818803679b9a640cef5
Author: Nick Piggin <npiggin@suse.de>
Date:   Tue Apr 14 18:50:58 2009 +0200

    mm: prompt slqb default for oldconfig
   =20
    Change Kconfig names for slab allocator choices to prod SLQB into being
    the default. Hopefully increasing testing base.
   =20
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

But that is just where CONFIG_SLQB gets turned on, so I further bisected
the slab tree down to this:

commit 13079b7881aa3b027e4babdff901765e88d7e216
Author: Nick Piggin <npiggin@suse.de>
Date:   Tue Feb 3 15:07:12 2009 +0100

    slqb: dynamic array allocations
   =20
    Implement dynamic allocation for SLQB per-cpu and per-node arrays. This
    should hopefully have minimal runtime performance impact, because altho=
ugh
    there is an extra level of indirection to do allocations, the pointer s=
hould
    be in the cache hot area of the struct kmem_cache.
   =20
    It's not quite possible to use dynamic percpu allocator for this: first=
ly,
    that subsystem uses the slab allocator. Secondly, it doesn't have good
    support for per-node data. If those problems were improved, we could us=
e it.
    For now, just implement a very very simple allocator until the kmalloc
    caches are up.
   =20
    On x86-64 with a NUMA MAXCPUS config, sizes look like this:
       text    data     bss     dec     hex filename
      29960  259565     100  289625   46b59 mm/slab.o
      34130  497130     696  531956   81df4 mm/slub.o
      24575 1634267  111136 1769978  1b01fa mm/slqb.o
      24845   13959     712   39516    9a5c mm/slqb.o + this patch
   =20
    SLQB is now 2 orders of magnitude smaller than it was, and an order of
    magnitude smaller than SLAB or SLUB (in total size -- text size has
    always been smaller). So it should now be very suitable for distro-type
    configs in this respect.
   =20
    As a side-effect the UP version of cpu_slab (which is embedded directly
    in the kmem_cache struct) moves up to the hot cachelines, so it need no
    longer be cacheline aligned on UP. The overall result should be a
    reduction in cacheline footprint on UP kernels.
   =20
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

Please wait, loading kernel...
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded at 04a00000, size: 3918 Kbytes
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.30-rc1-autokern1 (root@p6-10-p4-e0.ozla=
bs.ibm.com) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu=
2)) #1 SMP Fri Apr 24 09:45:10 UTC 2009
Calling ibm,client-architecture... done
command line: root=3D/dev/VolGroup00/LogVol00 ro console=3Dhvc0  autobench_=
args: root=3D/dev/sdb1 ABAT:1240566469 initcall_debug=20
memory layout at init:
  alloc_bottom : 0000000004dd4000
  alloc_top    : 0000000008000000
  alloc_top_hi : 0000000008000000
  rmo_top      : 0000000008000000
  ram_top      : 0000000008000000
instantiating rtas at 0x00000000074e6000... done
boot cpu hw idx 0000000000000000
starting cpu hw idx 0000000000000002... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000004ed5000 -> 0x0000000004ed661a
Device tree struct  0x0000000004ed7000 -> 0x0000000004ef0000
Calling quiesce...
returning from prom_init
Phyp-dump disabled at boot time
Using pSeries machine description
Using 1TB segments
Found initrd at 0xc000000004a00000:0xc000000004dd3800
console [udbg0] enabled
Partition configured for 4 cpus.
CPU maps initialized for 2 threads per core
Starting Linux PPC64 #1 SMP Fri Apr 24 09:45:10 UTC 2009
-----------------------------------------------------
ppc64_pft_size                =3D 0x19
physicalMemorySize            =3D 0x80000000
htab_hash_mask                =3D 0x3ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.30-rc1-autokern1 (root@p6-10-p4-e0.ozlabs.ibm.com) (gcc v=
ersion 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Fri Apr=
 24 09:45:10 UTC 2009
[boot]0012 Setup Arch
EEH: No capable adapters found
PPC64 nvram contains 15360 bytes
Zone PFN ranges:
  DMA      0x00000000 -> 0x00080000
  Normal   0x00080000 -> 0x00080000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    1: 0x00000000 -> 0x00080000
Could not find start_pfn for node 0
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 510976
Policy zone: DMA
Kernel command line: root=3D/dev/VolGroup00/LogVol00 ro console=3Dhvc0  aut=
obench_args: root=3D/dev/sdb1 ABAT:1240566469 initcall_debug=20
NR_IRQS:512
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
clocksource: timebase mult[7d0000] shift[22] registered
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 5119 kB
 per task-struct memory footprint: 2688 bytes
allocated 20971520 bytes of page_cgroup
please try cgroup_disable=3Dmemory option if you don't want
freeing bootmem node 1
Memory: 1967824k/2097152k available (9752k kernel code, 129328k reserved, 1=
420k data, 8422k bss, 2108k init)
Calibrating delay loop... 1021.95 BogoMIPS (lpj=3D2043904)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Unable to handle kernel paging request for data at address 0x00000008
Faulting instruction address: 0xc000000000100524
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D128 NUMA pSeries
Modules linked in:
NIP: c000000000100524 LR: c0000000001004f4 CTR: 0000000000000001
REGS: c000000000aef690 TRAP: 0300   Not tainted  (2.6.30-rc1-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 48000082  XER: 00000005
DAR: 0000000000000008, DSISR: 0000000042000000
TASK =3D c0000000009bedd0[0] 'swapper' THREAD: c000000000aec000 CPU: 0
GPR00: c00000007e001030 c000000000aef910 c000000000aeae68 c000000000b32680=
=20
GPR04: c00000007e001000 c0000000009bf718 0000000000000002 c0000000009bf718=
=20
GPR08: 000000000000001a 0000000000000001 0000000000000000 0000000000000001=
=20
GPR12: 0000000088000084 c000000000b3b280 0000000000000000 0000000003500000=
=20
GPR16: c0000000006b4088 c0000000006b27e8 0000000000000000 00000000003d3800=
=20
GPR20: 0000000003cae870 c0000000007ae870 0000000000000010 0000000000000000=
=20
GPR24: c000000000b4d6f0 f000000003347488 c000000000b32680 f000000003347488=
=20
GPR28: c00000007e001180 c00000007e001000 c000000000a56788 f0000000033474a8=
=20
NIP [c000000000100524] .__slab_alloc_page+0x380/0x3dc
LR [c0000000001004f4] .__slab_alloc_page+0x350/0x3dc
Call Trace:
[c000000000aef910] [c0000000001004f4] .__slab_alloc_page+0x350/0x3dc (unrel=
iable)
[c000000000aef9d0] [c000000000100f14] .__remote_slab_alloc+0x60/0x138
[c000000000aefa80] [c00000000010284c] .__kmalloc_track_caller+0xb4/0x23c
[c000000000aefb30] [c0000000000df258] .kstrdup+0x4c/0x13c
[c000000000aefbd0] [c000000000128504] .alloc_vfsmnt+0xb0/0x178
[c000000000aefc70] [c00000000010dfdc] .vfs_kern_mount+0x40/0xf8
[c000000000aefd10] [c0000000007954a4] .sysfs_init+0x90/0x108
[c000000000aefdb0] [c00000000079409c] .mnt_init+0xbc/0x254
[c000000000aefe50] [c000000000793afc] .vfs_caches_init+0x150/0x184
[c000000000aefee0] [c000000000777a08] .start_kernel+0x420/0x48c
[c000000000aeff90] [c000000000008368] .start_here_common+0x1c/0x34
Instruction dump:
60000000 e93d0040 e97d0028 381d0030 7fa4eb78 e95d0030 7f43d378 39290001=20
396b0001 f93d0040 f97d0028 f95b0020 <fbea0008> fbfd0030 f81f0008 4bfffb59=20
---[ end trace 31fd0ba7d8756001 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Call Trace:
[c000000000aef2f0] [c00000000000fcb8] .show_stack+0x70/0x184 (unreliable)
[c000000000aef3a0] [c00000000005ace8] .panic+0x80/0x1b4
[c000000000aef440] [c00000000005f330] .do_exit+0x84/0x6f0
[c000000000aef500] [c0000000000242ac] .die+0x24c/0x27c
[c000000000aef5a0] [c00000000002c154] .bad_page_fault+0xb8/0xd4
[c000000000aef620] [c00000000000534c] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .__slab_alloc_page+0x380/0x3dc
    LR =3D .__slab_alloc_page+0x350/0x3dc
[c000000000aef9d0] [c000000000100f14] .__remote_slab_alloc+0x60/0x138
[c000000000aefa80] [c00000000010284c] .__kmalloc_track_caller+0xb4/0x23c
[c000000000aefb30] [c0000000000df258] .kstrdup+0x4c/0x13c
[c000000000aefbd0] [c000000000128504] .alloc_vfsmnt+0xb0/0x178
[c000000000aefc70] [c00000000010dfdc] .vfs_kern_mount+0x40/0xf8
[c000000000aefd10] [c0000000007954a4] .sysfs_init+0x90/0x108
[c000000000aefdb0] [c00000000079409c] .mnt_init+0xbc/0x254
[c000000000aefe50] [c000000000793afc] .vfs_caches_init+0x150/0x184
[c000000000aefee0] [c000000000777a08] .start_kernel+0x420/0x48c
[c000000000aeff90] [c000000000008368] .start_here_common+0x1c/0x34
Rebooting in 180 seconds..

--Signature=_Sat__25_Apr_2009_00_52_06_+1000_H2tL0sy5U.X4UDNr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknx0hYACgkQjjKRsyhoI8xKPACfaebeJb7anvJsH5a0XsdPtB/o
TtMAoKiyZJZjnLctse+FCVmt/wYmD196
=9YTI
-----END PGP SIGNATURE-----

--Signature=_Sat__25_Apr_2009_00_52_06_+1000_H2tL0sy5U.X4UDNr--
