Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab0BLTtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:49:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757093Ab0BLTtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:49:53 -0500
Date: Fri, 12 Feb 2010 11:49:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33-rc8
Message-ID: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think this is going to be the last -rc of the series, so please do test 
it out. A number of regressions should be fixed, and while the regression 
list doesn't make me _happy_, we didn't have the kind of nasty things that 
went on before -rc7 and made me worried.

Some of the highlights inclure a netfilter/namespace bugfix, which 
apparently got visibility now that a number of distributions seem to have 
turned on the network namespace code. And more KMS regression fixes for 
all the usual suspects - intel, nouveau, radeon (hopefully not causing 
anything new).

The rest is random stuff all over. Mostly one-liners, except for a 
defconfig update for mips (that also show up in the dirstat). 

		Linus

---
  17.3% arch/mips/configs/
  17.8% arch/mips/
  22.9% arch/
   2.4% drivers/char/tpm/
   2.5% drivers/char/
  13.7% drivers/gpu/drm/i915/
  11.4% drivers/gpu/drm/nouveau/
   3.9% drivers/gpu/drm/radeon/
   2.0% drivers/gpu/drm/vmwgfx/
  31.1% drivers/gpu/drm/
  31.2% drivers/gpu/
  43.0% drivers/
   6.3% fs/ocfs2/dlm/
  12.7% fs/ocfs2/
  18.4% fs/
   3.9% net/netfilter/
   9.0% net/
   3.4% security/integrity/ima/
   3.4% security/


---
Aaro Koskinen (1):
      OMAP: hsmmc: fix memory leak

Abhijith Das (1):
      GFS2: Fix error code

Al Viro (3):
      befs: fix leak
      Take ima_path_check() in nfsd past dentry_open() in nfsd_open()
      Take ima_file_free() to proper place.

Alexander Duyck (1):
      igb: make certain to reassign legacy interrupt vectors after reset

Alexey Dobriyan (4):
      af_key: fix netns ops ordering on module load/unload
      netlink: fix for too early rmmod
      netfilter: nf_conntrack: restrict runtime expect hashsize modifications
      netfilter: xtables: compat out of scope fix

Amit Kumar Salecha (2):
      netxen: fix tx timeout recovery for NX2031 chip
      netxen: protect resource cleanup by rtnl lock

Anatolij Gustschin (1):
      dmaengine: fix memleak in dma_async_device_unregister

Andreas Schwab (1):
      compat_ioctl: add compat handler for TIOCGSID ioctl

Andy Getzendanner (1):
      vgaarb: fix incorrect dereference of userspace pointer.

Andy Shevchenko (1):
      x86, doc: Fix minor spelling error in arch/x86/mm/gup.c

Aneesh Kumar K.V (1):
      9p: Fix the kernel crash on a failed mount

Anirban Chakraborty (1):
      [SCSI] qla2xxx: Obtain proper host structure during response-queue processing.

Anton Blanchard (1):
      ixgbe: Fix ixgbe_tx_map error path

Arnd Bergmann (1):
      compat_ioctl: ignore RAID_VERSION ioctl

Ben Skeggs (5):
      drm/nouveau: fix non-vram notifier blocks
      drm/nv40: make INIT_COMPUTE_MEM a NOP, just like nv50
      drm/nouveau: make dp auxch xfer len check for reads only
      drm/nv50: prevent multiple init tables being parsed at the same time
      drm/nv50: disregard dac outputs in nv50_sor_dpms()

Borislav Petkov (1):
      amd64_edac: Do not falsely trigger kerneloops

Chris Wilson (1):
      drm/i915: Increase fb alignment to 64k

Dan Williams (1):
      ioat: fix infinite timeout checking in ioat2_quiesce

Daniel Vetter (1):
      drm/i915: Update write_domains on active list after flush.

Dave Airlie (5):
      drm/radeon/kms: change Kconfig text to reflect the new option.
      drm/radeon/kms: don't crash if no DDC bus on VGA/DVI connector.
      drm/radeon/kms: add quirk for VGA without DDC on rv730 XFX card.
      drm/radeon/kms: fix screen clearing before fbcon.
      drm/radeon/kms: retry auxch on 0x20 timeout value.

