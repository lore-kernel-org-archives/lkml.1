Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbYBBOHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbYBBOHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbYBBOG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:06:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145AbYBBOGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:06:50 -0500
Date: Sat, 2 Feb 2008 15:06:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [scsi bug] spurious build failures in aic7xxx
Message-ID: <20080202140630.GA7939@elte.hu>
References: <20080201225056.GA18302@elte.hu> <20080202135935.GA23838@uranus.ravnborg.org> <20080202140326.GA6544@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202140326.GA6544@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > It looks like make started updating the aic7xxx_reg.h file but 
> > failed to finsih the job before it started building aic7xxx_proc.c 
> > so the build of aic7xxx_proc.c picked up a half written .h file.
> 
> i'll try to find the build logs for this. (i save them all away, so it 
> should be recoverable)

find below an example. I can start doing V=1 builds if needed. (will 
take some time - about an hour, 30-60 builds in a row - to hit the 
race.)

	Ingo

scripts/kconfig/conf -s arch/x86/Kconfig
drivers/net/Kconfig:1743:warning: 'select' used by config symbol 'CPMAC' refers to undefined symbol 'FIXED_MII_100_FDX'
drivers/spi/Kconfig:156:warning: 'select' used by config symbol 'SPI_PXA2XX' refers to undefined symbol 'PXA_SSP'
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm-x86/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      init/main.o
  CC      init/do_mounts.o
  CC      init/do_mounts_initrd.o
  CC      init/initramfs.o
  CC      init/calibrate.o
  AS      arch/x86/lguest/i386_head.o
  CC      arch/x86/lguest/boot.o
  CC      init/version.o
  CC      arch/x86/mach-default/setup.o
  CC      arch/x86/mm/init_32.o
  CC      arch/x86/mm/pgtable_32.o
  CC      arch/x86/mm/fault.o
  CC      arch/x86/mm/ioremap.o
  CC      arch/x86/mm/extable.o
  CC      arch/x86/mm/pageattr.o
  CC      arch/x86/mm/mmap.o
  CC      arch/x86/mm/highmem_32.o
  CC      arch/x86/kernel/process_32.o
  AS      arch/x86/vdso/vdso32/int80.o
  AS      arch/x86/vdso/vdso32/sysenter.o
  CC      arch/x86/kernel/signal_32.o
  LD      arch/x86/mach-default/built-in.o
  AS      arch/x86/kernel/entry_32.o
  CC      arch/x86/kernel/traps_32.o
  CC      arch/x86/vdso/vdso32-setup.o
  CC      arch/x86/kernel/irq_32.o
  CC      arch/x86/kernel/time_32.o
  CC      arch/x86/kernel/ioport.o
  CC      arch/x86/kernel/ldt.o
  LD      init/mounts.o
  CC      arch/x86/kernel/setup_32.o
  CC      arch/x86/kernel/i8259_32.o
  CC      arch/x86/kernel/sys_i386_32.o
  CC      arch/x86/kernel/i386_ksyms_32.o
  CC      arch/x86/kernel/pci-dma_32.o
  CC      arch/x86/kernel/bootflag.o
  LD      arch/x86/lguest/built-in.o
  CC      arch/x86/kernel/e820_32.o
  CC      arch/x86/kernel/quirks.o
  CC      arch/x86/kernel/i8237.o
  CC      arch/x86/kernel/topology.o
  CC      arch/x86/kernel/kdebugfs.o
  CC      arch/x86/kernel/alternative.o
  CC      arch/x86/kernel/i8253.o
  CC      arch/x86/kernel/tsc_32.o
  CC      arch/x86/kernel/io_delay.o
  VDSO    arch/x86/vdso/vdso32-sysenter.so.dbg
  CC      arch/x86/kernel/rtc.o
  CC      arch/x86/kernel/i387.o
  CC      arch/x86/kernel/ptrace.o
  CC      arch/x86/kernel/ds.o
  CC      arch/x86/kernel/tls.o
  CC      arch/x86/kernel/step.o
  CC      arch/x86/kernel/stacktrace.o
  CC      kernel/sched.o
  CC      kernel/fork.o
  CC      kernel/exec_domain.o
  CC      arch/x86/kernel/reboot.o
  CC      kernel/panic.o
  CC      arch/x86/kernel/mca_32.o
  CC      arch/x86/kernel/acpi/boot.o
  CC      arch/x86/kernel/microcode.o
  CC      kernel/printk.o
  CC      arch/x86/kernel/early-quirks.o
  CC      kernel/profile.o
  CC      arch/x86/kernel/acpi/sleep.o
  CC      kernel/exit.o
  CC      arch/x86/kernel/doublefault_32.o
  AS      arch/x86/kernel/acpi/wakeup_32.o
  CC      arch/x86/kernel/cpu/intel_cacheinfo.o
  CC      arch/x86/kernel/cpu/addon_cpuid_features.o
  CC      kernel/itimer.o
  CC      arch/x86/kernel/vm86_32.o
  CC      arch/x86/kernel/acpi/cstate.o
  CC      arch/x86/kernel/cpu/feature_names.o
  CC      arch/x86/kernel/acpi/processor.o
  CC      mm/bootmem.o
  CC      arch/x86/kernel/cpu/common.o
  CC      arch/x86/kernel/cpu/proc.o
  CC      mm/filemap.o
  CC      arch/x86/kernel/early_printk.o
  CC      mm/mempool.o
  CC      kernel/time.o
  CC      arch/x86/kernel/cpu/bugs.o
  CC      kernel/softirq.o
  CC      arch/x86/kernel/hpet.o
  CC      mm/oom_kill.o
  CC      kernel/resource.o
  CC      arch/x86/kernel/cpu/amd.o
  CC      arch/x86/kernel/k8.o
  CC      mm/fadvise.o
  VDSO    arch/x86/vdso/vdso32-int80.so.dbg
  CC      fs/open.o
  CC      kernel/sysctl.o
  CC      fs/read_write.o
  CC      arch/x86/kernel/cpu/cyrix.o
  CC      arch/x86/kernel/vmi_32.o
  CC      fs/file_table.o
  CC      kernel/capability.o
  CC      mm/page_alloc.o
  OBJCOPY arch/x86/vdso/vdso32-sysenter.so
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  CC      kernel/ptrace.o
  CC      arch/x86/kernel/vmiclock_32.o
  CC      arch/x86/kernel/cpu/centaur.o
  CC      mm/page-writeback.o
  CC      fs/super.o
  OBJCOPY arch/x86/vdso/vdso32-int80.so
  CC      kernel/timer.o
  CC      fs/char_dev.o
  CC      arch/x86/kernel/paravirt.o
  CC      arch/x86/kernel/cpu/transmeta.o
  CC      arch/x86/kernel/paravirt_patch_32.o
  CC      mm/pdflush.o
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  AS      arch/x86/kernel/head_32.o
  CC      kernel/user.o
  CC      arch/x86/kernel/cpu/intel.o
  CC      fs/stat.o
  CC      mm/readahead.o
  CC      arch/x86/kernel/cpu/nexgen.o
  AS      arch/x86/vdso/vdso32.o
  CC      fs/exec.o
  CC      kernel/user_namespace.o
  CC      arch/x86/kernel/init_task.o
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  CC      fs/pipe.o
  LDS     arch/x86/kernel/vmlinux.lds
  CC      kernel/signal.o
  CC      arch/x86/kernel/cpu/umc.o
  CC      mm/swap.o
  CC      security/security.o
  CC      kernel/sys.o
  CC      fs/namei.o
  CC      security/dummy.o
  CC      security/inode.o
  CC      mm/truncate.o
  CC      kernel/kmod.o
  CC      mm/vmscan.o
  CC      fs/fcntl.o
  CC      kernel/workqueue.o
  CC      security/commoncap.o
  CC      fs/ioctl.o
  CC      kernel/pid.o
  CC      security/capability.o
  CC      mm/prio_tree.o
  CC      fs/readdir.o
  CC      kernel/rcupdate.o
  CC      arch/x86/kernel/cpu/mcheck/mce_32.o
  CC      security/keys/key.o
  CC      fs/select.o
  CC      mm/util.o
  CC      arch/x86/kernel/cpu/mtrr/main.o
  CC      security/keys/keyring.o
  CC      arch/x86/kernel/cpu/mcheck/therm_throt.o
  CC      mm/mmzone.o
  CC      fs/fifo.o
  CC      kernel/extable.o
  CC      arch/x86/kernel/cpu/mtrr/if.o
  CC      security/keys/keyctl.o
  CC      arch/x86/kernel/cpu/mcheck/k7.o
  LD      arch/x86/vdso/built-in.o
  CC      mm/vmstat.o
  CC      arch/x86/kernel/cpu/mtrr/generic.o
  CC      kernel/params.o
  CC      fs/locks.o
  CC      security/keys/permission.o
  CC      arch/x86/kernel/cpu/mcheck/p4.o
  CC      mm/backing-dev.o
  CC      arch/x86/kernel/cpu/mtrr/state.o
  CC      arch/x86/kernel/cpu/mcheck/p5.o
  CC      security/keys/process_keys.o
  CC      kernel/posix-timers.o
  CC      fs/dcache.o
  CC      mm/page_isolation.o
  CC      arch/x86/kernel/cpu/mtrr/amd.o
  CC      security/keys/request_key.o
  CC      arch/x86/kernel/cpu/mcheck/p6.o
  LD      arch/x86/kernel/acpi/built-in.o
  CC      mm/fremap.o
  CC      arch/x86/kernel/cpu/mtrr/cyrix.o
  CC      kernel/kthread.o
  CC      fs/inode.o
  CC      arch/x86/kernel/cpu/mcheck/winchip.o
  CC      security/keys/request_key_auth.o
  CC      mm/highmem.o
  CC      arch/x86/kernel/cpu/mtrr/centaur.o
  CC      fs/attr.o
  CC      kernel/wait.o
  CC      arch/x86/kernel/cpu/mcheck/non-fatal.o
  CC      security/keys/user_defined.o
  CC      security/keys/proc.o
  CC      mm/madvise.o
  CC      kernel/kfifo.o
  CC      fs/bad_inode.o
  CC      kernel/posix-cpu-timers.o
  CC      fs/file.o
  CC      mm/memory.o
  CC      crypto/api.o
  CC      mm/mincore.o
  CC      crypto/cipher.o
  CC      mm/mlock.o
  CC      kernel/mutex.o
  CC      fs/filesystems.o
  CC      crypto/digest.o
  CC      kernel/hrtimer.o
  CC      fs/namespace.o
  CC      mm/mmap.o
  CC      crypto/compress.o
  CC      kernel/rwsem.o
  CC      fs/aio.o
  LD      init/built-in.o
  CC      mm/mprotect.o
  CC      crypto/algapi.o
  CC      fs/seq_file.o
  CC      mm/mremap.o
  CC      kernel/latency.o
  CC      crypto/scatterwalk.o
  CC      kernel/nsproxy.o
  CC      fs/xattr.o
  CC      crypto/proc.o
  CC      mm/msync.o
  CC      kernel/srcu.o
  CC      block/elevator.o
  CC      fs/libfs.o
  CC      mm/rmap.o
  CC      crypto/ablkcipher.o
  CC      block/blk-core.o
  CC      crypto/blkcipher.o
  CC      mm/vmalloc.o
  CC      kernel/utsname.o
  CC      fs/fs-writeback.o
  CC      block/blk-tag.o
  CC      mm/bounce.o
  CC      crypto/hash.o
  CC      fs/pnode.o
  CC      block/blk-sysfs.o
  CC      fs/drop_caches.o
  CC      kernel/notifier.o
  CC      crypto/aead.o
  CC      mm/page_io.o
  CC      fs/splice.o
  CC      block/blk-barrier.o
  CC      kernel/sysctl_check.o
  CC      kernel/stacktrace.o
  CC      mm/swap_state.o
  CC      crypto/chainiv.o
  CC      fs/sync.o
  CC      block/blk-settings.o
  CC      crypto/eseqiv.o
  CC      fs/utimes.o
  CC      block/blk-ioc.o
  CC      mm/swapfile.o
  CC      crypto/seqiv.o
  CC      mm/thrash.o
  CC      fs/stack.o
  CC      crypto/cryptomgr.o
  CC      mm/sparse.o
  CC      kernel/irq/handle.o
  CC      fs/buffer.o
  CC      kernel/power/main.o
  CC      mm/shmem.o
  CC      drivers/acpi/tables.o
  CC      block/blk-map.o
  CC      kernel/mutex-debug.o
  CC      drivers/acpi/blacklist.o
  CC      mm/slob.o
  CC      kernel/lockdep.o
  CC      crypto/hmac.o
  CC      sound/ac97_bus.o
  CC      drivers/base/core.o
  CC      drivers/ata/libata-core.o
  CC      kernel/time/timekeeping.o
  CC      fs/bio.o
  CC      fs/block_dev.o
  CC      mm/memory_hotplug.o
  CC      mm/quicklist.o
  CC      kernel/lockdep_proc.o
  LD      arch/x86/kernel/cpu/mcheck/built-in.o
  CC      kernel/futex.o
  CC      kernel/rtmutex.o
  CC      kernel/time/ntp.o
  CC      kernel/irq/manage.o
  CC      kernel/rtmutex-debug.o
  CC      kernel/rtmutex-tester.o
  CC      fs/direct-io.o
  CC      kernel/dma.o
  CC      drivers/block/cpqarray.o
  CC      kernel/spinlock.o
  CC      kernel/power/process.o
  CC      kernel/power/console.o
  CC      kernel/power/poweroff.o
  CC      crypto/xcbc.o
  LD      sound/built-in.o
  CC      crypto/md4.o
  CC      block/blk-exec.o
  CC      crypto/md5.o
  CC      kernel/kallsyms.o
  CC      kernel/acct.o
  CC      crypto/sha1_generic.o
  CC      crypto/sha512.o
  CC      fs/mpage.o
  CC      fs/ioprio.o
  CC      crypto/gf128mul.o
  CC      fs/inotify.o
  CC      fs/anon_inodes.o
  CC      kernel/backtracetest.o
  CC      crypto/ecb.o
  GZIP    kernel/config_data.gz
  CC      kernel/ksysfs.o
  CC      kernel/rcuclassic.o
  LD      arch/x86/mm/built-in.o
  CC      arch/x86/pci/i386.o
  CC      fs/eventfd.o
  CC      fs/nfsctl.o
  LD      arch/x86/kernel/cpu/mtrr/built-in.o
  CC      fs/binfmt_aout.o
  CC      kernel/relay.o
  CC      arch/x86/power/cpu.o
  CC      kernel/utsname_sysctl.o
  CC      fs/binfmt_script.o
  CC      block/blk-merge.o
  CC      fs/binfmt_elf.o
  CC      net/socket.o
  CC      net/802/p8022.o
  CC      fs/mbcache.o
  IKCFG   kernel/config_data.h
  CC      kernel/configs.o
  CC      fs/posix_acl.o
  CC      crypto/cbc.o
  CC      crypto/xts.o
  CC      crypto/ctr.o
  CC      arch/x86/pci/init.o
  CC      crypto/gcm.o
  CC      crypto/ccm.o
  CC      crypto/des_generic.o
  CC      fs/xattr_acl.o
  CC      crypto/serpent.o
  CC      arch/x86/lib/bitops_32.o
  CC      arch/x86/pci/pcbios.o
  CC      fs/befs/datastream.o
  CC      fs/affs/super.o
  CC      block/ioctl.o
  CC      crypto/camellia.o
  CC      crypto/arc4.o
  CC      drivers/acpi/osl.o
  CC      crypto/khazad.o
  CC      fs/autofs4/init.o
  CC      lib/div64.o
  CC      crypto/anubis.o
  CC      drivers/acpi/utils.o
  CC      kernel/irq/spurious.o
  CC      arch/x86/pci/mmconfig_32.o
  CC      kernel/time/clocksource.o
  CC      kernel/time/jiffies.o
  CC      net/atm/addr.o
  CC      kernel/time/clockevents.o
  CC      kernel/time/timer_list.o
  CC      kernel/time/tick-common.o
  CC      fs/cramfs/inode.o
  CC      arch/x86/pci/direct.o
  CC      crypto/seed.o
  CC      crypto/salsa20_generic.o
  CC      fs/bfs/inode.o
  CC      net/atm/pvc.o
  CC      fs/debugfs/inode.o
  CC      crypto/deflate.o
  CC      fs/configfs/inode.o
  CC      net/atm/signaling.o
  CC      crypto/crc32c.o
  CC      fs/dlm/ast.o
  CC      net/atm/svc.o
  CC      fs/dlm/config.o
  CC      net/802/psnap.o
  CC      fs/ecryptfs/dentry.o
  CC      net/atm/ioctl.o
  CC      fs/cramfs/uncompress.o
  CC      drivers/bluetooth/hci_usb.o
  CC      block/genhd.o
  CC      block/scsi_ioctl.o
  CC      fs/devpts/inode.o
  CC      drivers/acpi/dispatcher/dsfield.o
  CC      net/atm/common.o
  CC      fs/autofs4/inode.o
  CC      fs/exportfs/expfs.o
  CC      fs/autofs4/root.o
  CC      drivers/char/mem.o
  CC      fs/autofs4/symlink.o
  CC      net/802/tr.o
  CC      net/802/fc.o
  CC      fs/ext3/balloc.o
  CC      lib/sort.o
  CC      fs/ext3/bitmap.o
  CC      lib/parser.o
  CC      kernel/time/tick-oneshot.o
  CC      arch/x86/pci/mmconfig-shared.o
  CC      drivers/base/sys.o
  CC      fs/jbd/transaction.o
  CC      drivers/base/bus.o
  CC      fs/fat/cache.o
  CC      fs/freevxfs/vxfs_bmap.o
  CC      drivers/base/dd.o
  CC      kernel/irq/resend.o
  CC      block/bsg.o
  CC      fs/hfsplus/super.o
  CC      kernel/time/tick-sched.o
  CC      arch/x86/pci/fixup.o
  CC      block/noop-iosched.o
  CC      fs/hfsplus/options.o
  CC      arch/x86/pci/acpi.o
  CC      fs/minix/bitmap.o
  CC      arch/x86/lib/delay_32.o
  CC      drivers/acpi/events/evevent.o
  CC      drivers/acpi/events/evregion.o
  CC      net/802/hippi.o
  CC      drivers/acpi/events/evsci.o
  CC      net/802/p8023.o
  CC      block/deadline-iosched.o
  CC      fs/jfs/super.o
  CC      block/cfq-iosched.o
  CC      drivers/acpi/events/evxfevnt.o
  CC      fs/msdos/namei.o
  CC      block/blktrace.o
  CC      drivers/acpi/executer/exconfig.o
  AS      arch/x86/lib/getuser_32.o
  LD      fs/devpts/devpts.o
  CC      arch/x86/lib/memcpy_32.o
  CC      fs/ecryptfs/file.o
  CC      fs/minix/itree_v1.o
  LD      fs/devpts/built-in.o
  CC      lib/halfmd4.o
  CC      fs/ecryptfs/inode.o
  LD      kernel/power/built-in.o
  AS      arch/x86/lib/putuser_32.o
  CC      fs/lockd/clntlock.o
  CC      arch/x86/lib/string_32.o
  CC      fs/nfsd/nfssvc.o
  CC      fs/affs/namei.o
  LD      arch/x86/kernel/cpu/built-in.o
  CC      arch/x86/lib/strstr_32.o
  LD      arch/x86/power/built-in.o
  CC      fs/debugfs/file.o
  CC      fs/ntfs/aops.o
  LD      fs/exportfs/exportfs.o
