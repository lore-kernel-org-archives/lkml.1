Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbYBOV2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbYBOV2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYBOV2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:28:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbYBOV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:28:38 -0500
Date: Fri, 15 Feb 2008 13:23:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc2
Message-ID: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok,
 this kernel is a winner.

Just to show how _much_ of a winner it is, it's been awarded a coveted 
"weasel" series name, which should tell you just how good it's going to 
be. It's a name revered in Linux kernel history, and as such this brings 
back the good old days where if you find a bug, you're almost certainly 
simply mistaken, and you probably just did something wrong.

But hey, you can try to prove me wrong.  I dare you.

The full shortlog is appended, but instead of a diffstat, I'm doing the my 
git "dirstat" output which gives a nicer high-level view. This was 
generated with

	git diff --cumulative --dirstat=2 --shortstat v2.6.25-rc1..v2.6.25-rc2

and actually gives a pretty good overview. In particular, it shows that 
almost exactly half of the updates are to drivers, with network drivers 
alone being a third of the whole patch. And of the remaining half, about 
half was architecture updates, notably to SH.

What a cool git feature, if I say so myself. It allows me an extra half 
hour a week of just sitting back and sipping my foofy tropical drink 
(bringing my total up to about 168.5 hours of drunken stupor a week), 
since now I don't even have to try to make sense of the diffstat manually 
any more. Anyway, here it is:

	   2.1% Documentation/
	   3.7% arch/cris/
	   7.0% arch/sh/configs/
	   4.4% arch/sh/kernel/
	   4.9% arch/sh/mm/
	  17.8% arch/sh/
	  23.8% arch/
	  33.5% drivers/net/
	   6.0% drivers/scsi/lpfc/
	   7.1% drivers/scsi/
	   4.5% drivers/sh/maple/
	  49.5% drivers/
	   8.1% fs/
	   2.5% include/linux/
	   4.5% include/
	   7.2% kernel/
	   2.0% net/
	 509 files changed, 14470 insertions(+), 6986 deletions(-)

which you have to admit looks very managerial, even if you have no clue 
what the heck it really contains (which is also very managerial). Now I 
just need to turn these reports into some colored powerpoint slides with 
pie charts, and then I can turn off my brain _completely_.

But if you actually care for anything but the pretty statistics, here's 
the shortlog too. The most interesting part from a core technical side is 
probably the "struct path" cleanups that really should have been in -rc1, 
but hey, when Andrew slides a bit, I just let him.

But "Quod licet Jovi, non licet bovi", so don't think that applies to 
anybody else.

So sh, some driver updates, some VFS cleanups, and a random set of fixups 
for all the stuff that happened in -rc1 (and some that happened before). 

I'm optimistic that this release cycle won't be anywhere near the pain of 
what 24 was, which is why I'm just going to go off for the long weekend 
and stay at the beach.

Be nice now. I'll be sipping my Mai Tai. With an umbrella (*).

		Linus

(*) But in Oregon, we don't do the small cute paper umbrellas. We do the 
big serious ones, to make sure our drinks don't get too watered down!

Ahh, the Oregon beach in February.

---
Adrian Bunk (15):
      ide: fix ide/legacy/gayle.c compilation
      net/phy/fixed.c: fix a use-after-free
      [INET]: Unexport __inet_hash_connect
      [INET]: Unexport inet_listen_wlock
      [NETFILTER]: make secmark_tg_destroy() static
      thinkpad_acpi: static
      ACPI: static acpi_no_initrd_override_setup()
      ACPI: static acpi_find_dsdt_initrd()
      ACPI: static acpi_chain_head
      [POWERPC] vdso_do_func_patch{32,64}() must be __init
      [POWERPC] free_property() must not be __init
      [POWERPC] hvc_rtas_init() must be __init
      x86: make dump_pagetable() static
      make slub.c:slab_address() static
      fix module_update_markers() compile error

Adrian McMenamin (5):
      8139too fix for Dreamcast
      maple: fix up whitespace damage.
      maple: more robust device detection.
      maple: Drop unused prototypes from linux/maple.h.
      maple: improve detection of attached peripherals

Ahmed S. Darwish (1):
      Smack: check for 'struct socket' with NULL sk

