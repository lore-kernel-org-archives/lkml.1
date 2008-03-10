Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYCJFn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYCJFn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 01:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYCJFnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 01:43:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbYCJFnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 01:43:18 -0400
Date: Sun, 9 Mar 2008 22:42:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc5
Message-ID: <alpine.LFD.1.00.0803092231580.5896@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So the size of the -rc patches is finally starting to shrink, but we still 
have way too many outstanding regression reports. Some of them should be 
already fixed in -rc5, but many won't be. So reporters, please do keep 
updating your entries as to whether they are fixed or not.

This time around, about 60% of the diffs are in arch code, but that's a 
bit misleading, because over half of that is actually just the defconfig 
files for SH. With the patch-queues shrinking, big trivial patches like 
that easily end up being inordinately noticeable just because there's a 
lot of lines there.

But apart from SH, the ia64 and SCSI updates do stand out. The rest is 
really pretty randomly spread out. I suspect the shortlog does as good a 
job as can be done (and is now small enough to be posted), but here's the 
dirstat anyway since I've given it for previous -rc releases.

	  15.1% arch/ia64/kernel/
	  18.3% arch/ia64/
	   2.3% arch/sh/boards/renesas/sh7710voipgw/
	   2.3% arch/sh/boards/renesas/
	   2.9% arch/sh/boards/
	  32.8% arch/sh/configs/
	  37.6% arch/sh/
	  59.3% arch/
	   7.7% drivers/scsi/aic94xx/
	   2.0% drivers/scsi/libsas/
	  17.1% drivers/scsi/
	  21.3% drivers/
	   2.4% fs/
	   2.9% include/linux/
	   3.9% include/
	   2.7% kernel/
	   4.4% security/selinux/
	   5.7% security/

I'd like developers and testers alike to take a good look at the 
regression email that Rafael sends out, and please help him keep the 
entries up-to-date.

		Linus

---
Adrian Bunk (4):
      UBI: mtd/ubi/vtbl.c: fix memory leak
      [CRYPTO] digest: Include internal.h for prototypes
      sh/mm/pg-sh7705.c must #include <linux/fs.h>
      sh_ksyms_32.c update for gcc 4.3

Alan Cox (1):
      pata_hpt*, pata_serverworks: fix UDMA masking

Andrew Morton (1):
      sh: export copy-page() to modules

Andrew Vasquez (4):
      [SCSI] qla2xxx: Correct needless clean-up resets during shutdown.
      [SCSI] qla2xxx: Correct discrepancies during OVERRUN handling on FWI2-capable cards.
      [SCSI] qla2xxx: Correct usage of inconsistent timeout values while issuing ELS commands.
      [SCSI] qla2xxx: Update version number to 8.02.00-k9.

Artem Bityutskiy (1):
      UBI: fix error message

Aurelien Jarno (1):
      x86: clear DF before calling signal handler

Bartlomiej Zolnierkiewicz (2):
      ide-cd: mark REQ_TYPE_ATA_PC write requests with REQ_RW flag
      ide: fix enabling DMA on it821x in "smart" mode

Bjorn Helgaas (2):
      [IA64] remove CONFIG_SMP ifdef in ia64_send_ipi()
      [IA64] use dev_printk in video quirk

Boaz Harrosh (2):
      [SCSI] gdth: bugfix for the at-exit problems
      [SCSI] gdth: fix to internal commands execution

Bryan Wu (1):
      [Blackfin] arch: to kill syscalls missing warning by adding new timerfd syscalls

Christian Borntraeger (1):
      [S390] sclp_vt220: speed up console output for interactive work

Christoph Lameter (2):
      slub statistics: Fix check for DEACTIVATE_REMOTE_FREES
      slab numa fallback logic: Do not pass unfiltered flags to page allocator

Dave Jones (3):
      [CPUFREQ] Fix missing cpufreq_cpu_put() call in ->show
      [CPUFREQ] Fix missing cpufreq_cpu_put() call in ->store
      [CPUFREQ] Remove debugging message from e_powersaver