fs/autofs4/symlink.c: In function 'autofs4_follow_link':
fs/autofs4/symlink.c:18: warning: passing argument 2 of 'nd_set_link' discards qualifiers from pointer target type
  CC      fs/lockd/clntproc.o
  LD      fs/exportfs/built-in.o
  LD      arch/x86/kernel/built-in.o
  CC      arch/x86/lib/usercopy_32.o
  CC      net/atm/atm_misc.o
  CC      fs/autofs4/waitq.o
  CC      fs/nfs/client.o
  CC      fs/partitions/check.o
  CC      fs/ocfs2/alloc.o
  CC      fs/nls/nls_base.o
  CC      fs/nfs/dir.o
  CC      net/atm/raw.o
  CC      net/atm/resources.o
  CC      drivers/base/driver.o
  CC      fs/dlm/dir.o
  CC      lib/debug_locks.o
  CC      kernel/irq/chip.o
  CC      drivers/base/class.o
  CC      fs/autofs4/expire.o
  CC      net/atm/atm_sysfs.o
  CC      drivers/acpi/events/evmisc.o
  CC      drivers/acpi/executer/exfield.o
  CC      net/atm/proc.o
  CC      net/atm/mpc.o
  CC      fs/ramfs/inode.o
  CC      net/atm/mpoa_caches.o
  CC      fs/proc/mmu.o
  CC      fs/ramfs/file-mmu.o
  CC      net/atm/mpoa_proc.o
  LD      security/keys/built-in.o
  CC      net/atm/br2684.o
  CC      fs/reiserfs/bitmap.o
  CC      lib/random32.o
  CC      fs/reiserfs/do_balan.o
  LD      fs/cramfs/cramfs.o
  CC      fs/romfs/inode.o
  CC      drivers/acpi/events/evrgnini.o
  LD      fs/cramfs/built-in.o
  CC      net/atm/lec.o
  CC      fs/fat/dir.o
  CC      drivers/ata/libata-scsi.o
  CC      fs/proc/task_mmu.o
  LD      crypto/crypto_algapi.o
  CC      drivers/bluetooth/hci_vhci.o
  CC      drivers/acpi/events/evxface.o
  LD      crypto/crypto_blkcipher.o
  LD      crypto/crypto_hash.o
  CC      fs/ecryptfs/main.o
  CC      drivers/acpi/events/evxfregn.o
  CC      fs/configfs/file.o
  CC      drivers/acpi/dispatcher/dsmthdat.o
  CC      fs/affs/inode.o
  CC      drivers/acpi/dispatcher/dsopcode.o
  CC      arch/x86/pci/legacy.o
  CC      fs/smbfs/proc.o
  CC      fs/sysfs/inode.o
  CC      fs/smbfs/dir.o
  CC      arch/x86/pci/irq.o
  CC      drivers/acpi/dispatcher/dswexec.o
  CC      drivers/acpi/events/evgpe.o
  CC      drivers/base/platform.o
  CC      arch/x86/pci/common.o
  CC      drivers/char/random.o
  CC      lib/bust_spinlocks.o
  CC      lib/hexdump.o
  CC      drivers/base/cpu.o
  CC      drivers/acpi/events/evgpeblk.o
  CC      fs/bfs/file.o
  CC      lib/kasprintf.o
  CC      fs/freevxfs/vxfs_fshead.o
  CC      fs/bfs/dir.o
  CC      fs/dquot.o
  CC      kernel/irq/devres.o
  CC      drivers/base/firmware.o
  CC      arch/x86/pci/early.o
  CC      fs/proc/inode.o
  CC      drivers/base/init.o
  CC      fs/ecryptfs/super.o
  CC      fs/quota_v1.o
  CC      fs/freevxfs/vxfs_immed.o
  LD      kernel/time/built-in.o
  CC      fs/quota.o
  CC      fs/freevxfs/vxfs_inode.o
  CC      fs/proc/root.o
  CC      lib/bitmap.o
  CC      fs/nls/nls_cp437.o
  CC      lib/iomap.o
  CC      fs/proc/base.o
  CC      fs/proc/generic.o
  CC      fs/proc/array.o
  CC      drivers/base/map.o
  CC      drivers/base/devres.o
  CC      fs/dnotify.o
  CC      fs/freevxfs/vxfs_lookup.o
  CC      drivers/base/attribute_container.o
  CC      drivers/acpi/dispatcher/dswscope.o
  CC      drivers/acpi/dispatcher/dsmethod.o
  CC      drivers/acpi/dispatcher/dsobject.o
  CC      fs/ocfs2/aops.o
  CC      fs/lockd/host.o
  CC      fs/lockd/svc.o
  CC      lib/iomap_copy.o
  CC      fs/configfs/dir.o
  CC      fs/hfsplus/inode.o
  AR      arch/x86/lib/lib.a
  CC      fs/ext3/dir.o
  CC      fs/hfsplus/ioctl.o
  CC      fs/lockd/svclock.o
  CC      fs/ext3/file.o
  CC      fs/lockd/svcshare.o
  CC      lib/devres.o
  CC      lib/locking-selftest.o
  CC      fs/lockd/svcproc.o
  CC      drivers/acpi/dispatcher/dsutils.o
  CC      drivers/base/transport_class.o
  CC      drivers/acpi/dispatcher/dswload.o
  CC      drivers/bluetooth/dtl1_cs.o
  CC      fs/ext3/fsync.o
  CC      fs/freevxfs/vxfs_olt.o
  CC      fs/ext3/ialloc.o
  CC      drivers/base/dma-mapping.o
  LD      fs/debugfs/debugfs.o
  CC      fs/freevxfs/vxfs_subr.o
  CC      drivers/base/power/sysfs.o
  CC      fs/jfs/file.o
  CC      drivers/acpi/executer/exnames.o
  LD      fs/debugfs/built-in.o
  CC      drivers/acpi/executer/exoparg6.o
  CC      fs/nls/nls_cp775.o
  CC      fs/nls/nls_cp857.o
  CC      drivers/acpi/executer/exresolv.o
  CC      fs/minix/itree_v2.o
  CC      net/bluetooth/af_bluetooth.o
  CC      fs/minix/namei.o
  CC      drivers/base/dmapool.o
  CC      fs/minix/inode.o
  LD      fs/msdos/msdos.o
  CC      net/can/af_can.o
  CC      fs/proc/proc_tty.o
  LD      fs/ramfs/ramfs.o
  LD      fs/ramfs/built-in.o
  LD      fs/msdos/built-in.o
  CC      fs/proc/proc_misc.o
  CC      fs/proc/proc_sysctl.o
  CC      drivers/acpi/dispatcher/dswstate.o
  CC      fs/minix/file.o
  CC      fs/befs/btree.o
  CC      fs/minix/dir.o
  CC      net/can/proc.o
  CC      drivers/base/firmware_class.o
  LD      security/built-in.o
  CC      fs/jfs/inode.o
  CC      fs/jfs/namei.o
  LD      net/802/built-in.o
  CC      drivers/base/memory.o
  CC      lib/spinlock_debug.o
  CC      drivers/base/power/main.o
  CC      fs/nls/nls_cp861.o
  CC      fs/nls/nls_cp864.o
  CC      drivers/acpi/dispatcher/dsinit.o
  CC      fs/jfs/jfs_mount.o
  LD      drivers/acpi/events/built-in.o
  CC      fs/freevxfs/vxfs_super.o
  CC      net/dccp/ccid.o
  CC      net/dccp/feat.o
  CC      fs/befs/super.o
  CC      fs/lockd/svcsubs.o
  CC      fs/proc/proc_net.o
  CC      fs/befs/inode.o
  CC      drivers/acpi/hardware/hwacpi.o
  CC      net/core/sock.o
  CC      net/dccp/input.o
  CC      drivers/acpi/hardware/hwgpe.o
  CC      fs/lockd/mon.o
  CC      fs/befs/debug.o
  CC      net/core/request_sock.o
  CC      net/dccp/minisocks.o
  CC      kernel/irq/autoprobe.o
  CC      fs/befs/io.o
  CC      fs/jfs/jfs_umount.o
  CC      lib/hweight.o
  LD      fs/autofs4/autofs4.o
  CC      kernel/irq/proc.o
  CC      drivers/acpi/executer/exstorob.o
  CC      fs/affs/file.o
  LD      fs/autofs4/built-in.o
  CC      fs/nls/nls_cp874.o
  CC      fs/nfsd/nfsctl.o
  CC      drivers/acpi/executer/exconvrt.o
  CC      fs/affs/dir.o
  CC      fs/smbfs/cache.o
  CC      fs/nls/nls_cp949.o
  CC      fs/nls/nls_cp950.o
  CC      fs/ecryptfs/mmap.o
  CC      fs/sysfs/file.o
  CC      drivers/acpi/executer/exfldio.o
  CC      drivers/acpi/hardware/hwregs.o
  CC      drivers/acpi/hardware/hwsleep.o
  CC      drivers/acpi/executer/exoparg1.o
  CC      fs/hfsplus/extents.o
  CC      drivers/acpi/executer/exprep.o
  CC      fs/befs/linuxvfs.o
  CC      fs/jbd/commit.o
  CC      fs/proc/kmsg.o
  CC      drivers/acpi/namespace/nsaccess.o
  CC      fs/jbd/recovery.o
  CC      drivers/acpi/parser/psargs.o
  CC      drivers/acpi/parser/psparse.o
  CC      drivers/acpi/executer/exresop.o
  CC      fs/partitions/amiga.o
  CC      fs/partitions/atari.o
  CC      fs/ext3/inode.o
  CC      fs/ext3/ioctl.o
  CC      lib/kernel_lock.o
  CC      fs/fat/fatent.o
  CC      fs/ocfs2/buffer_head_io.o
  CC      fs/fat/file.o
  CC      lib/plist.o
  CC      fs/ecryptfs/read_write.o
  CC      lib/smp_processor_id.o
  CC      lib/bitrev.o
  CC      lib/crc-ccitt.o
  CC      lib/crc-itu-t.o
  CC      fs/ecryptfs/crypto.o
  CC      lib/crc32.o
  CC      fs/jfs/jfs_xtree.o
  CC      fs/lockd/xdr.o
  CC      drivers/base/power/trace.o
  CC      fs/hfsplus/catalog.o
  CC      fs/jfs/jfs_imap.o
  CC      lib/crc7.o
  CC      fs/jfs/jfs_debug.o
  CC      lib/libcrc32c.o
  CC      fs/lockd/xdr4.o
  CC      fs/jfs/jfs_dmap.o
  CC      net/dccp/options.o
  CC      fs/lockd/svc4proc.o
  CC      fs/ext3/namei.o
  LD      drivers/acpi/dispatcher/built-in.o
  CC      lib/zlib_deflate/deflate.o
  LD      arch/x86/pci/built-in.o
  CC      lib/zlib_inflate/inffast.o
  CC      drivers/char/tty_io.o
  CC      drivers/acpi/executer/exsystem.o
  CC      fs/ext3/super.o
  CC      fs/ext3/symlink.o
  CC      fs/dlm/lock.o
  CC      lib/fault-inject.o
  CC      lib/argv_split.o
  CC      drivers/acpi/namespace/nsload.o
  CC      fs/ext3/hash.o
  CC      drivers/acpi/resources/rsaddr.o
  CC      drivers/acpi/resources/rscreate.o
  CC      drivers/acpi/namespace/nssearch.o
  CC      lib/bug.o
  LD      drivers/acpi/hardware/built-in.o
  CC      fs/affs/amigaffs.o
  CC      net/bluetooth/hci_core.o
  CC      lib/cmdline.o
  CC      lib/zlib_inflate/inflate.o
  CC      drivers/acpi/executer/excreate.o
  LD      fs/freevxfs/freevxfs.o
  CC      fs/nls/nls_cp1251.o
  CC      fs/ecryptfs/keystore.o
  LD      fs/freevxfs/built-in.o
  CC      lib/ctype.o
  CC      fs/dlm/lockspace.o
  CC      fs/dlm/main.o
  CC      lib/dec_and_lock.o
  CC      fs/dlm/member.o
  CC      drivers/acpi/sleep/wakeup.o
  CC      drivers/acpi/tables/tbxface.o
  LD      fs/bfs/bfs.o
  CC      drivers/acpi/executer/exmisc.o
  LD      fs/bfs/built-in.o
  CC      drivers/acpi/sleep/main.o
  CC      net/core/skbuff.o
  CC      drivers/acpi/executer/exoparg2.o
  CC      fs/jfs/jfs_unicode.o
  CC      drivers/acpi/executer/exregion.o
  CC      net/core/iovec.o
  LD      drivers/block/built-in.o
  CC      lib/dump_stack.o
  CC      net/core/datagram.o
  CC      lib/extable.o
  LD      fs/romfs/romfs.o
  CC      drivers/acpi/executer/exstore.o
  LD      fs/romfs/built-in.o
  CC      drivers/acpi/resources/rsinfo.o
  CC      drivers/acpi/resources/rsio.o
  CC      lib/idr.o
  CC      net/dccp/output.o
  CC      fs/sysfs/dir.o
  CC      drivers/acpi/namespace/nsxfeval.o
  CC      fs/configfs/symlink.o
  CC      lib/int_sqrt.o
  CC      lib/ioremap.o
  LD      drivers/base/power/built-in.o
  CC      lib/irq_regs.o
  CC      lib/klist.o
  CC      drivers/acpi/namespace/nsalloc.o
  CC      fs/affs/bitmap.o
  CC      lib/kobject.o
  CC      fs/nls/nls_ascii.o
  CC      drivers/acpi/executer/exutils.o
  CC      lib/kobject_uevent.o
  CC      lib/kref.o
  CC      lib/prio_heap.o
  CC      lib/prio_tree.o
  CC      fs/ecryptfs/messaging.o
  LD      drivers/bluetooth/built-in.o
  CC      lib/proportions.o
  CC      fs/partitions/mac.o
  LD      kernel/irq/built-in.o
  CC      drivers/acpi/resources/rslist.o
  CC      drivers/acpi/executer/exdump.o
  CC      drivers/connector/cn_queue.o
  CC      lib/radix-tree.o
  CC      lib/zlib_deflate/deftree.o
  CC      drivers/acpi/resources/rsmisc.o
  CC      drivers/acpi/executer/exmutex.o
  CC      lib/rbtree.o
  CC      fs/ext3/resize.o
  CC      fs/jfs/jfs_dtree.o
  CC      drivers/crypto/geode-aes.o
  CC      lib/reciprocal_div.o
  CC      fs/fat/inode.o
  CC      lib/rwsem.o
  CC      drivers/acpi/executer/exoparg3.o
  CC      fs/dlm/memory.o
  CC      drivers/acpi/executer/exresnte.o
  CC      drivers/acpi/resources/rsxface.o
  LD      mm/built-in.o
  CC      fs/nfs/file.o
  CC      fs/jfs/jfs_inode.o
  CC      drivers/acpi/resources/rscalc.o
  CC      drivers/acpi/parser/psloop.o
  CC      net/dccp/proto.o
  CC      fs/nls/nls_iso8859-1.o
  CC      drivers/acpi/tables/tbinstal.o
  CC      fs/nfsd/nfsproc.o
  CC      drivers/acpi/parser/pstree.o
  CC      drivers/acpi/parser/pswalk.o
  CC      lib/scatterlist.o
  CC      drivers/acpi/resources/rsirq.o
  CC      drivers/acpi/executer/exstoren.o
  CC      fs/ecryptfs/netlink.o
  CC      fs/ext3/ext3_jbd.o
  CC      fs/nls/nls_iso8859-3.o
  CC      fs/reiserfs/namei.o
  CC      fs/dlm/midcomms.o
  CC      fs/nls/nls_iso8859-4.o
  CC      drivers/acpi/parser/psopcode.o
  CC      drivers/acpi/resources/rsmemory.o
  CC      fs/ext3/xattr.o
  CC      fs/dlm/netlink.o
  CC      fs/nls/nls_iso8859-5.o
  CC      lib/semaphore-sleepers.o
  CC      fs/ext3/xattr_user.o
  CC      drivers/acpi/parser/psscope.o
  CC      fs/nfs/getroot.o
  CC      fs/configfs/mount.o
  CC      lib/sha1.o
  CC      drivers/acpi/namespace/nseval.o
  CC      lib/string.o
  CC      net/ethernet/eth.o
  CC      net/ethernet/pe2.o
  CC      lib/vsprintf.o
  CC      fs/configfs/item.o
  CC      drivers/acpi/namespace/nsnames.o
  CC      drivers/acpi/sleep/proc.o
  CC      drivers/acpi/resources/rsutils.o
  CC      drivers/acpi/namespace/nsutils.o
  CC      fs/partitions/msdos.o
  CC      fs/jfs/jfs_extent.o
  CC      fs/partitions/osf.o
  CC      net/ieee80211/ieee80211_module.o
  CC      fs/fat/misc.o
  CC      net/ieee80211/ieee80211_tx.o
  CC      fs/ext3/xattr_trusted.o
  CC      fs/partitions/sun.o
  CC      fs/ext3/acl.o
  CC      fs/nls/nls_iso8859-6.o
  CC      net/dccp/timer.o
  CC      fs/nls/nls_iso8859-7.o
  CC      net/core/stream.o