Al Viro (3):
      wmi: (!x & y) strikes again
      dm-raid1 breakage on 64bit
      drivers/memstick/host/tifm_ms.c breakage

Alan Cox (5):
      ni52: Remove 278 scripts/checkpatch errors
      pata_amd: Note in the module description it handles Nvidia
      pata_legacy: typo fix
      pata_ninja32: setup changes
      sh: termios ioctl definitions

Andi Kleen (3):
      Prevent IDE boot ops on NUMA system
      Make topology fallback macros reference their arguments.
      x86: CPA: fix gbpages support in try_preserve_large_page

Ayaz Abdulla (2):
      forcedeth: tx collision fix
      forcedeth: tx pause watermarks

Balbir Singh (1):
      KVM is not seen under X86 config with latest git (32 bit compile)

Bartlomiej Zolnierkiewicz (12):
      palm_bk3710: ide_register_hw() -> ide_device_add()
      palm_bk3710: fix ide_unregister() usage
      palm_bk3710: port initialization/probing bugfix
      palm_bk3710: use struct ide_port_info
      pdc202xx_old: always enable burst mode
      ide: remove stale version number
      ide-tape: remove never executed code
      bast-ide: build fix
      ide-disk: fix flush requests (take 2)
      ide: ide_init_port() bugfix
      ide: fix comment in init_irq()
      ide: remove stale comment from ide-lib.c

Ben Dooks (24):
      DM9000: Fix endian-ness of data accesses.
      DM9000: Add platform data to specify external phy
      DM9000 use dev_xxx() instead of printk for output.
      DM9000 update debugging macros to use debug level
      DM9000: Pass IRQ flags via platform resources
      DM9000: Remove old timer based poll routines
      DM9000: Add initial ethtool support
      DM9000: Do not sleep with spinlock and IRQs held
      DM9000: Use msleep() instead of udelay()
      DM9000: Remove barely used SROM array read.
      DM9000: Add mutex to protect access
      DM9000: Add ethtool support for reading and writing EEPROM
      DM9000: Add ethtool control of msg_enable value
      DM9000: Remove EEPROM initialisation code.
      DM9000: Ensure spinlock held whilst accessing EEPROM registers
      DM9000: Remove unnecessary changelog in header comment
      DM9000: Use netif_msg to enable debugging options
      DM9000: Fix delays used by EEPROM read and write
      DM9000: Remove cal_CRC() and use ether_crc_le instead
      DM9000: Remove redudant use of "& 0xff"
      DM9000: Add platform flag for no attached EEPROM
      DM9000: Add support for MII ioctl() calls
      DM9000: Update retry count whilst identifying chip
      DM9000: Show the MAC address source after printing MAC

Ben Nizette (1):
      Include kernel.h from configfs.h

Benjamin Herrenschmidt (2):
      cs5520: remove stale comment
      e1000: Fix for 32 bits platforms with 64 bits resources

Boaz Harrosh (3):
      [SCSI] fas216: Use scsi_eh API for REQUEST_SENSE invocation
      [SCSI] aic94xx: fix ABORT_TASK define conflict
      [SCSI] gdth: scan for scsi devices

Borislav Petkov (1):
      ide-cd: replace ntohs with generic byteorder macro be16_to_cpu

Byron Bradley (1):
      sata_mv: platform driver allocs dma without create

Christine Caulfield (1):
      MAINTAINERS: update decnet and DLM entries

Christoph Lameter (4):
      slub: Determine gfpflags once and not every time a slab is allocated
      slub: Fallback to kmalloc_large for failing higher order allocs
      slub: Support 4k kmallocs again to compensate for page allocator slowness
      dentries: Extract common code to remove dentry from lru

Chuck Lever (1):
      NFS: Allow text-based mounts via compat_sys_mount

Cornelia Huck (1):
      netiucv: Remember to set driver->owner.

Dan Muntz (1):
      NFS: missing spaces in KERN_WARNING

David Brownell (1):
      parport: section fixup

David Howells (1):
      FRV: Fix up parse error in linker script

David Newall (1):
      hci_ldisc: fix null pointer deref