David Daney (2):
      MIPS: Fix __devinit __cpuinit confusion in cpu_cache_init
      MIPS: Don't probe reserved EntryHi bits.

David Gibson (1):
      powerpc: Fix address masking bug in hpte_need_flush()

David S. Miller (2):
      sparc: Align clone and signal stacks to 16 bytes.
      sparc32: Fix thinko in previous change.

Divy Le Ray (1):
      cxgb3: fix GRO checksum check

Dmitry Torokhov (1):
      Input: psmouse - make sure we don't schedule reconnects after cleanup

Eric Dumazet (2):
      netfilter: nf_conntrack: per netns nf_conntrack_cachep
      dst: call cond_resched() in dst_gc_task()

Eric Paris (1):
      ima: initialize ima before inodes can be allocated

Eric Van Hensbergen (6):
      net/9p: fix virtio transport to correctly update status on connect
      net/9p: fail when user specifies a transport which we can't find
      net/9p: fix statsize inside twstat
      9p: fix option parsing
      9p: fix memory leak in v9fs_parse_options()
      9p: fix p9_client_destroy unconditional calling v9fs_put_trans

FUJITA Tomonori (2):
      x86/agp: Fix amd64-agp module initialization regression
      [SCSI] compat_ioct: fix bsg SG_IO

Francesco Lavra (1):
      V4L/DVB: dvb-core: fix initialization of feeds list in demux filter

Francisco Jerez (1):
      drm/nouveau: Fixup semaphores on pre-nv50 cards.

Gerrit Renker (2):
      dccp: fix bug in cache allocation
      dccp: fix auto-loading of dccp(_probe)

Guennadi Liakhovetski (1):
      async-tx: fix buffer submission error handling in ipu_idma.c

Hans-Christian Egtvedt (1):
      avr32: clean up memory allocation in at32_add_device_mci

Heiko Carstens (1):
      [S390] Fix struct _lowcore layout.

J. Bruce Fields (1):
      Revert "nfsd4: fix error return when pseudoroot missing"

Jakob Bornecrantz (2):
      drm/vmwgfx: Report propper framebuffer_{max|min}_{width|height}
      drm/vmwgfx: Drop scanout flag compat and add execbuf ioctl parameter members. Bumps major.

Jan Glauber (1):
      [S390] qdio: prevent call trace if CHPID is offline

Jan Luebbe (1):
      net/sched: Fix module name in Kconfig

Jason Wang (2):
      Export the symbol of getboottime and mmonotonic_to_bootbased
      kvmclock: count total_sleep_time when updating guest clock

Jean Delvare (1):
      i2c-tiny-usb: Fix on big-endian systems

Jeff Layton (2):
      cifs: fix length calculation for converted unicode readdir names
      cifs: fix dentry hash calculation for case-insensitive mounts

Jesse Barnes (3):
      drm/i915: handle FBC and self-refresh better
      drm/i915: untangle page flip completion
      drm/i915: hold ref on flip object until it completes

Jody Bruchon (1):
      ALSA: hda-intel: Avoid divide by zero crash

Joe Perches (1):
      MAINTAINERS: networking drivers - Add git net-next tree

Johan Kristell (1):
      mmc_test: block addressed cards

Julia Lawall (4):
      drivers/gpu/drm/nouveau/nouveau_grctx.c: correct NULL test
      drivers/net: Correct NULL test
      drivers/dma: Correct NULL test
      MIPS: SNI: Correct NULL test

Jun'ichi Nomura (1):
      freeze_bdev: don't deactivate successfully frozen MS_RDONLY sb

Kashyap, Desai (1):
      [SCSI] mptfusion : mptscsih_abort return value should be SUCCESS instead of value 0.

Krishna Kumar (1):
      ixgbe: Fix return of invalid txq

Kyle McMartin (1):
      parisc: fix tracing of signals

Linus Torvalds (2):
      Fix race in tty_fasync() properly
      Linux 2.6.33-rc8