fs/smbfs/cache.c: In function 'smb_fill_cache':
fs/smbfs/cache.c:149: warning: passing argument 1 of '__constant_memcpy' discards qualifiers from pointer target type
fs/smbfs/cache.c:149: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      fs/jfs/symlink.o
  CC      fs/nfs/inode.o
  CC      drivers/acpi/parser/psutils.o
  CC      fs/nls/nls_iso8859-9.o
  CC      net/core/scm.o
  CC      fs/ntfs/attrib.o
  CC      fs/nfsd/nfsfh.o
  CC      fs/nfs/super.o
  LD      kernel/built-in.o
  CC      fs/jbd/checkpoint.o
  CC      fs/ext3/xattr_security.o
  LD      drivers/base/built-in.o
  CC      fs/smbfs/sock.o
  CC      fs/smbfs/inode.o
  CC      drivers/acpi/parser/psxface.o
  CC      drivers/acpi/tables/tbutils.o
  LD      fs/befs/befs.o
  CC      drivers/acpi/tables/tbfind.o
  CC      fs/sysfs/symlink.o
  CC      fs/affs/symlink.o
  LD      fs/befs/built-in.o
  CC      drivers/acpi/namespace/nsxfname.o
  CC      drivers/acpi/tables/tbfadt.o
  CC      drivers/dca/dca-core.o
  CC      net/core/gen_stats.o
  CC      drivers/acpi/namespace/nsdump.o
  CC      fs/jfs/jfs_metapage.o
  CC      fs/jbd/revoke.o
  CC      fs/smbfs/file.o
  CC      drivers/dca/dca-sysfs.o
  CC      fs/sysfs/mount.o
  CC      drivers/acpi/namespace/nsinit.o
  CC      fs/ecryptfs/debug.o
  CC      fs/jfs/jfs_logmgr.o
  CC      fs/sysfs/bin.o
  CC      fs/jfs/jfs_txnmgr.o
  CC      net/core/gen_estimator.o
  CC      drivers/acpi/namespace/nsobject.o
  CC      drivers/acpi/namespace/nswalk.o
  CC      fs/nls/nls_iso8859-14.o
  LD      crypto/built-in.o
  CC      fs/dlm/lowcomms.o
  CC      drivers/acpi/namespace/nsxfobj.o
  CC      net/dccp/ackvec.o
  CC      net/core/net_namespace.o
  CC      fs/hfsplus/dir.o
  CC      fs/nfsd/vfs.o
  CC      drivers/crypto/hifn_795x.o
  CC      fs/hfsplus/btree.o
  CC      fs/nls/nls_iso8859-15.o
  CC      drivers/acpi/namespace/nsparse.o
  CC      fs/dlm/rcom.o
  CC      fs/dlm/recover.o
  LD      drivers/acpi/executer/built-in.o
  CC      drivers/acpi/utilities/utalloc.o
  CC      drivers/acpi/utilities/utdebug.o
  CC      drivers/acpi/bus.o
  CC      fs/nls/nls_koi8-r.o
  CC      fs/hfsplus/bnode.o
  CC      fs/hfsplus/brec.o
  CC      fs/nls/nls_utf8.o
  CC      fs/hfsplus/bfind.o
  CC      fs/hfsplus/tables.o
  CC      fs/hfsplus/unicode.o
  CC      fs/nfsd/export.o
fs/jfs/namei.c: In function 'jfs_ci_compare':
fs/jfs/namei.c:1600: warning: passing argument 1 of '__constant_memcpy' discards qualifiers from pointer target type
fs/jfs/namei.c:1600: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      fs/nfsd/auth.o
  CC      fs/nfs/nfs2xdr.o
  CC      fs/nfs/pagelist.o
  CC      fs/reiserfs/inode.o
  LD      drivers/acpi/tables/built-in.o
  CC      drivers/acpi/glue.o
  CC      fs/nfsd/lockd.o
  LD      net/atm/atm.o
  CC      drivers/acpi/scan.o
  CC      fs/nfsd/nfscache.o
  LD      net/atm/mpoa.o
  CC      fs/nfsd/nfsxdr.o
  CC      fs/partitions/karma.o
  CC      drivers/acpi/utilities/uteval.o
  CC      fs/nfs/proc.o
  CC      fs/jbd/journal.o
  CC      fs/sysfs/group.o
  CC      net/dccp/sysctl.o
  CC      fs/ntfs/collate.o
  CC      net/dccp/ipv4.o
  CC      fs/jfs/jfs_uniupr.o
  CC      fs/jfs/resize.o
  LD      block/built-in.o
  CC      fs/jfs/xattr.o
  CC      fs/jfs/ioctl.o
  LD      fs/lockd/lockd.o
  LD      fs/lockd/built-in.o
  CC      fs/ntfs/compress.o
  CC      net/dccp/ipv6.o
  LD      drivers/acpi/resources/built-in.o
  LD      drivers/acpi/sleep/built-in.o
  CC      drivers/acpi/ec.o
  CC      net/dccp/ccids/ccid2.o
  CC      drivers/acpi/ac.o
  CC      drivers/acpi/battery.o
  CC      fs/ntfs/debug.o
  CC      net/ieee80211/ieee80211_rx.o
  CC      fs/jfs/acl.o
  CC      net/ieee80211/ieee80211_wx.o
  CC      net/ieee80211/ieee80211_geo.o
  CC      fs/ntfs/dir.o
  AR      lib/lib.a
  CC      net/core/sysctl_net_core.o
  CC      fs/ntfs/file.o
  CC      net/core/dev.o
  CC      lib/zlib_deflate/deflate_syms.o
  CC      net/ieee80211/ieee80211_crypt.o
  CC      net/core/ethtool.o
  CC      fs/smbfs/ioctl.o
  CC      fs/hfsplus/wrapper.o
  CC      fs/smbfs/getopt.o
  LD      drivers/acpi/parser/built-in.o
  CC      drivers/acpi/utilities/utinit.o
  CC      drivers/acpi/button.o
  CC      fs/dlm/recoverd.o
  CC      fs/reiserfs/file.o
  CC      drivers/acpi/fan.o
  CC      drivers/acpi/pci_root.o
  CC      fs/nfsd/stats.o
  CC      lib/zlib_inflate/infutil.o
  CC      fs/ntfs/index.o
  LD      fs/proc/proc.o
  CC      fs/smbfs/symlink.o
  CC      lib/zlib_inflate/inftrees.o
  CC      drivers/connector/connector.o
  CC      drivers/acpi/pci_link.o
  LD      fs/proc/built-in.o
  LD      fs/configfs/configfs.o
  CC      lib/zlib_inflate/inflate_syms.o
  LD      net/can/can.o
  CC      fs/partitions/sysv68.o
  CC      net/core/dev_mcast.o
  LD      fs/configfs/built-in.o
  CC      fs/smbfs/smbiod.o
  CC      fs/dlm/requestqueue.o
  CC      fs/dlm/user.o
  LD      net/can/built-in.o
  CC      fs/nfs/read.o
  LD      fs/nls/built-in.o
  CC      fs/hfsplus/bitmap.o
  LD      fs/sysfs/built-in.o
  CC      fs/nfs/symlink.o
  LD      fs/minix/minix.o
  CC      fs/nfs/unlink.o
  LD      fs/minix/built-in.o
  CC      drivers/acpi/pci_irq.o
  CC      fs/dlm/util.o
  CC      drivers/acpi/pci_bind.o
  CC      net/key/af_key.o
  CC      fs/smbfs/request.o
  CC      fs/nfs/write.o
  CC      fs/nfs/namespace.o
  LD      drivers/dca/dca.o
  CC      fs/hfsplus/part_tbl.o
  CC      net/ipx/af_ipx.o
  LD      drivers/dca/built-in.o
  CC      net/ipx/ipx_route.o
  CC      net/core/dst.o
  LD      lib/zlib_inflate/zlib_inflate.o
  CC      net/ipx/ipx_proc.o
  CC      net/ipv6/af_inet6.o
  CC      net/core/netevent.o
  CC      drivers/dma/dmaengine.o
  LD      lib/zlib_inflate/built-in.o
  CC      net/ipv4/route.o
  CC      net/core/neighbour.o
  CC      net/llc/llc_core.o
  CC      net/ipv4/inetpeer.o
  LD      fs/fat/fat.o
  CC      net/llc/llc_input.o
  CC      net/ipv4/protocol.o
  LD      fs/fat/built-in.o
  CC      net/ipv4/ip_input.o
  CC      net/bluetooth/hci_conn.o
  CC      net/llc/llc_output.o
  CC      net/bluetooth/hci_event.o
  CC      fs/ocfs2/dcache.o
  CC      net/core/rtnetlink.o
  LD      fs/affs/affs.o
  LD      drivers/acpi/namespace/built-in.o
  LD      fs/affs/built-in.o
  CC      net/core/utils.o
  CC      drivers/acpi/power.o
  LD      net/ethernet/built-in.o
  CC      net/core/link_watch.o
  CC      drivers/acpi/processor_core.o
  CC      net/ieee80211/ieee80211_crypt_wep.o
  CC      fs/nfs/mount_clnt.o
  CC      drivers/acpi/processor_throttling.o
  CC      drivers/acpi/processor_idle.o
  CC      drivers/acpi/processor_thermal.o
  CC      fs/ocfs2/dir.o
  CC      net/netlabel/netlabel_user.o
  CC      fs/ocfs2/dlmglue.o
  CC      drivers/acpi/utilities/utmisc.o
  CC      drivers/acpi/utilities/utxface.o
  CC      drivers/acpi/thermal.o
  CC      net/core/filter.o
  CC      net/core/flow.o
  CC      net/ieee80211/softmac/ieee80211softmac_io.o
  CC      net/core/net-sysfs.o
  CC      net/ieee80211/softmac/ieee80211softmac_auth.o
  LD      lib/zlib_deflate/zlib_deflate.o
  LD      lib/zlib_deflate/built-in.o
  CC      net/core/pktgen.o
  CC      fs/ntfs/inode.o
  CC      net/ieee80211/softmac/ieee80211softmac_module.o
  CC      net/ieee80211/softmac/ieee80211softmac_scan.o
  CC      net/ipx/sysctl_net_ipx.o
  CC      drivers/acpi/utilities/utcopy.o
  CC      fs/ntfs/mft.o
  CC      fs/reiserfs/dir.o
  CC      net/ipv6/anycast.o
  CC      fs/reiserfs/fix_node.o
  CC      drivers/acpi/system.o
  CC      drivers/acpi/event.o
  LD      fs/partitions/built-in.o
  CC      drivers/acpi/utilities/utdelete.o
  CC      net/ipv6/ip6_output.o