David S. Miller (2):
      [IPV4]: Remove IP_TOS setting privilege checks.
      [NDISC]: Fix race in generic address resolution

Don Fry (2):
      pcnet32: use NET_IP_ALIGN instead of 2
      pcnet32: Use print_mac

Eli Cohen (1):
      IPoIB: Remove unused struct ipoib_cm_tx.ibwc member

FUJITA Tomonori (1):
      [SCSI] advansys: fix overrun_buf aligned bug

Florian Fainelli (4):
      r6040: do not use a private stats structure to store statistics
      r6040: add helpers to allocate and free the Tx/Rx buffers
      r6040: recover from transmit timeout
      r6040: cleanups

Geoff Levand (4):
      [POWERPC] PS3: Fix bootwrapper hang bug
      [POWERPC] PS3: Use system reboot on restart
      [POWERPC] PS3: Sys-manager code cleanup
      [POWERPC] PS3: Update sys-manager button events

Grant Likely (1):
      [POWERPC] Remove unused CONFIG_WANT_DEVICE_TREE

Greg Ungerer (3):
      m68knommu: avoid unneccessary use of xchg() in set_mb()
      m68knommu: use asflags instead of EXTRA_AFLAGS
      m68knommu: use tabs not spaces in cacheflush.h

H. Peter Anvin (1):
      timeconst.pl: correct reversal of USEC_TO_HZ and HZ_TO_USEC

Harvey Harrison (7):
      x86: pit_clockevent can be static
      include/linux: Remove all users of FASTCALL() macro
      remove final fastcall users
      Final removal of FASTCALL()/fastcall
      x86: include proper prototypes for rodata_test
      inotify: make variables static in inotify_user.c
      kernel-doc: remove fastcall

Herbert Xu (3):
      [IPV6]: Fix IPsec datagram fragmentation
      [IPSEC]: Fix bogus usage of u64 on input sequence number
      [IPV6]: Fix reversed local_df test in ip6_fragment

Hideo Saito (1):
      sh: Fix multiple UTLB hit on UP SH-4.

Huang, Ying (1):
      x86: EFI runtime code mapping enhancement

Hugh Dickins (1):
      [POWERPC] Fix DEBUG_PREEMPT warning when warning

Ingo Molnar (5):
      x86: fix sigcontext.h user export
      x86: fix "BUG: sleeping function called from invalid context" in print_vma_addr()
      x86: EFI set_memory_x()/set_memory_uc() fixes
      x86: fix gart_iommu_init()
      x86: cpa, fix out of date comment

Ivan Kokshaysky (1):
      moduleparam: fix alpha, ia64 and ppc64 compile failures

J. Bruce Fields (2):
      nfsd: clean up svc_reserve_auth()
      Documentation: prune redundant SubmitChecklist items

Jack Morgenstein (3):
      IPoIB: On P_Key change event, reset state properly
      IB/mlx4: mlx4_ib_fmr_alloc() should call mlx4_fmr_enable()
      mlx4_core: Move table_find from fmr_alloc to fmr_enable

James Bottomley (2):
      [SCSI] update SG_ALL to avoid causing chaining
      [SCSI] sym53c416: fix module parameters

James Smart (6):
      [SCSI] lpfc 8.2.5 : Correct ndlp referencing issues
      [SCSI] lpfc 8.2.5 : Miscellaneous Fixes
      [SCSI] lpfc 8.2.5 : Add MSI-X single message support
      [SCSI] lpfc 8.2.5 : Miscellaneous discovery Fixes
      [SCSI] lpfc 8.2.5 : Fix buffer leaks
      [SCSI] lpfc 8.2.5 : Update lpfc driver version to 8.2.5

Jan Blunck (19):
      Dont touch fs_struct in drivers
      Dont touch fs_struct in usermodehelper
      Remove path_release_on_umount()
      Move struct path into its own header
      Embed a struct path into struct nameidata instead of nd->{dentry,mnt}
      Introduce path_put()
      Use path_put() in a few places instead of {mnt,d}put()
      Introduce path_get()
      Use struct path in fs_struct
      Make set_fs_{root,pwd} take a struct path
      One less parameter to __d_path
      d_path: kerneldoc cleanup
      d_path: Use struct path in struct avc_audit_data
      d_path: Make proc_get_link() use a struct path argument
      d_path: Make get_dcookie() use a struct path argument
      Use struct path in struct svc_export
      Use struct path in struct svc_expkey
      d_path: Make seq_path() use a struct path argument
      d_path: Make d_path() use a struct path