David Chinner (2):
      [XFS] 977545 977545 977545 977545 977545 977545 xfsaild causing too many
      [XFS] fix inode leak in xfs_iget_core()

David Howells (1):
      ntp: use unsigned input for do_div()

David Rientjes (1):
      cpusets: fix obsolete comment

David Woodhouse (1):
      Really unexport asm/page.h

Dhaval Giani (1):
      sched: don't allow rt_runtime_us to be zero for groups having rt tasks

Eric Paris (2):
      LSM/SELinux: Interfaces to allow FS to control mount options
      NFS: use new LSM interfaces to explicitly set mount options

FUJITA Tomonori (7):
      [SCSI] ps3rom: fix wrong resid calculation bug
      [SCSI] ps3rom: disable clustering
      [SCSI] ibmvstgt: set up scsi_host properly before __scsi_alloc_queue
      [SCSI] tgt: stop zero'ing scsi_cmnd
      [SCSI] tgt: set the data length properly
      [SCSI] tgt: fix build errors when dprintk is defined
      parisc: fix IOMMU's device boundary overflow bug on 32bits arch

Gregory Haskins (1):
      cpu hotplug: adjust root-domain->online span in response to hotplug event

Harvey Harrison (4):
      UBI: fix sparse errors in ubi.h
      sh: replace remaining __FUNCTION__ occurrences
      [IA64] remove remaining __FUNCTION__ occurrences
      [IA64] kprobes arch consolidation build fix

Heiko Carstens (3):
      [S390] idle: Fix machine check handling in idle loop.
      [S390] Get rid of memcpy gcc warning workaround.
      [S390] Fix IPL from NSS.

Herbert Xu (3):
      [CRYPTO] skcipher: Move chainiv/seqiv into crypto_blkcipher module
      [CRYPTO] authenc: Add missing Kconfig dependency on BLKCIPHER
      [CRYPTO] skcipher: Fix section mismatches

Hongjie Yang (1):
      [S390] incorrect reipl nss name.

Ingo Molnar (2):
      x86: re-add reboot fixups
      drivers/char/esp.c: fix bootup lockup

Itaru Kitayama (1):
      slub: fix typo in Documentation/vm/slub.txt

Ivan Kokshaysky (1):
      alpha: fix iommu-related boot panic

James Bottomley (6):
      [SCSI] mvsas: remove execute permission from file
      [SCSI] libsas: export sas_find_local_phy function
      [SCSI] aic94xx: plumb in I_T_nexus_reset task management function
      [SCSI] libsas: use the supplied address for SATA devices rather than changing it
      [SCSI] libsas: misc fixes to the eh path
      [SCSI] aic94xx: fix TMF ascb handling to prevent sequencer panic

Jan Beulich (2):
      x86: fix merge mistake in i387.c
      x86: fix typo in step.c

Jeff Garzik (1):
      ahci: work around ATI SB600 h/w quirk

Jesper Juhl (1):
      Do not include linux/backing-dev.h twice

Joe Korty (1):
      slab: NUMA slab allocator migration bugfix

Joe Perches (1):
      slab - use angle brackets for include of kmalloc_sizes.h

Joy Latten (1):
      [CRYPTO] xcbc: Fix crash with IPsec

KOSAKI Motohiro (1):
      [IA64] remove unnecessary nfs includes from sys_ia32.c

Karsten Keil (1):
      bluetooth: Add another Broadcom device

Karsten Wiese (1):
      time: don't touch an offlined CPU's ts->tick_stopped in tick_cancel_sched_timer()

Ke Wei (1):
      [SCSI] mvsas: fix phy sas address

Kristoffer Ericson (1):
      sh: hp6xx: Correct APM output.

Krzysztof Oledzki (1):
      [SCSI] mpt fusion: don't oops if NumPhys==0

Linus Torvalds (1):
      Linux 2.6.25-rc5