fs/hfsplus/unicode.c: In function 'hfsplus_hash_dentry':
fs/hfsplus/unicode.c:328: warning: 'dsize' may be used uninitialized in this function
  CC      net/ipv6/ip6_input.o
  CC      drivers/acpi/utilities/utglobal.o
  CC      net/ipv6/addrconf.o
  CC      net/core/netpoll.o
  CC      fs/nfs/nfs3proc.o
  CC      net/llc/llc_if.o
  CC      fs/reiserfs/super.o
  CC      net/llc/llc_c_ev.o
  CC      fs/nfs/nfs3xdr.o
  CC      net/llc/llc_c_ac.o
  CC      net/llc/llc_conn.o
  LD      net/atm/built-in.o
  CC      net/netlink/af_netlink.o
  CC      drivers/acpi/toshiba_acpi.o
  CC      drivers/ata/libata-sff.o
  CC      drivers/acpi/acpi_memhotplug.o
  CC      fs/nfs/nfs4proc.o
  CC      drivers/acpi/utilities/utmath.o
  CC      drivers/acpi/utilities/utobject.o
  CC      drivers/acpi/cm_sbs.o
  CC      net/ipv4/ip_fragment.o
  CC      drivers/acpi/utilities/utstate.o
  CC      net/ipv4/ip_forward.o
  CC      drivers/acpi/utilities/utmutex.o
  CC      drivers/acpi/utilities/utcache.o
  CC      net/core/fib_rules.o
  CC      fs/nfs/nfs4xdr.o
  CC      drivers/acpi/utilities/utresrc.o
  CC      fs/nfs/nfs4state.o
  CC      fs/nfs/nfs4renewd.o
  CC      drivers/dma/ioat.o
  CC      drivers/dma/ioat_dma.o
  CC      drivers/dma/ioat_dca.o
  CC      fs/nfs/delegation.o
  CC      fs/nfs/idmap.o
  CC      net/ipv4/ip_options.o
  CC      fs/nfs/callback.o
  CC      fs/nfs/callback_xdr.o
  CC      net/ipv4/ip_output.o
  CC      drivers/char/n_tty.o
  CC      drivers/char/tty_ioctl.o
  CC      drivers/char/pty.o
  CC      fs/ntfs/mst.o
  CC      fs/ntfs/namei.o
  CC      drivers/firewire/fw-card.o
  CC      drivers/firewire/fw-topology.o
  CC      fs/ntfs/runlist.o
  CC      drivers/char/misc.o
  CC      fs/reiserfs/prints.o
  CC      fs/nfs/callback_proc.o
  CC      fs/nfs/nfs4namespace.o
  CC      net/ieee80211/softmac/ieee80211softmac_wx.o
  CC      net/ieee80211/softmac/ieee80211softmac_assoc.o
  CC      fs/reiserfs/objectid.o
  CC      fs/reiserfs/lbalance.o
  CC      drivers/char/vt_ioctl.o
  CC      drivers/char/vc_screen.o
  CC      drivers/char/consolemap.o
  CC      drivers/char/consolemap_deftbl.o
  CC      drivers/char/selection.o
  CC      drivers/char/keyboard.o
  CC      fs/nfs/direct.o
  CC      fs/reiserfs/ibalance.o
  CC      drivers/firewire/fw-transaction.o
  LD      fs/dlm/dlm.o
  CC      net/llc/llc_c_st.o
  CC      net/ieee80211/softmac/ieee80211softmac_event.o
  LD      fs/dlm/built-in.o
  CC      drivers/char/vt.o
  CC      net/llc/llc_pdu.o
  CC      net/llc/llc_sap.o
  CC      drivers/ata/libata-eh.o
  CC      fs/ntfs/super.o
  CC      net/bluetooth/hci_sock.o
  CC      fs/nfs/sysctl.o
  LD      fs/jbd/jbd.o
  CC      drivers/ata/libata-pmp.o
  LD      fs/jbd/built-in.o
  CC      drivers/ata/libata-acpi.o
  CC      drivers/char/defkeymap.o
  CC      drivers/char/sysrq.o
  CC      drivers/char/cyclades.o
  CC      net/bluetooth/hci_sysfs.o
  CC      drivers/char/nozomi.o
  CC      drivers/ata/ahci.o
  CC      drivers/ata/sata_svw.o
  CC      net/ipv6/addrlabel.o
  CC      drivers/char/epca.o
  LD      fs/hfsplus/hfsplus.o
  CC      drivers/char/moxa.o
  LD      drivers/acpi/utilities/built-in.o
  LD      fs/hfsplus/built-in.o
  CC      drivers/char/mxser.o
  CC      net/bluetooth/lib.o
  CC      net/bluetooth/l2cap.o
net/netlabel/netlabel_user.c: In function 'netlbl_audit_start_common':
net/netlabel/netlabel_user.c:99: warning: unused variable 'audit_ctx'
  CC      drivers/char/agp/backend.o
  LD      fs/smbfs/smbfs.o
  CC      net/llc/llc_s_ac.o
  CC      net/netlabel/netlabel_kapi.o
  LD      fs/smbfs/built-in.o
  CC      net/packet/af_packet.o
  CC      net/netlabel/netlabel_domainhash.o
  CC      drivers/hwmon/hwmon.o
  CC      fs/reiserfs/stree.o
  CC      drivers/input/input.o
  CC      fs/ntfs/unistr.o
  CC      fs/ntfs/upcase.o
  CC      drivers/infiniband/core/addr.o
  CC      drivers/firmware/dmi_scan.o
  CC      net/llc/llc_s_ev.o
  CC      drivers/ata/ata_piix.o
  CC      fs/ntfs/bitmap.o
  LD      fs/ecryptfs/ecryptfs.o
  CC      drivers/infiniband/hw/mlx4/ah.o
  LD      fs/ecryptfs/built-in.o
  CC      drivers/infiniband/hw/mlx4/cq.o
  CC      drivers/ata/sata_promise.o
  CC      drivers/hwmon/hwmon-vid.o
  CC      net/ipv4/ip_sockglue.o
  CC      drivers/hwmon/abituguru.o
  CC      drivers/char/hw_random/core.o
  CC      drivers/char/hw_random/geode-rng.o
  CC      drivers/char/drm/drm_auth.o
  CC      drivers/firewire/fw-iso.o
  CC      drivers/hwmon/abituguru3.o
  CC      drivers/firewire/fw-device.o
  CC      drivers/char/riscom8.o
  CC      drivers/char/ip2/ip2base.o
  CC      drivers/hwmon/coretemp.o
  CC      net/ipv6/route.o
  CC      net/ipv6/ip6_fib.o
  CC      drivers/char/synclink.o
  CC      drivers/char/rio/rio_linux.o
  CC      drivers/firewire/fw-cdev.o
  CC      net/llc/llc_s_st.o
  CC      net/llc/af_llc.o
  LD      drivers/connector/cn.o
  CC      net/llc/llc_station.o
  CC      fs/ocfs2/export.o
  LD      net/ieee80211/softmac/ieee80211softmac.o
  CC      drivers/hwmon/it87.o
  LD      net/ieee80211/softmac/built-in.o
  LD      drivers/connector/built-in.o
  LD      net/dccp/ccids/dccp_ccid2.o
  CC      drivers/input/gameport/gameport.o
  CC      net/ipv4/inet_hashtables.o
  LD      net/dccp/ccids/built-in.o
  CC      fs/ocfs2/extent_map.o
  CC      drivers/input/serio/serio.o
  CC      drivers/input/serio/i8042.o
  CC      fs/ocfs2/file.o
  CC      net/bluetooth/bnep/core.o
  CC      net/bluetooth/bnep/sock.o
  CC      net/llc/llc_proc.o
  CC      drivers/infiniband/hw/mlx4/doorbell.o
  CC      drivers/infiniband/hw/mlx4/mad.o
  LD      drivers/dma/ioatdma.o
  LD      drivers/dma/built-in.o
  LD      lib/built-in.o
  CC      fs/ntfs/lcnalloc.o
  CC      fs/reiserfs/hashes.o
  CC      drivers/leds/led-core.o
  CC      fs/ntfs/logfile.o
  CC      net/ipv6/ipv6_sockglue.o
  CC      fs/ntfs/quota.o
  CC      drivers/hwmon/smsc47m1.o
  CC      drivers/hwmon/vt1211.o
net/bluetooth/hci_sysfs.c: In function 'del_conn':
net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assignment used as truth value
  LD      drivers/acpi/processor.o
  CC      drivers/leds/led-triggers.o
  CC      drivers/hwmon/vt8231.o
  CC      fs/reiserfs/tail_conversion.o
  CC      drivers/char/rio/rioinit.o
  CC      net/llc/sysctl_net_llc.o
  CC      fs/reiserfs/journal.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/infiniband/hw/mlx4/main.o
  CC      drivers/firmware/edd.o
  LD      drivers/acpi/built-in.o
  CC      drivers/lguest/lguest_device.o
  CC      drivers/firmware/dcdbas.o
  CC      net/netlink/attr.o
  CC      drivers/mca/mca-bus.o
  CC      net/netlink/genetlink.o
  CC      drivers/mca/mca-device.o
  CC      net/ipv4/inet_timewait_sock.o
  CC      drivers/mca/mca-driver.o
  CC      drivers/char/synclink_gt.o
  LD      net/ieee80211/ieee80211.o
  CC      drivers/char/n_hdlc.o
  CC      drivers/firmware/dmi-id.o
  LD      net/ieee80211/built-in.o
  CC      net/ipv4/inet_connection_sock.o
  LD      fs/ext3/ext3.o
  CC      drivers/char/sx.o
  LD      fs/ext3/built-in.o
  CC      net/rfkill/rfkill.o
  CC      drivers/char/generic_serial.o
  LD      fs/nfsd/nfsd.o
  CC      net/rfkill/rfkill-input.o
  LD      fs/nfsd/built-in.o
  CC      fs/ntfs/usnjrnl.o
  CC      net/sched/sch_generic.o
  CC      drivers/ata/sata_via.o
  CC      drivers/infiniband/core/cm.o
  CC      drivers/ata/sata_sx4.o
  CC      drivers/ata/sata_nv.o
fs/nfs/callback_xdr.c: In function 'nfs4_callback_compound':
fs/nfs/callback_xdr.c:404: warning: 'hdr_arg.taglen' may be used uninitialized in this function
fs/nfs/callback_xdr.c:404: warning: 'hdr_arg.tag' may be used uninitialized in this function
fs/nfs/callback_xdr.c:404: warning: 'hdr_arg.nops' may be used uninitialized in this function
  CC      drivers/ata/sata_mv.o
  CC      drivers/char/drm/drm_bufs.o
  CC      net/netlabel/netlabel_mgmt.o
  CC      drivers/ata/sata_inic162x.o
  CC      drivers/ata/pata_amd.o
  CC      net/sctp/sm_statetable.o
  CC      drivers/char/hvc_console.o
  LD      drivers/char/hw_random/rng-core.o
  LD      drivers/char/hw_random/built-in.o
  CC      drivers/mca/mca-proc.o
  CC      drivers/char/virtio_console.o
  CC      net/bluetooth/bnep/netdev.o
  CC      net/sctp/sm_statefuns.o
  CC      drivers/char/ip2/ip2main.o
  CC      drivers/ata/pata_artop.o
  CC      drivers/infiniband/hw/mlx4/mr.o
  CC      fs/reiserfs/resize.o
  CC      fs/reiserfs/item_ops.o
  CC      fs/reiserfs/ioctl.o
  CC      fs/reiserfs/procfs.o
  CC      drivers/char/agp/frontend.o
  LD      net/packet/built-in.o
fs/nfs/nfs4proc.c: In function 'nfs4_async_handle_error':
fs/nfs/nfs4proc.c:2771: warning: passing argument 1 of 'nfs_inc_server_stats' discards qualifiers from pointer target type
  CC      net/wireless/wext.o
  LD      drivers/crypto/built-in.o
  CC      drivers/infiniband/hw/mlx4/qp.o
  CC      net/sunrpc/clnt.o
  CC      net/x25/af_x25.o
  CC      drivers/infiniband/hw/mlx4/srq.o
  CC      drivers/mfd/sm501.o
  CC      net/unix/af_unix.o
  CC      fs/ocfs2/heartbeat.o
  CC      drivers/mca/mca-legacy.o
  CC      net/unix/garbage.o
In file included from drivers/mca/mca-legacy.c:31:
include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy - please move your driver to the new sysfs api"
  CC      net/unix/sysctl_net_unix.o
  CC      fs/reiserfs/xattr.o
  CC      fs/ocfs2/inode.o
  CC      drivers/misc/msi-laptop.o
  CC      drivers/message/i2o/bus-osm.o
  CC      drivers/misc/phantom.o
  CC      drivers/char/drm/drm_context.o
  CC      drivers/char/rio/rioboot.o
  CC      drivers/misc/sony-laptop.o
  CC      drivers/char/raw.o
  LD      drivers/firewire/firewire-core.o
  LD      drivers/firewire/built-in.o
  CC      drivers/misc/ibmasm/module.o
  CC      net/ipv4/tcp.o
  LD      drivers/leds/built-in.o
  CC      drivers/misc/ibmasm/ibmasmfs.o
  LD      net/rfkill/built-in.o
  CC      net/xfrm/xfrm_policy.o
  CC      drivers/misc/ibmasm/event.o
  CC      drivers/misc/ibmasm/command.o
  CC      drivers/misc/ibmasm/remote.o
  CC      drivers/pci/access.o
  CC      fs/reiserfs/xattr_user.o
  LD      drivers/mca/built-in.o
  CC      net/netlabel/netlabel_unlabeled.o
  CC      fs/reiserfs/xattr_trusted.o
  CC      drivers/net/bonding/bond_main.o
  CC      drivers/pci/bus.o
  CC      drivers/pci/probe.o
  CC      drivers/pcmcia/ds.o
  CC      fs/reiserfs/xattr_security.o
  CC      fs/reiserfs/xattr_acl.o
  CC      drivers/pcmcia/pcmcia_resource.o
  CC      drivers/pcmcia/pcmcia_ioctl.o
  CC      drivers/ata/pata_cmd640.o
  CC      drivers/input/serio/serport.o
  CC      net/ipv4/tcp_input.o
  CC      fs/ocfs2/ioctl.o