Jan Kara (2):
      udf: fix directory offset handling
      vfs: add explanation of I_DIRTY_DATASYNC bit

Jarek Poplawski (4):
      [AX25] af_ax25: remove sock lock in ax25_info_show()
      [AX25] ax25_route: make ax25_route_lock BH safe
      [AX25] ax25_timer: use mod_timer instead of add_timer
      [AX25] ax25_ds_timer: use mod_timer instead of add_timer

Jeff Layton (6):
      NLM: set RPC_CLNT_CREATE_NOPING for NLM RPC clients
      NLM: have server-side RPC clients default to soft RPC tasks
      NLM: don't reattempt GRANT_MSG when there is already an RPC in flight
      NLM: don't requeue block if it was invalidated while GRANT_MSG was in flight
      NFS: fix reference counting for NFSv4 callback thread
      NFS: remove error field from nfs_readdir_descriptor_t

Jeremy Fitzhardinge (2):
      x86/early_ioremap: don't assume we're using swapper_pg_dir
      xen: unpin initial Xen pagetable once we're finished with it

Jeremy Roberson (1):
      HID: Blacklist new GTCO CalComp USB device PIDs

Jesper Nilsson (1):
      cris: import memset.c from newlib: fixes compile error with newer (pre4.3) gcc

Jiri Kosina (2):
      HID: fix processing of event quirks
      HID: add LCSPEC from VERNIER to quirk list

Jody Belka (1):
      x86: fixup machine_ops reboot_{32|64}.c unification fallout

Jonathan Corbet (1):
      Be more robust about bad arguments in get_user_pages()

Jozsef Kadlecsik (1):
      [NETFILTER] nf_conntrack_proto_tcp.c: Mistyped state corrected.

KOSAKI Motohiro (1):
      mempolicy: silently restrict nodemask to allowed nodes

Kazunori MIYAZAWA (1):
      [AF_KEY]: Fix bug in spdadd

Keiichi KII (1):
      netconsole: avoid null pointer dereference at show_local_mac()

Kiyoshi Ueda (1):
      ide: another possible ide panic fix for blk-end-request

Krishna Kumar (1):
      Optimize cxgb3 xmit path (a bit)

Kristoffer Ericson (1):
      sh: Tidy include/asm-sh/hp6xx.h

Kumar Gala (1):
      [POWERPC] Remove generated files on make clean

Laszlo Attila Toth (1):
      [RTNETLINK]: Send a single notification on device state changes.

Len Brown (2):
      ACPI: DMI blacklist updates
      ACPI: DMI: quirk for FSC ESPRIMO Mobile V5505

Linus Torvalds (3):
      WMI: initialize wmi_blocks.list even if ACPI is disabled
      acpi: fix acpi_os_read_pci_configuration() misuse of raw_pci_read()
      Linux 2.6.25-rc2

Magnus Damm (18):
      sh: declared coherent memory support V2 fix
      sh: add sh7722 support to EARLY_SCIF_CONSOLE
      sh: add probe support for new sh7722 cut
      sh: break out unaligned sign extension code
      sh: migor board support
      sh: make copy_to/from_user() static inline
      sh: add byte support to the sign extension code
      sh: use opcode_t and enable unaligned code for sh2a
      sh: update r2d defconfigs with usb, spi and rtc
      sh: trapped io support V2
      sh: trapped io support for r2d V2
      sh: trapped io support for highlander V2
      sh: fix ptrace copy_from/to_user() compilation error
      sh: remove maskreg irq code
      sh: add support for sh7366 processor
      sh: use ctrl_in/out for on chip pci access
      sh: fix ioreadN_rep and iowriteN_rep
      sh: fix pci io access for r2d boards

Marcin Slusarz (4):
      IB/mthca: Convert to use be16_add_cpu()
      xfs: convert beX_add to beX_add_cpu (new common API)
      udf: fix udf_add_free_space
      slab: avoid double initialization & do initialization in 1 place