Martin Schwidefsky (1):
      [S390] Update default configuration.

Miao Xie (1):
      sched: fix the wrong time slice value for SCHED_FIFO tasks

Michael Hennerich (1):
      [Blackfin] arch: fix bug - allow SDH driver to be used as module

Michael Holzheu (1):
      [S390] Load disabled wait psw if reipl fails.

Mike Christie (4):
      [SCSI] iscsi regression: check for zero max session cmds
      [SCSI] qla4xxx: fix host reset dpc race
      [SCSI] qla4xxx: regression - add start scan callout
      [SCSI] iscsi class: regression - fix races with state manipulation and blocking/unblocking

Mike Frysinger (2):
      [Blackfin] arch: fix atomic and32/xor32 comments and ENDPROC markings
      [Blackfin] arch: current_l1_stack_save is a pointer, so use NULL rather than 0

Nick Cheng (1):
      [SCSI] arcmsr: update version and changelog

Nick Piggin (1):
      slub: Do not cross cacheline boundaries for very small objects

Paul Mundt (8):
      sh: Fix up section mismatches.
      fb: pvr2fb: Fix up remaining section mismatch.
      sh: hp6xx: Fix up hp6xx_apm build failure.
      fb: hitfb: Balance probe/remove section annotations.
      sh: Update r7780mp defconfig.
      sh: Flag PMB support as EXPERIMENTAL.
      sh: Fix up SH7710 VoIP-GW build.
      sh: Fix up the sh64 build.

Pavel Roskin (1):
      sched: export task_nice

Peter Korsgaard (1):
      x86-boot: don't request VBE2 information

Peter Teoh (1):
      ide: fix buggy code in ide_register_hw()

Peter Zijlstra (2):
      sched: retain vruntime
      sched: rt-group: fixup schedulability constraints calculation

Petr Tesarik (6):
      [IA64] access user RBS directly
      [IA64] do not sync RBS when changing PT_AR_BSP or PT_CFM
      [IA64] remove find_thread_for_addr()
      [IA64] convert sys_ptrace to arch_ptrace
      [IA64] remove duplicate code from arch_ptrace()
      [IA64] arch_ptrace() cleanup

Ralph Wuerthner (1):
      [S390] zcrypt: fix ap_device_list handling

Randy Dunlap (4):
      [SCSI] docbook: fix scsi source file
      [SCSI] docbook: fix fusion source files
      ide: move ide.txt to Documentation/ide/
      ide: update references to Documentation/ide/ide.txt (v2)

Roland McGrath (2):
      x86_64: make ptrace always sign-extend orig_ax to 64 bits
      Fix waitid si_code regression

Roman Zippel (1):
      time: remove obsolete CLOCK_TICK_ADJUST

S.Çağlar Onur (1):
      UBI: silence warning

Sam Ravnborg (1):
      [CPUFREQ] fix section mismatch warnings

Sebastian Siewior (1):
      [CRYPTO] xts: Use proper alignment

Segher Boessenkool (1):
      time: prevent the loop in timespec_add_ns() from being optimised away

Simon Horman (1):
      [IA64] update efi region debugging to use MB, GB and TB as well as KB

Stefan Weinhuber (2):
      [S390] dasd: let dasd erp matching recognize alias recovery
      [S390] dasd: fix reference counting in display method for proc/dasd/devices

Steven Rostedt (1):
      sched: balance RT task resched only on runqueue

Tilman Schmidt (1):
      gigaset: fix Oops on module unload regression

Tom Talpey (1):
      SUNRPC: Fix a nfs4 over rdma transport oops

Trond Myklebust (3):
      NFS: Fix an f_mode/f_flags confusion in fs/nfs/write.c
      NFS: Fix the fsid revalidation in nfs_update_inode()
      NFS: Fix dentry revalidation for NFSv4 referrals and mountpoint crossings

goda.yusuke (1):
      sh: update se7780 defconfig