drivers/ata/sata_via.c: In function 'svia_init_one':
drivers/ata/sata_via.c:506: warning: 'host' may be used uninitialized in this function
  CC      drivers/ata/pata_efar.o
  CC      drivers/ata/pata_hpt366.o
  CC      drivers/ata/pata_hpt37x.o
  CC      drivers/ata/pata_jmicron.o
  CC      net/ipv6/ndisc.o
  CC      drivers/misc/thinkpad_acpi.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/lguest/built-in.o
  LD      net/wireless/built-in.o
  CC      fs/ocfs2/journal.o
  CC      net/sysctl_net.o
  CC      drivers/char/rio/riocmd.o
  LD      drivers/firmware/built-in.o
  CC      drivers/char/rio/rioctrl.o
  CC      net/ipv6/udp.o
  CC      drivers/char/agp/generic.o
  CC      drivers/char/rio/riointr.o
  LD      net/sched/built-in.o
  CC      drivers/char/rio/rioparam.o
  CC      drivers/pnp/core.o
  CC      drivers/pnp/card.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/misc/ibmasm/heartbeat.o
  CC      drivers/misc/ibmasm/r_heartbeat.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/misc/ibmasm/dot_command.o
  CC      drivers/pci/remove.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/misc/ibmasm/lowlevel.o
  CC      drivers/char/applicom.o
  CC      drivers/pcmcia/cs.o
  CC      drivers/power/power_supply_core.o
  CC      drivers/pci/pci.o
  CC      drivers/char/genrtc.o
  CC      net/ipv6/udplite.o
  CC      net/ipv6/raw.o
  CC      drivers/char/nvram.o
  CC      drivers/input/serio/ct82c710.o
  CC      drivers/pci/quirks.o
  CC      drivers/pnp/driver.o
  CC      drivers/ata/pata_netcell.o
  CC      drivers/pnp/resource.o
  CC      drivers/pci/pci-driver.o
  CC      drivers/char/toshiba.o
  CC      drivers/char/i8k.o
  CC      drivers/power/power_supply_sysfs.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/pci/search.o
  CC      drivers/misc/ibmasm/uart.o
  CC      drivers/pci/pci-sysfs.o
  CC      drivers/input/gameport/emu10k1-gp.o
  CC      drivers/pci/rom.o
  CC      drivers/ata/pata_marvell.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/pnp/manager.o
  CC      fs/ocfs2/localalloc.o
  CC      drivers/ata/pata_oldpiix.o
  CC      drivers/pci/setup-res.o
  CC      drivers/pci/proc.o
  CC      drivers/message/i2o/iop.o
  CC      drivers/ata/pata_pdc2027x.o
  CC      drivers/ata/pata_pdc202xx_old.o
  CC      drivers/ata/pata_radisys.o
  CC      drivers/input/serio/libps2.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/char/tlclk.o
  CC      drivers/ata/pata_rz1000.o
  CC      drivers/power/power_supply_leds.o
  CC      drivers/ata/pata_serverworks.o
  CC      drivers/ata/pata_sl82c105.o
  CC      drivers/input/serio/serio_raw.o
  CC      drivers/ata/pata_sis.o
  CC      drivers/ata/pata_triflex.o
drivers/char/applicom.c:68: warning: 'applicom_pci_tbl' defined but not used
  CC      fs/ocfs2/locks.o
  CC      drivers/ata/ata_generic.o
  CC      drivers/power/pda_power.o
  CC      net/ipv4/tcp_output.o
  CC      fs/ocfs2/mmap.o
  CC      fs/ocfs2/namei.o
  CC      drivers/pnp/support.o
  LD      net/dccp/dccp.o
  LD      net/dccp/dccp_ipv4.o
  LD      net/dccp/dccp_ipv6.o
  CC      drivers/pnp/interface.o
  LD      drivers/infiniband/hw/mlx4/mlx4_ib.o
  LD      net/dccp/built-in.o
  CC      drivers/pnp/quirks.o
  CC      net/sunrpc/xprt.o
  CC      net/sunrpc/socklib.o
  LD      drivers/infiniband/hw/mlx4/built-in.o
  CC      drivers/pci/hotplug/pci_hotplug_core.o
  CC      drivers/char/rio/rioroute.o
  CC      drivers/pci/hotplug/acpi_pcihp.o
  CC      drivers/char/drm/drm_dma.o
  CC      drivers/pcmcia/cistpl.o
  CC      drivers/input/gameport/lightning.o
  CC      drivers/power/ds2760_battery.o
  CC      drivers/char/drm/drm_drawable.o
  CC      drivers/char/rio/riotable.o
  CC      drivers/infiniband/hw/mthca/mthca_main.o
  LD      drivers/mfd/built-in.o
  CC      net/ipv6/protocol.o
  CC      drivers/pci/pcie/portdrv_core.o
  CC      net/sctp/sm_sideeffect.o
  CC      net/ipv4/tcp_timer.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      net/bluetooth/bnep/bnep.o
  LD      net/bluetooth/bnep/built-in.o
  CC      net/ipv6/icmp.o
  CC      drivers/char/rio/riotty.o
  CC      fs/ocfs2/resize.o
drivers/char/riscom8.c: In function 'rc_init_CD180':
drivers/char/riscom8.c:220: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:220: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:224: warning: 'sti' is deprecated (declared at include/linux/interrupt.h:211)
drivers/char/riscom8.c:226: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:237: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_setup_port':
drivers/char/riscom8.c:816: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:816: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:828: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'block_til_ready':
drivers/char/riscom8.c:939: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:942: warning: 'sti' is deprecated (declared at include/linux/interrupt.h:211)
drivers/char/riscom8.c:945: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:951: warning: 'sti' is deprecated (declared at include/linux/interrupt.h:211)
drivers/char/riscom8.c: In function 'rc_close':
drivers/char/riscom8.c:1024: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1024: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1091: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_write':
drivers/char/riscom8.c:1110: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1112: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1116: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c:1123: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c:1130: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1137: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_put_char':
drivers/char/riscom8.c:1153: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1153: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1161: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_flush_chars':
drivers/char/riscom8.c:1176: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1176: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1180: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_flush_buffer':
drivers/char/riscom8.c:1215: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1215: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1217: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_tiocmget':
drivers/char/riscom8.c:1234: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1234: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1238: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_tiocmset':
drivers/char/riscom8.c:1259: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1259: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1273: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_send_break':
drivers/char/riscom8.c:1282: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1282: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1292: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_set_serial_info':
drivers/char/riscom8.c:1335: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1335: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1337: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_throttle':
drivers/char/riscom8.c:1418: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1418: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1427: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_unthrottle':
drivers/char/riscom8.c:1441: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1441: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1450: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_stop':
drivers/char/riscom8.c:1464: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1464: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1468: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_start':
drivers/char/riscom8.c:1482: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1482: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1488: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_set_termios':
drivers/char/riscom8.c:1540: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1540: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1542: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
drivers/char/riscom8.c: In function 'rc_release_drivers':
drivers/char/riscom8.c:1630: warning: 'save_flags' is deprecated (declared at include/linux/interrupt.h:215)
drivers/char/riscom8.c:1631: warning: 'cli' is deprecated (declared at include/linux/interrupt.h:207)
drivers/char/riscom8.c:1634: warning: 'restore_flags' is deprecated (declared at include/linux/interrupt.h:220)
  CC      drivers/infiniband/ulp/ipoib/ipoib_main.o
  CC      drivers/rtc/rtc-lib.o
  CC      drivers/pnp/system.o
  CC      drivers/pci/hotplug.o
  CC      drivers/pci/setup-bus.o
  CC      drivers/pcmcia/rsrc_mgr.o
  LD      net/ipx/ipx.o
  CC      drivers/char/drm/drm_drv.o
  LD      net/ipx/built-in.o
  CC      drivers/infiniband/ulp/ipoib/ipoib_ib.o
  CC      drivers/pcmcia/socket_sysfs.o
  CC      drivers/infiniband/ulp/ipoib/ipoib_multicast.o
  LD      net/netlink/built-in.o
  LD      net/key/built-in.o
  CC      drivers/infiniband/ulp/ipoib/ipoib_verbs.o
  CC      drivers/char/drm/drm_fops.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      net/netlabel/netlabel_cipso_v4.o
  LD      drivers/misc/ibmasm/ibmasm.o
  CC      drivers/pci/pci-acpi.o
  LD      drivers/misc/ibmasm/built-in.o
  CC      drivers/char/drm/drm_ioctl.o
  CC      net/ipv6/mcast.o
  CC      drivers/pcmcia/rsrc_nonstatic.o
  CC      drivers/pcmcia/pd6729.o
  CC      drivers/char/drm/drm_irq.o
  CC      net/ipv6/reassembly.o
  CC      drivers/pnp/pnpacpi/core.o
  CC      drivers/pnp/pnpacpi/rsparser.o
  LD      net/llc/llc.o
  LD      net/llc/llc2.o
  CC      drivers/net/bonding/bond_3ad.o
  CC      net/ipv6/tcp_ipv6.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/power/power_supply.o
  CC      drivers/char/drm/drm_lock.o
  CC      drivers/char/agp/isoch.o
  CC      drivers/char/agp/amd-k7-agp.o
  CC      drivers/infiniband/ulp/ipoib/ipoib_vlan.o
  LD      drivers/power/built-in.o
  LD      net/bluetooth/bluetooth.o
  LD      net/llc/built-in.o
  CC      drivers/infiniband/ulp/ipoib/ipoib_fs.o
  LD      drivers/hwmon/built-in.o
  CC      drivers/serial/serial_core.o
  CC      drivers/ssb/main.o
  CC      drivers/ssb/scan.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/ssb/pci.o
  LD      drivers/input/gameport/built-in.o
  CC      drivers/ssb/pcihost_wrapper.o
  CC      drivers/ssb/driver_chipcommon.o
  CC      drivers/rtc/class.o
  CC      drivers/telephony/phonedev.o
  CC      drivers/usb/gadget/goku_udc.o
  CC      drivers/usb/class/cdc-acm.o
  CC      drivers/usb/class/usblp.o
  CC      drivers/pci/hotplug/pciehp_core.o
  CC      net/ipv4/tcp_ipv4.o
  CC      drivers/scsi/aacraid/linit.o
  CC      drivers/usb/core/usb.o
  CC      net/ipv4/tcp_minisocks.o
  CC      net/ipv4/tcp_cong.o
  CC      fs/ocfs2/slot_map.o
  CC      drivers/scsi/aic7xxx/aic79xx_core.o
  LD      drivers/misc/built-in.o
  CC      drivers/ssb/driver_pcicore.o
  CC      drivers/video/fb_notify.o
  CC      drivers/virtio/virtio.o
  CC      fs/ocfs2/suballoc.o
  CC      fs/ocfs2/super.o
  CC      net/sunrpc/xprtsock.o
  CC      net/sunrpc/sched.o
  CC      drivers/char/drm/drm_memory.o
  CC      net/sunrpc/auth.o
  CC      fs/ocfs2/symlink.o
  CC      net/sunrpc/auth_null.o
  CC      fs/ocfs2/sysfile.o
  CC      drivers/char/agp/amd64-agp.o
  CC      net/sunrpc/auth_unix.o
  CC      net/sunrpc/svc.o
  CC      net/sunrpc/svcsock.o
  CC      drivers/char/agp/intel-agp.o
  CC      net/sunrpc/svcauth.o
  CC      drivers/telephony/ixj.o
  CC      net/ipv4/datagram.o
  CC      drivers/char/drm/drm_proc.o
  CC      drivers/char/drm/drm_stub.o
  CC      drivers/char/drm/drm_vm.o
  CC      net/ipv4/raw.o
  CC      drivers/char/drm/drm_agpsupport.o
  CC      drivers/char/drm/drm_scatter.o
  CC      drivers/pci/hotplug/pciehp_ctrl.o
  CC      drivers/pci/hotplug/pciehp_pci.o
  CC      drivers/virtio/virtio_ring.o
  LD      drivers/input/serio/built-in.o
  CC      drivers/pci/hotplug/pciehp_hpc.o
  CC      net/sunrpc/svcauth_unix.o
  LD      drivers/ata/libata.o
  CC      net/sunrpc/rpcb_clnt.o
  LD      fs/jfs/jfs.o
  LD      fs/jfs/built-in.o
  CC      net/sunrpc/timer.o
  CC      drivers/ssb/b43_pci_bridge.o
  CC      drivers/w1/w1.o
  CC      drivers/w1/w1_int.o
  CC      drivers/watchdog/acquirewdt.o
  CC      drivers/w1/w1_family.o
  CC      net/ipv6/exthdrs.o
  CC      drivers/rtc/interface.o
  CC      drivers/w1/w1_netlink.o
  CC      net/ipv6/datagram.o
  CC      drivers/watchdog/advantechwdt.o
  CC      drivers/input/ff-core.o
  CC      net/ipv6/ip6_flowlabel.o
  LD      fs/ntfs/ntfs.o
  CC      drivers/char/agp/sis-agp.o
  CC      drivers/input/ff-memless.o
  LD      fs/ntfs/built-in.o
  CC      net/ipv6/inet6_connection_sock.o
  CC      drivers/rtc/rtc-dev.o
  CC      drivers/rtc/rtc-ds1742.o
  CC      drivers/pci/pcie/portdrv_pci.o
  CC      net/ipv4/udp.o
  CC      drivers/char/drm/ati_pcigart.o
  CC      drivers/char/drm/drm_pci.o
  CC      net/ipv4/udplite.o
  CC      drivers/char/drm/drm_sysfs.o
  CC      drivers/char/drm/drm_hashtab.o
  CC      net/sunrpc/xdr.o
  CC      net/sunrpc/sunrpc_syms.o
  LD      drivers/virtio/built-in.o
  CC      net/ipv4/arp.o
  CC      net/ipv6/sysctl_net_ipv6.o
  CC      drivers/char/drm/drm_sman.o
  CC      fs/ocfs2/uptodate.o
  CC      net/sunrpc/cache.o
  CC      net/ipv6/xfrm6_policy.o
  CC      net/sunrpc/rpc_pipe.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/usb/core/hub.o
  CC      net/sunrpc/svc_xprt.o
  CC      drivers/usb/core/hcd.o
  CC      drivers/net/bonding/bond_alb.o
  CC      drivers/rtc/rtc-stk17ta8.o
  CC      drivers/char/drm/drm_mm.o
  CC      net/sunrpc/stats.o
  CC      drivers/video/backlight/lcd.o
  CC      net/ipv4/icmp.o
  CC      drivers/char/agp/via-agp.o
  LD      drivers/char/agp/agpgart.o
  CC      net/ipv4/devinet.o
  CC      drivers/char/drm/i915_drv.o
  CC      drivers/input/input-polldev.o
  CC      net/sunrpc/sysctl.o
  CC      fs/ocfs2/ver.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/watchdog/ib700wdt.o
  CC      net/sunrpc/auth_gss/auth_gss.o
  CC      drivers/watchdog/ibmasr.o
  CC      drivers/char/drm/i915_dma.o
  CC      net/x25/x25_dev.o
  CC      drivers/infiniband/hw/mthca/mthca_cmd.o
  CC      drivers/rtc/rtc-test.o
  CC      drivers/rtc/rtc-v3020.o
  CC      net/ipv6/xfrm6_state.o
  CC      net/ipv6/xfrm6_input.o
  CC      drivers/char/drm/i915_irq.o
  CC      net/ipv4/af_inet.o
  CC      drivers/input/mousedev.o
  CC      drivers/watchdog/wafer5823wdt.o
  CC      drivers/char/drm/i915_mem.o
  LD      drivers/rtc/rtc-core.o
  CC      drivers/char/drm/mga_drv.o
  CC      drivers/usb/host/pci-quirks.o
  CC      drivers/watchdog/i6300esb.o
  CC      drivers/char/drm/mga_dma.o
  CC      drivers/usb/core/urb.o
  CC      drivers/usb/image/mdc800.o
  CC      drivers/char/drm/mga_state.o
  CC      drivers/usb/gadget/file_storage.o
  CC      drivers/w1/w1_io.o
  CC      drivers/input/evdev.o
  CC      fs/ocfs2/cluster/heartbeat.o
  LD      drivers/pnp/pnpacpi/built-in.o
  CC      net/ipv6/xfrm6_output.o
  CC      drivers/char/drm/mga_warp.o
  LD      drivers/pnp/built-in.o
  CC      drivers/w1/masters/ds2490.o
  CC      drivers/w1/slaves/w1_ds2760.o
  CC      drivers/scsi/aacraid/aachba.o
  CC      fs/ocfs2/cluster/masklog.o
  CC      net/xfrm/xfrm_state.o
  LD      net/bluetooth/built-in.o
  CC      net/xfrm/xfrm_hash.o
  CC      drivers/watchdog/pc87413_wdt.o
  CC      fs/ocfs2/cluster/sys.o
  CC      drivers/char/drm/mga_irq.o
  CC      net/ipv6/fib6_rules.o
  CC      drivers/char/drm/radeon_drv.o
  CC      drivers/char/drm/radeon_cp.o
  CC      net/ipv6/proc.o
  CC      drivers/char/drm/radeon_state.o