Masakazu Mokuno (7):
      PS3: gelic: Fix the wrong dev_id passed
      PS3: gelic: Add endianness macros
      PS3: gelic: code cleanup
      PS3: gelic: remove duplicated ethtool handlers
      PS3: gelic: add support for port link status
      PS3: gelic: Add support for dual network interface
      PS3: gelic: Add wireless support for PS3

Mathieu Desnoyers (2):
      Linux Kernel Markers: support multiple probes
      Linux Kernel Markers: create modpost file

Matt Waddel (1):
      m68knommu: fix profile timer

Matthew Wilcox (1):
      Use proper abstractions in quirk_intel_irqbalance

Matti Linnanvuori (1):
      [NET]: Fix race in dev_close(). (Bug 9750)

Michael Ellerman (1):
      [POWERPC] Cell RAS: Remove DEBUG, and add license and copyright

Michael Opdenacker (1):
      Documentation: sysctl/kernel.txt: fix documentation reference

Mike Frysinger (1):
      FLAT binaries: drop BINFMT_FLAT bad header magic warning

Neil Turton (1):
      [NET]: Improve cache line coherency of ingress qdisc

Nishanth Aravamudan (1):
      hugetlb: fix overcommit locking

Olga Kornievskaia (1):
      NFS: add missing spkm3 strings to mount option parser

Olof Johansson (1):
      mlx4_core: Fix build break (missing include)

Paul E. McKenney (1):
      rcupdate: fix comment

Paul Menage (1):
      MAINTAINERS: add linux-fsdevel to VFS entry

Paul Mundt (21):
      pcmcia: ipwireless depends on NETDEVICES
      sh: Wire up new timerfd syscalls.
      sh: Add mach-type entries for MigoR and SDK7780.
      sh: Use max_t in io_trapped.
      sh: Clean up whitespace damage in Kconfig.debug.
      sh: Symbol exports for trapped I/O.
      sh: Handle SH7366 CPU in check_bugs().
      sh: Disable big endian for SH-5.
      sh: Fix up pte_mkhuge() build breakage for SH-5.
      sh: Fix up set_fixmap_nocache() for SH-5.
      sh: Update SH-5 flush_cache_sigtramp() for API changes.
      sh: Shut up some trivial build warnings.
      sh: asm/tlb.h needs linux/pagemap.h for CONFIG_SWAP=n.
      sh: Kill off bogus SH_SDK7780_STANDALONE symbol.
      maple: Fix up maple build failure.
      sh: Get SH-5 caches working again post-unification.
      serial: sh-sci: Fix up SH-5 build.
      sh: asm/irq.h needs asm/cpu/irq.h.
      sh: __uncached_start only on sh32.
      sh: Kill off more dead symbols.
      net: xfrm statistics depend on INET

Pavel Emelyanov (5):
      [NETLABEL]: Fix lookup logic of netlbl_domhsh_search_def.
      [GENETLINK]: Relax dances with genl_lock.
      [NETLABEL]: Compilation for CONFIG_AUDIT=n case.
      [NETLABEL]: Don't produce unused variables when IPv6 is off.
      [NETLABLE]: Hide netlbl_unlabel_audit_addr6 under ifdef CONFIG_IPV6.

Pekka Enberg (2):
      Add Matt to MAINTAINERS as a SLAB allocator maintainer
      slub: kmalloc page allocator pass-through cleanup

Peter Tiedemann (2):
      lcs: avoid/reduce unused s390dbf debug areas.
      claw/lcs/netiucv: check s390dbf level before sprints

Peter Zijlstra (10):
      hrtimer: more hrtimer_init_sleeper() fallout.
      sched: fair-group: separate tg->shares from task_group_lock
      sched: fix incorrect irq lock usage in normalize_rt_tasks()
      sched: rt-group: deal with PI
      sched: rt-group: interface
      sched: rt-group: make rt groups scheduling configurable
      sched: rt-group: clean up the ifdeffery
      sched: rt-group: refure unrunnable tasks
      xtime_lock vs update_process_times
      sh: fix xtime_lock deadlocking.