Luca Barbieri (1):
      drm/nouveau: call ttm_bo_wait with the bo lock held to prevent hang

M. Mohan Kumar (1):
      9p: Include fsync support for 9p client

Maarten Maathuis (4):
      drm/nv50: align size of buffer object to the right boundaries.
      drm/nv50: avoid unloading pgraph context when ctxprog is running
      drm/nv50: delete ramfc object after disabling fifo, not before
      drm/nv50: make the pgraph irq handler loop like the pre-nv50 version

Marcel Holtmann (1):
      Bluetooth: Fix sleeping function in RFCOMM within invalid context

Marcel Selhorst (1):
      tpm_infineon: fix suspend/resume handler for pnp_driver

Marcelo Tosatti (1):
      KVM: PIT: control word is write-only

Marcin Ko¶cielnicki (4):
      drm/nouveau: Add module options to disable acceleration.
      drm/nouveau: Add getparam to get available PGRAPH units.
      drm/nouveau: Fix fbcon on mixed pre-NV50 + NV50 multicard.
      drm/nouveau: Add proper vgaarb support.

Marcin Slusarz (1):
      drm/nouveau: move dereferences after null checks

Mark Brown (2):
      wm97xx_battery: Handle missing platform data gracefully
      regulator: Fix display of null constraints for regulators

Mark Nelson (1):
      powerpc/pseries: Fix kexec regression caused by CPPR tracking

Matt Fleming (4):
      sh: Correct the offset of the return address in ret_from_exception
      sh: Setup frame pointer in handle_exception path
      sh: Don't continue unwinding across interrupts
      sh: Remove superfluous setup_frame_reg call

Matthew Garrett (1):
      nouveau: fix state detection with switchable graphics

Mauro Carvalho Chehab (2):
      V4L/DVB: Fix the risk of an oops at dvb_dmx_release
      V4L/DVB: dvb_demux: Don't use vmalloc at dvb_dmx_swfilter_packet

Michael Neuling (1):
      fs/exec.c: restrict initial stack space expansion to rlimit

Michael Poole (1):
      Bluetooth: Keep a copy of each HID device's report descriptor

Michal Simek (1):
      microblaze: Invalidate dcache before enabling it

Mike Frysinger (1):
      [CPUFREQ] fix default value for ondemand governor

Mimi Zohar (3):
      fix ima breakage
      ima: rename ima_path_check to ima_file_check
      ima: rename PATH_CHECK to FILE_CHECK

Nagananda.Chumbalkar@hp.com (1):
      [CPUFREQ] Fix ondemand to not request targets outside policy limits

NeilBrown (2):
      md: fix 'degraded' calculation when starting a reshape.
      md: fix some lockdep issues between md and sysfs.

Nick Pelly (3):
      Bluetooth: Fallback eSCO to SCO on error 0x1a (Unsupported Remote Feature)
      Bluetooth: Do not call rfcomm_session_put() for RFCOMM UA on closed socket
      Bluetooth: Enter active mode before establishing a SCO link.

OGAWA Hirofumi (1):
      ocfs2: Fix refcnt leak on ocfs2_fast_follow_link() error path

Owain Ainsworth (1):
      drm/i915: Correctly return -ENOMEM on allocation failure in cmdbuf ioctls.

Patrick McHardy (2):
      netfilter: nf_conntrack: fix memory corruption with multiple namespaces
      netfilter: nf_conntrack: fix hash resizing with namespaces

Paul Mundt (2):
      usb: r8a66597-hcd: Flush the D-cache for the pipe-in transfer buffers.
      usb: r8a66597-hcd: Fix up spinlock recursion in root hub polling.

Pauli Nieminen (1):
      drm/radeon: Skip dma copy test in benchmark if card doesn't have dma engine.

Peter Huewe (1):
      arch/avr32: Fix build failure for avr32 caused by typo

Peter Tyser (2):
      edac: mpc85xx fix bad page calculation
      edac: mpc85xx fix build regression by removing unused debug code

Rafael J. Wysocki (2):
      pktgen: Fix freezing problem
      drm/i915: Fix crash while aborting hibernation