net/core/dev.c: In function 'net_rx_action':
net/core/dev.c:2211: warning: passing argument 2 of 'print_symbol' makes integer from pointer without a cast
  CC      drivers/scsi/aacraid/commctrl.o
  CC      fs/ocfs2/dlm/dlmdomain.o
  CC      drivers/scsi/aacraid/comminit.o
  LD      net/core/built-in.o
  CC      fs/ocfs2/dlm/dlmdebug.o
  CC      drivers/scsi/aacraid/commsup.o
  CC      drivers/watchdog/sbc60xxwdt.o
  CC      drivers/pci/hotplug/fakephp.o
  CC      net/ipv4/igmp.o
  CC      drivers/video/backlight/backlight.o
  CC      net/ipv4/fib_frontend.o
  CC      net/ipv4/fib_semantics.o
  CC      drivers/pci/pcie/portdrv_bus.o
  CC      net/ipv4/inet_fragment.o
  CC      drivers/usb/core/message.o
  CC      drivers/watchdog/sbc8360.o
  CC      drivers/char/drm/radeon_mem.o
  CC      drivers/char/drm/radeon_irq.o
  CC      fs/ocfs2/cluster/nodemanager.o
  LD      fs/reiserfs/reiserfs.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      fs/ocfs2/cluster/quorum.o
  CC      drivers/message/i2o/driver.o
  CC      drivers/char/drm/r300_cmdbuf.o
  LD      fs/reiserfs/built-in.o
  CC      drivers/char/drm/sis_drv.o
  CC      net/x25/x25_facilities.o
  CC      net/x25/x25_in.o
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      net/ipv4/fib_trie.o
drivers/char/ip2/i2ellis.c:101: warning: 'iiEllisCleanup' defined but not used
drivers/char/ip2/ip2main.c:3207: warning: 'ip2main_pci_tbl' defined but not used
  CC      drivers/watchdog/cpu5wdt.o
  CC      drivers/usb/gadget/usbstring.o
  LD      drivers/char/ip2/ip2.o
  LD      drivers/char/ip2/built-in.o
  CC      net/ipv6/esp6.o
  CC      drivers/watchdog/machzwd.o
  CC      net/ipv4/proc.o
  CC      drivers/video/console/dummycon.o
  LD      drivers/ssb/ssb.o
  CC      net/ipv4/fib_rules.o
  CC      drivers/usb/core/driver.o
  LD      drivers/ssb/built-in.o
  CC      drivers/char/drm/sis_mm.o
  CC      net/ipv4/ah4.o
  CC      drivers/usb/core/config.o
  CC      drivers/usb/core/file.o
  CC      fs/ocfs2/cluster/tcp.o
  LD      net/netlabel/built-in.o
  CC      drivers/usb/gadget/config.o
  CC      net/ipv6/ipcomp6.o
  CC      drivers/usb/gadget/epautoconf.o
  CC      drivers/char/drm/tdfx_drv.o
  CC      drivers/char/drm/via_irq.o
  CC      drivers/char/drm/via_drv.o
  CC      drivers/watchdog/sbc_epx_c3.o
  CC      drivers/char/drm/via_map.o
  CC      net/xfrm/xfrm_input.o
  CC      net/ipv6/xfrm6_tunnel.o
  LD      drivers/w1/slaves/built-in.o
  CC      net/ipv4/ipcomp.o
  CC      drivers/usb/core/buffer.o
  CC      net/ipv4/xfrm4_tunnel.o
  CC      drivers/char/drm/via_mm.o
  LD      drivers/pci/hotplug/pci_hotplug.o
  CC      net/ipv6/tunnel6.o
  LD      drivers/pci/hotplug/pciehp.o
  LD      drivers/pci/pcie/pcieportdrv.o
  CC      drivers/usb/core/sysfs.o
  CC      net/ipv6/xfrm6_mode_transport.o
  CC      drivers/char/drm/via_dma.o
  CC      drivers/pci/pcie/aer/aerdrv_errprint.o
  CC      drivers/pci/pcie/aer/aerdrv_core.o
drivers/w1/masters/ds2490.c: In function 'ds9490r_write_block':
drivers/w1/masters/ds2490.c:775: warning: passing argument 2 of 'ds_write_block' discards qualifiers from pointer target type
  CC      drivers/video/console/vgacon.o
  LD      drivers/w1/masters/built-in.o
  CC      drivers/pci/pcie/aer/aerdrv.o
  CC      drivers/char/drm/via_verifier.o
  CC      net/ipv4/tunnel4.o
  LD      drivers/rtc/built-in.o
  CC      drivers/char/drm/via_video.o
  CC      drivers/char/drm/via_dmablit.o
  CC      net/ipv4/ipconfig.o
  CC      net/ipv4/tcp_bic.o
  LD      drivers/char/agp/built-in.o
  CC      net/ipv4/tcp_westwood.o
  LD      drivers/char/rio/rio.o
  CC      drivers/usb/image/microtek.o
  LD      drivers/usb/class/built-in.o
  CC      drivers/usb/core/endpoint.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/char/rio/built-in.o
  CC      drivers/input/misc/atlas_btns.o
  CC      drivers/input/keyboard/atkbd.o
  CC      drivers/input/tablet/gtco.o
  CC      drivers/input/tablet/wacom_wac.o
  CC      drivers/usb/misc/adutux.o
  CC      drivers/usb/mon/mon_main.o
  CC      drivers/usb/misc/appledisplay.o
  LD      drivers/pci/hotplug/built-in.o
  CC      drivers/usb/misc/auerswald.o
  CC      drivers/usb/misc/berry_charge.o
  CC      drivers/input/touchscreen/elo.o
  CC      drivers/input/tablet/wacom_sys.o
  CC      drivers/input/touchscreen/mk712.o
  CC      drivers/input/touchscreen/penmount.o
  CC      drivers/input/touchscreen/touchwin.o
  LD      drivers/ata/built-in.o
  CC      net/ipv4/tcp_highspeed.o
  CC      net/ipv4/cipso_ipv4.o
  CC      drivers/usb/host/ehci-hcd.o
  CC      drivers/usb/host/ohci-hcd.o
  CC      drivers/usb/host/uhci-hcd.o
  CC      net/ipv4/xfrm4_policy.o
  CC      drivers/usb/core/devio.o
  CC      drivers/usb/core/notify.o
  CC      drivers/input/touchscreen/ucb1400_ts.o
  CC      net/ipv4/xfrm4_state.o
  CC      net/x25/x25_link.o
  CC      net/ipv6/xfrm6_mode_ro.o
  CC      net/x25/x25_out.o
  CC      drivers/message/i2o/device.o
  CC      drivers/video/backlight/corgi_bl.o
  LD      net/unix/unix.o
  CC      drivers/pci/pcie/aer/aerdrv_acpi.o
  LD      net/unix/built-in.o
  CC      net/ipv4/xfrm4_input.o
  CC      net/ipv4/xfrm4_output.o
  CC      net/x25/x25_route.o
drivers/net/bonding/bond_main.c: In function 'bond_dev_queue_xmit':
drivers/net/bonding/bond_main.c:386: warning: 'vlan_id' may be used uninitialized in this function
  LD      drivers/pcmcia/pcmcia_core.o
  LD      drivers/pcmcia/pcmcia.o
  CC      drivers/input/misc/ati_remote.o
  LD      drivers/pcmcia/built-in.o
  CC      drivers/net/bonding/bond_sysfs.o
  CC      drivers/input/misc/ati_remote2.o
  CC      drivers/usb/misc/cypress_cy7c63.o
  CC      drivers/input/misc/keyspan_remote.o
  CC      drivers/input/misc/powermate.o
  CC      net/sunrpc/auth_gss/gss_generic_token.o
  CC      net/sctp/protocol.o
  CC      drivers/usb/misc/cytherm.o
  CC      net/x25/x25_subr.o
  CC      net/sctp/endpointola.o
  CC      drivers/usb/misc/emi62.o
  LD      drivers/watchdog/built-in.o
  CC      net/sctp/associola.o
  CC      net/ipv6/xfrm6_mode_beet.o
  CC      net/ipv6/addrconf_core.o
  CC      net/ipv6/exthdrs_core.o
  CC      net/ipv6/inet6_hashtables.o
  CC      drivers/usb/core/generic.o
  CC      drivers/usb/host/sl811-hcd.o
  CC      drivers/usb/core/quirks.o
  CC      net/sctp/transport.o
  CC      drivers/scsi/aacraid/dpcsup.o
  CC      drivers/scsi/aacraid/rx.o
  CC      net/sctp/chunk.o
  CC      drivers/scsi/aacraid/sa.o
  CC      drivers/usb/core/hcd-pci.o
  CC      drivers/usb/core/inode.o
  CC      drivers/usb/misc/ftdi-elan.o
  CC      drivers/infiniband/ulp/srp/ib_srp.o
  CC      drivers/input/keyboard/lkkbd.o
  CC      drivers/input/keyboard/newtonkbd.o
  CC      drivers/net/can/vcan.o
  CC      drivers/infiniband/hw/mthca/mthca_profile.o
  CC      drivers/infiniband/hw/mthca/mthca_reset.o
  CC      drivers/infiniband/hw/mthca/mthca_allocator.o
  CC      net/sunrpc/auth_gss/gss_mech_switch.o
  CC      drivers/net/e1000/e1000_main.o
  CC      fs/ocfs2/cluster/ver.o
  CC      drivers/infiniband/hw/mthca/mthca_eq.o
  CC      drivers/usb/core/devices.o
  CC      drivers/net/e1000/e1000_hw.o
  CC      drivers/usb/misc/iowarrior.o
  CC      net/sctp/sm_make_chunk.o
  CC      net/sctp/ulpevent.o
  CC      drivers/net/e1000/e1000_ethtool.o
  LD      drivers/usb/image/built-in.o
  CC      drivers/net/e1000/e1000_param.o
  CC      drivers/scsi/aacraid/rkt.o
  CC      drivers/usb/storage/libusual.o
  CC      drivers/input/misc/yealink.o
  CC      drivers/usb/serial/usb-serial.o
  CC      drivers/usb/misc/phidget.o
  CC      drivers/usb/misc/usbtest.o
  CC      drivers/usb/mon/mon_stat.o
  CC      drivers/usb/misc/trancevibrator.o
  CC      net/sunrpc/auth_gss/svcauth_gss.o
  LD      drivers/w1/wire.o
  CC      drivers/usb/mon/mon_text.o
  CC      net/sunrpc/auth_gss/gss_krb5_crypto.o
  LD      drivers/w1/built-in.o
  CC      net/x25/x25_timer.o
  CC      drivers/usb/serial/generic.o
  CC      net/sunrpc/auth_gss/gss_krb5_mech.o
  CC      net/sunrpc/auth_gss/gss_krb5_seal.o
  CC      drivers/usb/mon/mon_bin.o
  CC      net/sunrpc/auth_gss/gss_krb5_unseal.o
  CC      drivers/infiniband/hw/mthca/mthca_pd.o
  CC      net/x25/x25_proc.o
  CC      drivers/infiniband/hw/mthca/mthca_cq.o
  CC      drivers/net/mlx4/alloc.o
  CC      drivers/net/mlx4/catas.o
  CC      drivers/scsi/aacraid/nark.o
  CC      net/x25/x25_forward.o
  CC      drivers/infiniband/hw/mthca/mthca_mr.o
  CC      drivers/scsi/aic7xxx/aic79xx_pci.o
  CC      drivers/scsi/aic7xxx/aic79xx_reg_print.o
  CC      drivers/scsi/aic7xxx/aic79xx_osm.o
  CC      net/x25/sysctl_net_x25.o
  CC      net/sctp/inqueue.o
  CC      net/sctp/outqueue.o
  CC      drivers/usb/mon/mon_dma.o
  CC      drivers/infiniband/hw/mthca/mthca_qp.o
  CC      net/sctp/ulpqueue.o
  CC      drivers/scsi/aic7xxx/aic79xx_proc.o
  CC      net/sctp/command.o
  CC      drivers/infiniband/hw/mthca/mthca_av.o
  LD      drivers/video/backlight/built-in.o
  CC      net/sctp/tsnmap.o
  CC      drivers/video/display/display-sysfs.o
  LD      drivers/usb/storage/built-in.o
  CC      net/sunrpc/auth_gss/gss_krb5_seqnum.o
  CC      drivers/net/mlx4/cmd.o
  CC      drivers/net/mlx4/cq.o
  CC      drivers/infiniband/hw/mthca/mthca_mcg.o
  CC      drivers/net/mlx4/eq.o
  CC      drivers/net/mlx4/fw.o
  CC      drivers/net/mlx4/icm.o
  CC      net/sunrpc/auth_gss/gss_krb5_wrap.o
  CC      fs/ocfs2/dlm/dlmthread.o