Prakash, Sathya (2):
      [SCSI] mpt fusion: Avoid racing when mptsas and mptcl module are loaded in parallel
      [SCSI] mpt fusion: Request I/O resources only when required

Rafael J. Wysocki (1):
      ACPI suspend: Execute _WAK with the right argument

Rami Rosen (1):
      [IPV6]: remove unused method declaration (net/ndisc.h).

Randy Dunlap (5):
      kernel-doc: fix fs/pipe.c notation
      docbook: move pipe and splice to filesystems docbook
      docbook: sunrpc filenames and notation fixes
      docbook: make a networking book and fix a few errors
      docbook: drop z85230 library from kernel-api

Roel Kluin (1):
      pnpacpi: __initdata is not an identifier

Roland Dreier (4):
      SUNPRC: Fix printk format warning
      IB/mthca: Add missing sg_init_table() in mthca_map_user_db()
      IB/cm: Remove debug printk()s that snuck upstream
      IB/cm: Fix infiniband_cm class kobject ref counting

Roland McGrath (1):
      x86: vdso_install fix

Rémi Denis-Courmont (1):
      [NET]: Make sure sockets implement splice_read

Salyzyn, Mark (3):
      [SCSI] aacraid: add optional MSI support
      [SCSI] aacraid: ignore adapter reset check polarity
      [SCSI] aacraid: informational sysfs value corrections

Sam Ravnborg (1):
      kbuild: fix make V=1

Sean Hefty (1):
      RDMA/cma: Do not issue MRA if user rejects connection request

Sergei Shtylyov (2):
      ide: insert BUG_ON() into __ide_set_handler() (take 2)
      ide: introduce CONFIG_BLK_DEV_IDEDMA_SFF option

Sergio Luis (3):
      drivers/net/sis190: fix section mismatch warning in sis190_get_mac_addr
      [SCSI] gdth: update deprecated pci_find_device
      fs/smbfs/inode.c: fix warning message deprecating smbfs

Stefan Roese (1):
      [POWERPC] Fix arch/ppc compilation - add typedef for pgtable_t

Stephen Hemminger (2):
      fib_trie: handle empty tree
      fib_trie: /proc/net/route performance improvement

Stephen Rothwell (2):
      sh: remove unneeded cast
      [POWERPC] Wire up new timerfd syscalls

Stephen Smalley (1):
      selinux: support 64-bit capabilities

Steve Wise (2):
      cxgb3: Handle ARP completions that mark neighbors stale.
      RDMA/cxgb3: Fail loopback connections

Takashi Yamamoto (2):
      [POWERPC] PS3: Fix setting bookmark in logical performance monitor
      [POWERPC] PS3: Fix reading pm interval in logical performance monitor

Tejun Heo (2):
      pata_via: fix SATA cable detection on cx700
      libata: ignore deverr on SETXFER if mode is configured

Thomas Bogendoerfer (1):
      SC26XX: missing PORT define in serial_core.h

Thomas Gleixner (5):
      x86: remove over noisy debug printk
      x86: EFI: fix use of unitialized variable and the cache logic
      hrtimer: check relative timeouts for overflow
      hrtimer: catch expired CLOCK_REALTIME timers early
      x86: cpa: ensure page alignment

Thomas Horsten (1):
      [SCSI] MegaRAID driver management char device moved to misc

Tobias Mueller (1):
      HID: add USB IDs for MacBook 3rd generation

Tony Breeds (1):
      Fix compile of swim3 as module

Tony Luck (1):
      [IA64] Fix build for sim_defconfig

Urs Thuermann (1):
      [NET]: Fix comment for skb_pull_rcsum

Ursula Braun (2):
      claw: removal of volatile variables
      netiucv: change name of nop function

Venkatesh Pallipadi (3):
      ACPI: fix suspend regression due to idle update
      ACPI, cpuidle: Clarify C-state description in sysfs
      cpuidle: Add Documentation

Walter T Gruczka (1):
      m68knommu: fix coldfire interrupt exit path

YOSHIFUJI Hideaki (1):
      [XFRM]: Avoid bogus BUG() when throwing new policy away.

Yinghai Lu (2):
      [SCSI] ses: fix memory leaks
      sata_mv: fix loop with last port