Rafa³ Mi³ecki (1):
      drm/radeon/kms: suspend and resume audio stuff

Ralf Baechle (1):
      MIPS: IP27: Make defconfig useful again.

Rishikesh (1):
      MAINTAINERS: changed LTP maintainership responsibilities

Roel Kluin (2):
      ocfs2: Fix contiguousness check in ocfs2_try_to_merge_extent_map()
      regulator/lp3971: vol_map out of bounds in lp3971_{ldo,dcdc}_set_voltage()

Sean Hefty (1):
      RDMA/cm: Revert association of an RDMA device when binding to loopback

Serge E. Hallyn (1):
      x86-32: Make AT_VECTOR_SIZE_ARCH=2

Shaohua Li (1):
      cfq-iosched: split seeky coop queues after one slice

Stephen M. Cameron (1):
      cciss: Make cciss_seq_show handle holes in the h->drv[] array

Steve French (3):
      [CIFS] Add support for TCP_NODELAY
      [CIFS] Maximum username length check in session setup does not match
      [CIFS] Don't cache timestamps on utimes due to coarse granularity

Steven Whitehouse (1):
      GFS2: Fix bmap allocation corner-case bug

Sunil Mushran (11):
      ocfs2/trivial: Remove trailing whitespaces
      ocfs2/dlm: Ignore LVBs of locks in the Blocked list
      ocfs2/dlm: Print more messages during lock migration
      ocfs2/dlm: Handle EAGAIN for compatibility - v2
      ocfs2: Prevent a livelock in dlmglue
      ocfs2: Do not downconvert if the lock level is already compatible
      ocfs2: Remove overzealous BUG_ON during blocked lock processing
      ocfs2: Plugs race between the dc thread and an unlock ast message
      ocfs2/dlm: Remove BUG_ON in dlm recovery when freeing locks of a dead node
      ocfs2/dlm: Fix printing of lockname
      ocfs2/cluster: Make o2net connect messages KERN_NOTICE

Suresh Siddha (1):
      x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs

Swen Schillig (1):
      [SCSI] zfcp: Report FC BSG errors in correct field

Takashi Iwai (1):
      ALSA: hda - use WARN_ON_ONCE() for zero-division detection

Tao Ma (5):
      ocfs2: Sync max_inline_data_with_xattr from tools.
      ocfs2: Fix memory overflow in cow_by_page.
      ocfs2: Only bug out when page size is larger than cluster size.
      ocfs2: Add parenthesis to wrap the check for O_DIRECT.
      ocfs2: Use compat_ptr in reflink_arguments.

Thadeu Lima de Souza Cascardo (2):
      irda: unbalanced lock_kernel in irnet_ppp
      irda: add missing BKL in irnet_ppp ioctl

Thomas Hellstrom (2):
      drm/vmwgfx: Update the user-space interface.
      drm/vmwgfx: Fix a circular locking dependency bug.

Thomas Renninger (1):
      [CPUFREQ] Fix use after free of struct powernow_k8_data

Trond Myklebust (3):
      NFS: Fix a bug in nfs_fscache_release_page()
      NFS: Remove a redundant check for PageFsCache in nfs_migrate_page()
      NFS: Fix the mapping of the NFSERR_SERVERFAULT error

Ursula Braun (1):
      [S390] qdio: continue polling for buffer state ERROR

Wengang Wang (2):
      ocfs2: fix a misleading variable name
      ocfs2: Fix setting of OCFS2_LOCK_BLOCKED during bast

Wu Zhangjin (1):
      MIPS: Fixup of the r4k timer

Xiaotian Feng (1):
      [SCSI] qla2xxx: make msix interrupt handler safe for irq

Yoichi Yuasa (1):
      Bluetooth: Fix memory leak in Marvell BT-over-SDIO driver

Yong Zhang (1):
      dmaengine: correct onstack wait_queue_head declaration

Zhenyu Wang (3):
      drm/i915: Rework DPLL calculation parameters for Ironlake
      drm/i915: fix flip done interrupt on Ironlake
      drm/i915: fix pipe source image setting in flip command

stephen hemminger (1):
      sky2: fix transmit DMA map leakage