net/sctp/sm_statefuns.c: In function 'sctp_sf_do_prm_asoc':
net/sctp/sm_statefuns.c:4373: warning: passing argument 1 of 'SCTP_ASOC' discards qualifiers from pointer target type
  CC      net/sctp/bind_addr.o
  CC      drivers/serial/8250.o
  LD      drivers/video/display/display.o
  LD      drivers/video/display/built-in.o
  CC      drivers/video/output.o
  CC      fs/ocfs2/dlm/dlmrecovery.o
  CC      drivers/message/i2o/debug.o
  LD      drivers/pci/pcie/aer/aerdriver.o
  LD      drivers/pci/pcie/aer/built-in.o
  CC      net/sctp/socket.o
  CC      net/sctp/primitive.o
  LD      drivers/pci/pcie/built-in.o
  LD      drivers/pci/built-in.o
  CC      net/sctp/output.o
  CC      net/sctp/input.o
  CC      drivers/message/i2o/pci.o
  CC      net/sctp/debug.o
  CC      drivers/message/i2o/exec-osm.o
  LD      drivers/infiniband/ulp/ipoib/ib_ipoib.o
  CC      net/sctp/ssnmap.o
  CC      drivers/infiniband/hw/mthca/mthca_mad.o
  CC      net/sctp/proc.o
  LD      drivers/infiniband/ulp/ipoib/built-in.o
  CC      net/sctp/auth.o
  CC      drivers/net/mlx4/intf.o
  CC      drivers/net/mlx4/main.o
  CC      net/xfrm/xfrm_output.o
  CC      drivers/net/mlx4/mcg.o
  CC      net/sctp/objcnt.o
  CC      net/sctp/sysctl.o
  CC      drivers/infiniband/core/packer.o
  CC      net/sctp/ipv6.o
  CC      net/xfrm/xfrm_algo.o
  CC      fs/ocfs2/dlm/dlmmaster.o
  CC      drivers/scsi/libsas/sas_init.o
  LD      drivers/video/console/built-in.o
  CC      drivers/scsi/libsas/sas_phy.o
  CC      drivers/scsi/libsas/sas_port.o
  CC      drivers/scsi/libsas/sas_event.o
  CC      drivers/scsi/libsas/sas_dump.o
  CC      drivers/scsi/aic7xxx/aic79xx_osm_pci.o
  LD      drivers/net/can/built-in.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_seq.h
  CC      drivers/net/mlx4/mr.o
  CC      drivers/scsi/libsas/sas_discover.o
  CC      fs/ocfs2/dlm/dlmast.o
  LD      drivers/input/tablet/wacom.o
  LD      drivers/input/tablet/built-in.o
  LD      drivers/input/input-core.o
  CC      drivers/net/mlx4/pd.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_reg.h
  CC      fs/ocfs2/dlm/dlmconvert.o
  LD      drivers/video/built-in.o
  CC      drivers/scsi/aic7xxx/aic7xxx_93cx6.o
  CC      drivers/scsi/aic7xxx/aic7xxx_pci.o
  CC      drivers/net/usb/catc.o
  LD      drivers/input/misc/built-in.o
  SHIPPED drivers/scsi/aic7xxx/aic7xxx_reg_print.c
  LD      drivers/input/touchscreen/built-in.o
  CC      drivers/net/ipg.o
  CC      drivers/scsi/aic7xxx/aic7xxx_osm.o
  CC      drivers/net/usb/rtl8150.o
  CC      drivers/scsi/libsas/sas_expander.o
  CC      drivers/scsi/aic7xxx/aic7xxx_proc.o
  CC      net/xfrm/xfrm_user.o
  CC      drivers/scsi/aic7xxx/aic7xxx_osm_pci.o
  CC      drivers/serial/8250_pci.o
  CC      drivers/scsi/libsas/sas_scsi_host.o
  CC      drivers/infiniband/hw/mthca/mthca_provider.o
  CC      drivers/serial/serial_cs.o
  CC      drivers/serial/8250_early.o
  CC      drivers/net/usb/asix.o
  CC      drivers/serial/8250_mca.o
  CC      drivers/net/usb/cdc_ether.o
  CC      drivers/infiniband/hw/mthca/mthca_memfree.o
drivers/net/bonding/bond_alb.c: In function 'rlb_choose_channel':
drivers/net/bonding/bond_alb.c:681: warning: 'vlan_id' may be used uninitialized in this function
  CC      drivers/infiniband/hw/mthca/mthca_uar.o
  CC      drivers/net/usb/net1080.o
  CC      drivers/infiniband/hw/mthca/mthca_srq.o
  CC      drivers/infiniband/core/ud_header.o
  CC      drivers/net/mlx4/profile.o
  LD      net/sunrpc/sunrpc.o
  CC      drivers/infiniband/hw/mthca/mthca_catas.o
  LD      drivers/net/bonding/bonding.o
  CC      drivers/scsi/megaraid/megaraid_sas.o
  CC      drivers/scsi/qla2xxx/qla_os.o
  CC      drivers/infiniband/core/verbs.o
  LD      drivers/net/bonding/built-in.o
  CC      drivers/net/rrunner.o
  CC      drivers/scsi/qla4xxx/ql4_os.o
  LD      drivers/input/keyboard/built-in.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/usb/serial/bus.o
  LD      drivers/input/built-in.o
net/sctp/ulpevent.c: In function 'sctp_ulpevent_get_notification_type':
net/sctp/ulpevent.c:861: warning: passing argument 1 of 'sctp_event2skb' discards qualifiers from pointer target type
  LD      net/ipv6/ipv6.o
  CC      drivers/usb/serial/ezusb.o
  CC      drivers/scsi/qla4xxx/ql4_init.o
  CC      drivers/scsi/qla4xxx/ql4_mbx.o
  CC      drivers/net/sunhme.o
  CC      drivers/scsi/qla4xxx/ql4_iocb.o
  LD      net/ipv6/built-in.o
  CC      drivers/usb/serial/belkin_sa.o
  CC      drivers/net/sungem.o
  CC      drivers/net/mlx4/qp.o
  CC      drivers/scsi/sym53c8xx_2/sym_fw.o
  CC      drivers/scsi/NCR_Q720.o
  CC      drivers/net/mlx4/reset.o
  CC      drivers/net/mlx4/srq.o
  CC      drivers/scsi/sym53c8xx_2/sym_glue.o
In file included from drivers/scsi/aic7xxx/aic7xxx_osm.h:231,
                 from drivers/scsi/aic7xxx/aic7xxx_pci.c:47:
drivers/scsi/aic7xxx/aic7xxx.h:1312: error: expected ')' before '*' token
In file included from drivers/scsi/aic7xxx/aic7xxx_pci.c:47:
drivers/scsi/aic7xxx/aic7xxx_osm.h: In function 'ahc_flush_device_writes':
drivers/scsi/aic7xxx/aic7xxx_osm.h:647: error: 'INTSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_osm.h:647: error: (Each undeclared identifier is reported only once
drivers/scsi/aic7xxx/aic7xxx_osm.h:647: error: for each function it appears in.)
In file included from drivers/scsi/aic7xxx/aic7xxx_pci.c:48:
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_pause_bug_fix':
drivers/scsi/aic7xxx/aic7xxx_inline.h:66: error: 'CCSCBCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_is_paused':
drivers/scsi/aic7xxx/aic7xxx_inline.h:76: error: 'HCNTRL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:76: error: 'PAUSE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_pause':
drivers/scsi/aic7xxx/aic7xxx_inline.h:89: error: 'HCNTRL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_unpause':
drivers/scsi/aic7xxx/aic7xxx_inline.h:114: error: 'INTSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:114: error: 'SCSIINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:114: error: 'SEQINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:114: error: 'BRKADRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:115: error: 'HCNTRL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_update_residual':
drivers/scsi/aic7xxx/aic7xxx_inline.h:276: error: 'SG_RESID_VALID' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_queue_scb':
drivers/scsi/aic7xxx/aic7xxx_inline.h:453: error: 'SCB_LIST_NULL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:461: error: 'LID' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:463: error: 'SCB_XFERLEN_ODD' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:478: error: 'HNSCB_QOFF' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:482: error: 'KERNEL_QINPOS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_check_cmdcmpltqueues':
drivers/scsi/aic7xxx/aic7xxx_inline.h:549: error: 'SCB_LIST_NULL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_intr':
drivers/scsi/aic7xxx/aic7xxx_inline.h:574: error: 'INTEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:591: error: 'CMDCMPLT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:593: error: 'INTSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:596: error: 'INT_PEND' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:601: error: 'ERROR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:601: error: 'PCIERRSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:611: error: 'CLRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:611: error: 'CLRCMDINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:635: error: 'BRKADRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:637: error: 'SEQINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:637: error: 'SCSIINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_pci_config':
drivers/scsi/aic7xxx/aic7xxx_pci.c:788: error: 'FAILDIS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:794: error: 'HCNTRL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:794: error: 'POWRDN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:797: error: 'SCSIID_ULTRA2' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:797: error: 'OID' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:799: error: 'SCSIID' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:800: error: 'SXFRCTL1' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:800: error: 'STPWEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:801: error: 'SCSISEQ' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:816: error: 'SFUNCT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:816: error: 'ALT_MODE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:818: error: 'OPTIONMODE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:819: error: 'OPTIONMODE_DEFAULTS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:819: error: 'AUTOACKEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:819: error: 'BUSFREEREV' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:819: error: 'EXPPHASEDIS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:823: error: 'CRCCONTROL1' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:823: error: 'CRCVALCHKEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:823: error: 'CRCENDCHKEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:823: error: 'CRCREQCHKEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:824: error: 'TARGCRCENDEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:827: error: 'DSCOMMAND0' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:828: error: 'MPARCKEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:828: error: 'CACHETHEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:835: error: 'DPARCKEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:882: error: 'SBLKCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:883: error: 'DIAGLEDEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:883: error: 'DIAGLEDON' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:886: error: 'DFF_THRSH' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:886: error: 'RD_DFTHRSH_MAX' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:886: error: 'WR_DFTHRSH_MAX' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:888: error: 'DSPCISTATUS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:888: error: 'DFTHRSH_100' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:912: error: 'SCSICONF' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:912: error: 'ENSPCHK' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:912: error: 'RESET_SCSI' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:949: error: 'TARGCRCCNT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:955: error: 'SCBBADDR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_ext_scbram_present':
drivers/scsi/aic7xxx/aic7xxx_pci.c:994: error: 'DSCOMMAND0' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:994: error: 'RAMPS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_scbram_config':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1027: error: 'SCBBADDR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1037: error: 'DSCOMMAND0' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1039: error: 'INTSCBRAMSEL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1043: error: 'USCBSIZE32' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_probe_ext_scbram':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1109: error: 'SEQCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1110: error: 'CLRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1110: error: 'CLRPARERR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1111: error: 'CLRBRKADRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1116: error: 'INTSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1116: error: 'BRKADRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1117: error: 'ERROR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1117: error: 'MPARERR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1158: error: 'PERRORDIS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1158: error: 'FAILDIS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_pci_test_register_access':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1201: error: 'HCNTRL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1206: error: 'CHIPRST' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1224: error: 'PAUSE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1233: error: 'CLRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1233: error: 'CLRPARERR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1235: error: 'SEQCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1235: error: 'PERRORDIS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1236: error: 'SCBPTR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1237: error: 'SCB_BASE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1255: error: 'FAILDIS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'check_extport':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1273: error: 'SEECTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1289: error: 'SEEMS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1290: error: 'SEERDY' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1291: error: 'SEECS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1292: error: 'SEECK' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1293: error: 'SEEDO' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1294: error: 'SEEDI' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1340: error: 'SCBPTR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1341: error: 'SCB_BASE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1353: error: 'SRAM_BASE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1364: error: 'CLRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1364: error: 'CLRPARERR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1365: error: 'CLRBRKADRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1393: error: 'SPIOCAP' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1393: error: 'SSPIOCPS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1403: error: 'STPWEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_parse_pci_eeprom':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1464: error: 'MAX_OFFSET_ULTRA2' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1467: error: 'TARG_OFFSET' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1477: error: 'WIDEXFER' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1481: error: 'SOFS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1485: error: 'TARG_SCSIRATE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1491: error: 'ENSPCHK' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1493: error: 'RESET_SCSI' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1524: error: 'SCSICONF' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1525: error: 'DISC_DSB' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1527: error: 'ULTRA_ENB' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'configure_termination':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1669: error: 'BRDDAT6' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1686: error: 'BRDDAT5' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1688: error: 'STPWEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1712: error: 'SXFRCTL1' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1715: error: 'BRDDAT4' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_new_term_detect':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1772: error: 'BRDDAT7' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1773: error: 'BRDDAT6' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1774: error: 'BRDDAT5' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1775: error: 'BRDDAT4' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1776: error: 'BRDDAT3' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'aic787X_cable_detect':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1801: error: 'BRDDAT6' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1802: error: 'BRDDAT7' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1808: error: 'BRDDAT5' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'aic785X_cable_detect':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1827: error: 'SPIOCAP' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1828: error: 'SOFTCMDEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1829: error: 'EXT_BRDCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1831: error: 'BRDCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1831: error: 'BRDRW' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1831: error: 'BRDCS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1838: error: 'BRDDAT5' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1839: error: 'BRDDAT6' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1840: error: 'EEPROM' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_acquire_seeprom':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1849: error: 'SPIOCAP' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1849: error: 'SEEPROM' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'write_brdctl':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1884: error: 'BRDSTB' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1886: error: 'BRDCS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1892: error: 'BRDCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1898: error: 'BRDSTB_ULTRA2' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'read_brdctl':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1917: error: 'BRDRW' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1919: error: 'BRDCS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1921: error: 'BRDRW_ULTRA2' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1925: error: 'BRDCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_pci_intr':
drivers/scsi/aic7xxx/aic7xxx_pci.c:1938: error: 'ERROR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1939: error: 'PCIERRSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1947: error: 'SEQADDR0' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1947: error: 'SEQADDR1' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1979: error: 'CLRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1979: error: 'CLRPARERR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1992: error: 'FAILDIS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:1993: error: 'SEQCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_pci_chip_init':
drivers/scsi/aic7xxx/aic7xxx_pci.c:2001: error: 'DSCOMMAND0' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:2002: error: 'DSPCISTATUS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:2006: error: 'SFUNCT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:2006: error: 'ALT_MODE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:2008: error: 'OPTIONMODE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:2009: error: 'TARGCRCCNT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:2011: error: 'CRCCONTROL1' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:2015: error: 'SCBBADDR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c:2018: error: 'DFF_THRSH' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_pci.c: In function 'ahc_pci_resume':
drivers/scsi/aic7xxx/aic7xxx_pci.c:2044: error: 'SEECTL' undeclared (first use in this function)
distcc[6778] ERROR: compile drivers/scsi/aic7xxx/aic7xxx_pci.c on t/25 failed
make[3]: *** [drivers/scsi/aic7xxx/aic7xxx_pci.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  CC      drivers/scsi/libsas/sas_task.o
  CC      drivers/scsi/sym53c8xx_2/sym_hipd.o
  CC      drivers/scsi/qla4xxx/ql4_isr.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/scsi/libsas/sas_ata.o
  CC      drivers/scsi/libsas/sas_host_smp.o
  CC      drivers/scsi/qla4xxx/ql4_nvram.o
  CC      drivers/scsi/ncr53c8xx.o
  CC      drivers/scsi/qla4xxx/ql4_dbg.o
  CC      drivers/scsi/scsi.o
  CC      drivers/scsi/hosts.o
  CC      drivers/scsi/scsi_ioctl.o
  CC      drivers/scsi/constants.o
  CC      drivers/infiniband/core/sysfs.o
  CC      drivers/infiniband/core/device.o
  CC      drivers/infiniband/core/fmr_pool.o
  LD      net/x25/x25.o
  LD      net/x25/built-in.o
  CC      drivers/infiniband/core/cache.o
  CC      drivers/net/usb/plusb.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC      drivers/net/usb/rndis_host.o
  CC      drivers/scsi/qla2xxx/qla_init.o
  CC      drivers/scsi/qla2xxx/qla_mbx.o
  CC      drivers/usb/serial/ch341.o
  CC      drivers/scsi/sym53c8xx_2/sym_malloc.o
  CC      drivers/scsi/scsicam.o
drivers/net/mlx4/profile.c:55: warning: 'res_name' defined but not used
  CC      drivers/scsi/scsi_error.o
  CC      drivers/usb/serial/cyberjack.o
  CC      drivers/scsi/sym53c8xx_2/sym_nvram.o
  CC      drivers/infiniband/core/umem.o
  CC      drivers/infiniband/core/mad.o
  LD      drivers/message/i2o/i2o_core.o
  LD      drivers/message/i2o/i2o_bus.o
  LD      drivers/message/i2o/built-in.o
  LD      drivers/message/built-in.o
  CC      drivers/infiniband/core/smi.o
  CC      drivers/usb/serial/usb_debug.o
  CC      drivers/scsi/scsi_lib.o
  CC      drivers/scsi/scsi_lib_dma.o
  CC      drivers/scsi/scsi_scan.o
  CC      drivers/scsi/scsi_sysfs.o
  CC      drivers/infiniband/core/agent.o
  CC      drivers/usb/serial/digi_acceleport.o
  CC      drivers/scsi/scsi_devinfo.o
  CC      drivers/scsi/scsi_netlink.o
  CC      fs/ocfs2/dlm/dlmlock.o
  CC      drivers/scsi/scsi_sysctl.o
  CC      drivers/infiniband/core/mad_rmpp.o
  CC      drivers/usb/serial/io_edgeport.o
  LD      fs/nfs/nfs.o
  CC      drivers/infiniband/core/sa_query.o
  CC      drivers/usb/serial/empeg.o
  CC      drivers/scsi/qla2xxx/qla_iocb.o
  CC      drivers/scsi/sd.o
  CC      drivers/net/sungem_phy.o
  CC      drivers/usb/serial/ftdi_sio.o
  LD      fs/nfs/built-in.o
  LD      drivers/usb/core/usbcore.o
  CC      drivers/usb/serial/iuu_phoenix.o
  CC      drivers/scsi/raid_class.o
  LD      drivers/usb/core/built-in.o
  CC      drivers/scsi/scsi_transport_spi.o
  CC      drivers/infiniband/core/multicast.o
  CC      drivers/infiniband/core/ucm.o
  CC      drivers/scsi/scsi_transport_fc.o
  CC      drivers/infiniband/core/user_mad.o
  LD      drivers/usb/misc/built-in.o
  CC      drivers/infiniband/core/uverbs_main.o
  CC      drivers/infiniband/core/uverbs_cmd.o
  CC      drivers/net/cassini.o
  CC      drivers/net/ne2k-pci.o
  CC      drivers/usb/serial/keyspan.o
  CC      drivers/scsi/scsi_transport_iscsi.o
  CC      drivers/scsi/scsi_transport_sas.o
  CC      fs/ocfs2/dlm/dlmunlock.o
  CC      drivers/scsi/scsi_transport_srp.o
  CC      drivers/usb/serial/keyspan_pda.o
  CC      fs/ocfs2/dlm/dlmver.o
  CC      drivers/scsi/libiscsi.o
  CC      drivers/usb/serial/kobil_sct.o
  CC      drivers/usb/serial/mct_u232.o
  CC      drivers/usb/serial/mos7720.o
  LD      drivers/scsi/aacraid/aacraid.o
  LD      drivers/scsi/aacraid/built-in.o
  CC      drivers/scsi/iscsi_tcp.o
  CC      drivers/scsi/53c700.o
  CC      drivers/scsi/sim710.o
  CC      drivers/usb/serial/safe_serial.o
  CC      fs/ocfs2/dlm/userdlm.o
In file included from drivers/scsi/aic7xxx/aic7xxx_osm.h:231,
                 from drivers/scsi/aic7xxx/aic7xxx_93cx6.c:69:
drivers/scsi/aic7xxx/aic7xxx.h:1312: error: expected ')' before '*' token
In file included from drivers/scsi/aic7xxx/aic7xxx_93cx6.c:69:
drivers/scsi/aic7xxx/aic7xxx_osm.h: In function 'ahc_flush_device_writes':
drivers/scsi/aic7xxx/aic7xxx_osm.h:647: error: 'INTSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_osm.h:647: error: (Each undeclared identifier is reported only once
drivers/scsi/aic7xxx/aic7xxx_osm.h:647: error: for each function it appears in.)
In file included from drivers/scsi/aic7xxx/aic7xxx_93cx6.c:70:
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_pause_bug_fix':
drivers/scsi/aic7xxx/aic7xxx_inline.h:66: error: 'CCSCBCTL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_is_paused':
drivers/scsi/aic7xxx/aic7xxx_inline.h:76: error: 'HCNTRL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:76: error: 'PAUSE' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_pause':
drivers/scsi/aic7xxx/aic7xxx_inline.h:89: error: 'HCNTRL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_unpause':
drivers/scsi/aic7xxx/aic7xxx_inline.h:114: error: 'INTSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:114: error: 'SCSIINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:114: error: 'SEQINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:114: error: 'BRKADRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:115: error: 'HCNTRL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_update_residual':
drivers/scsi/aic7xxx/aic7xxx_inline.h:276: error: 'SG_RESID_VALID' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_queue_scb':
drivers/scsi/aic7xxx/aic7xxx_inline.h:453: error: 'SCB_LIST_NULL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:461: error: 'LID' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:463: error: 'SCB_XFERLEN_ODD' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:478: error: 'HNSCB_QOFF' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:482: error: 'KERNEL_QINPOS' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_check_cmdcmpltqueues':
drivers/scsi/aic7xxx/aic7xxx_inline.h:549: error: 'SCB_LIST_NULL' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_intr':
drivers/scsi/aic7xxx/aic7xxx_inline.h:574: error: 'INTEN' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:591: error: 'CMDCMPLT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:593: error: 'INTSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:596: error: 'INT_PEND' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:601: error: 'ERROR' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:601: error: 'PCIERRSTAT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:611: error: 'CLRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:611: error: 'CLRCMDINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:635: error: 'BRKADRINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:637: error: 'SEQINT' undeclared (first use in this function)
drivers/scsi/aic7xxx/aic7xxx_inline.h:637: error: 'SCSIINT' undeclared (first use in this function)
distcc[6776] ERROR: compile drivers/scsi/aic7xxx/aic7xxx_93cx6.c on e/25 failed
make[3]: *** [drivers/scsi/aic7xxx/aic7xxx_93cx6.o] Error 1
  CC      fs/ocfs2/dlm/dlmfs.o
  CC      drivers/infiniband/core/uverbs_marshall.o
  CC      drivers/infiniband/core/iwcm.o
  CC      fs/ocfs2/dlm/dlmfsver.o
  CC      drivers/net/usb/zaurus.o
  CC      drivers/infiniband/core/cma.o
  CC      drivers/infiniband/core/ucma.o
  CC      drivers/usb/serial/ti_usb_3410_5052.o
  CC      drivers/net/usb/usbnet.o
  CC      drivers/usb/serial/visor.o
  CC      drivers/net/8390.o
  CC      drivers/net/pcnet32.o
  CC      drivers/scsi/advansys.o
drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API
  CC      drivers/net/eepro100.o
  CC      drivers/scsi/BusLogic.o
  CC      drivers/scsi/dpt_i2o.o
  CC      drivers/scsi/fd_mcs.o
  CC      drivers/usb/serial/whiteheat.o
  LD      drivers/usb/serial/usbserial.o
  CC      drivers/net/e100.o
  CC      drivers/scsi/NCR_D700.o
In file included from drivers/scsi/fd_mcs.c:92:
include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy - please move your driver to the new sysfs api"
  CC      drivers/net/tlan.o
  CC      drivers/scsi/dmx3191d.o
  CC      drivers/scsi/eata.o
  CC      drivers/net/epic100.o
  LD      drivers/usb/host/built-in.o
  CC      drivers/net/sis900.o
  CC      drivers/scsi/qla2xxx/qla_isr.o
  CC      drivers/scsi/tmscsim.o
  CC      drivers/scsi/megaraid.o
  CC      drivers/scsi/3w-xxxx.o
  CC      drivers/scsi/3w-9xxx.o
  CC      drivers/scsi/nsp32.o
  CC      drivers/scsi/qla2xxx/qla_gs.o
  LD      drivers/usb/mon/usbmon.o
  LD      drivers/usb/mon/built-in.o
  CC      drivers/scsi/qla2xxx/qla_dbg.o
  CC      drivers/net/tg3.o
  LD      drivers/net/mlx4/mlx4_core.o
  LD      drivers/net/mlx4/built-in.o
  CC      drivers/net/bnx2.o
  CC      drivers/net/sky2.o
drivers/infiniband/core/uverbs_main.c: In function 'ib_uverbs_alloc_event_file':
drivers/infiniband/core/uverbs_main.c:532: warning: the address of 'uverbs_event_fops' will always evaluate as 'true'
  CC      drivers/net/via-rhine.o
  CC      drivers/scsi/ipr.o
  CC      drivers/scsi/qla2xxx/qla_sup.o
  CC      drivers/scsi/qla2xxx/qla_attr.o
  CC      drivers/scsi/qla2xxx/qla_mid.o
  CC      drivers/scsi/qla2xxx/qla_dfs.o
  CC      drivers/scsi/osst.o
  CC      drivers/net/starfire.o
  CC      drivers/net/mii.o
  CC      drivers/net/sundance.o
  CC      drivers/net/hamachi.o
  CC      drivers/scsi/sg.o
  CC      drivers/net/Space.o
  CC      drivers/net/loopback.o
  CC      drivers/net/hp100.o
  CC      drivers/net/ne2.o
In file included from drivers/net/ne2.c:73:
include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy - please move your driver to the new sysfs api"
  CC      drivers/scsi/ch.o
  CC      drivers/net/b44.o
  CC      drivers/net/forcedeth.o
  CC      drivers/net/ppp_generic.o
  CC      drivers/net/ppp_async.o
  CC      drivers/net/ppp_deflate.o
  CC      drivers/net/bsd_comp.o
  CC      drivers/net/slip.o
  CC      drivers/net/slhc.o
  LD      net/sunrpc/auth_gss/auth_rpcgss.o
  LD      net/sunrpc/auth_gss/rpcsec_gss_krb5.o
  LD      net/sunrpc/auth_gss/built-in.o
  LD      net/sunrpc/built-in.o
  CC      drivers/net/dummy.o
  CC      drivers/net/at1700.o
  CC      drivers/net/8139too.o
  CC      drivers/net/tun.o
  CC      drivers/net/r8169.o
In file included from drivers/net/at1700.c:41:
include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy - please move your driver to the new sysfs api"
  CC      drivers/net/netconsole.o
  LD      net/ipv4/built-in.o
  LD      drivers/serial/built-in.o
  LD      drivers/scsi/libsas/libsas.o
  LD      drivers/scsi/libsas/built-in.o
  LD      drivers/char/drm/drm.o
  LD      drivers/char/drm/tdfx.o
  LD      drivers/char/drm/radeon.o
  LD      drivers/char/drm/mga.o
  LD      drivers/char/drm/i915.o
  LD      drivers/char/drm/sis.o
  LD      drivers/char/drm/via.o
  LD      drivers/net/e1000/e1000.o
  LD      drivers/net/e1000/built-in.o
drivers/scsi/dpt_i2o.c:169: warning: 'dptids' defined but not used
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
net/sctp/socket.c: In function 'sctp_msghdr_parse':
net/sctp/socket.c:5812: warning: passing argument 1 of 'cmsg_nxthdr' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/scsi/scsi_mod.o
  LD      drivers/scsi/NCR_Q720_mod.o
  LD      drivers/scsi/sd_mod.o
drivers/scsi/megaraid.c: In function 'issue_scb':
drivers/scsi/megaraid.c:1109: warning: passing argument 1 of '__constant_memcpy' discards qualifiers from pointer target type
drivers/scsi/megaraid.c: In function 'issue_scb_block':
drivers/scsi/megaraid.c:1183: warning: passing argument 1 of '__constant_memcpy' discards qualifiers from pointer target type
drivers/scsi/megaraid.c: In function 'megaraid_isr_memmapped':
drivers/scsi/megaraid.c:1371: warning: passing argument 2 of '__constant_memcpy' discards qualifiers from pointer target type
drivers/scsi/megaraid.c:1371: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
drivers/scsi/megaraid.c: In function 'megaraid_isr_iomapped':
drivers/scsi/megaraid.c:1294: warning: passing argument 2 of '__constant_memcpy' discards qualifiers from pointer target type
drivers/scsi/megaraid.c:1294: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/char/drm/built-in.o
  LD      drivers/char/built-in.o
  LD      drivers/usb/gadget/g_file_storage.o
  LD      drivers/usb/gadget/built-in.o
  LD      drivers/scsi/megaraid/built-in.o
  LD      drivers/net/usb/built-in.o
  LD      drivers/scsi/qla4xxx/qla4xxx.o
  LD      drivers/scsi/qla4xxx/built-in.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memset_io':
include/asm/io_32.h:210: warning: passing argument 1 of '__constant_c_and_count_memset' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__constant_c_memset' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
include/asm/io_32.h:210: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
  LD      drivers/infiniband/hw/mthca/ib_mthca.o
  LD      drivers/infiniband/hw/mthca/built-in.o
drivers/net/tun.c: In function 'tun_chr_aio_read':
drivers/net/tun.c:406: warning: passing argument 3 of 'tun_put_user' discards qualifiers from pointer target type
drivers/net/tun.c: In function 'tun_chr_aio_write':
drivers/net/tun.c:305: warning: passing argument 2 of 'tun_get_user' discards qualifiers from pointer target type
  LD      fs/ocfs2/cluster/ocfs2_nodemanager.o
  LD      fs/ocfs2/cluster/built-in.o
make[2]: *** [drivers/scsi/aic7xxx] Error 2
make[2]: *** Waiting for unfinished jobs....
  LD      fs/ocfs2/ocfs2.o
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:216: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/infiniband/ulp/srp/built-in.o
  LD      net/sctp/sctp.o
  LD      net/sctp/built-in.o
drivers/scsi/qla2xxx/qla_sup.c: In function 'qla2x00_beacon_blink':
drivers/scsi/qla2xxx/qla_sup.c:906: warning: cast to pointer from integer of different size
drivers/scsi/qla2xxx/qla_sup.c: In function 'qla2x00_beacon_on':
drivers/scsi/qla2xxx/qla_sup.c:966: warning: cast to pointer from integer of different size
drivers/scsi/qla2xxx/qla_sup.c: In function 'qla2x00_read_flash_byte':
drivers/scsi/qla2xxx/qla_sup.c:1247: warning: cast to pointer from integer of different size
drivers/scsi/qla2xxx/qla_sup.c: In function 'qla2x00_write_flash_byte':
drivers/scsi/qla2xxx/qla_sup.c:1307: warning: cast to pointer from integer of different size
  LD      net/xfrm/built-in.o
  LD      net/built-in.o
drivers/telephony/ixj.c:287: warning: 'ixj_pci_tbl' defined but not used
  LD      drivers/telephony/built-in.o
  LD      drivers/scsi/qla2xxx/qla2xxx.o
  LD      drivers/scsi/qla2xxx/built-in.o
  LD      drivers/usb/serial/built-in.o
  LD      drivers/usb/built-in.o
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:222: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  LD      drivers/scsi/sym53c8xx_2/sym53c8xx.o
  LD      drivers/scsi/sym53c8xx_2/built-in.o
  LD      drivers/net/built-in.o
make[1]: *** [drivers/scsi] Error 2
make[1]: *** Waiting for unfinished jobs....
  LD      drivers/infiniband/core/ib_core.o
  LD      drivers/infiniband/core/ib_mad.o
  LD      drivers/infiniband/core/ib_sa.o
  LD      drivers/infiniband/core/ib_cm.o
  LD      drivers/infiniband/core/iw_cm.o
  LD      drivers/infiniband/core/ib_addr.o
  LD      drivers/infiniband/core/rdma_cm.o
  LD      drivers/infiniband/core/ib_umad.o
  LD      drivers/infiniband/core/ib_uverbs.o
  LD      drivers/infiniband/core/rdma_ucm.o
  LD      drivers/infiniband/core/ib_ucm.o
  LD      drivers/infiniband/core/built-in.o
  LD      drivers/infiniband/built-in.o
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....
  LD      fs/ocfs2/dlm/ocfs2_dlm.o
  LD      fs/ocfs2/dlm/ocfs2_dlmfs.o
  LD      fs/ocfs2/dlm/built-in.o
  LD      fs/ocfs2/built-in.o
  LD      fs/built-in.o
Command exited with non-zero status 2
82.77user 69.92system 1:02.94elapsed 242%CPU (0avgtext+0avgdata 0maxresident)k
3424inputs+2474920outputs (3major+6289807minor)pagefaults 0swaps
build ERRORS!
scripts/kconfig/conf -s arch/x86/Kconfig
