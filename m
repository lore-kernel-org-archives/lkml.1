Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbXLKFkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbXLKFkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 00:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXLKFkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 00:40:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbXLKFkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 00:40:43 -0500
Date: Mon, 10 Dec 2007 21:40:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Lnux 2.6.24-rc5
Message-ID: <alpine.LFD.0.9999.0712102130370.28293@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been a week, and I promised to be a good boy and try to follow my 
release rules, so here is the next -rc.

Things _have_ slowed down, although I'd obviously be lying if I said we've 
got all the regressions handled and under control. They are being worked 
on, and the list is shrinking, but at a guess, we're definitely not going 
to have a final 2.6.24 out before xmas unless santa puts some more elves 
to work on those regressions..

So any elves out there - please keep working.

I'm including the shortlog since it's small enough, and quite frankly, 
gives about as readable explanation of the changes as can be imagined. 
Nothing hugely exciting here.

I'd post the diffstat too, but it's not really all that interesting, and 
it only highlights a textually big PA-RISC revert, and the powerpc 
defconfig updates. And the Blackfin SPI driver. The rest is largely random 
noise in various subsystems (drivers/net, xfs filesystem, and arch updates 
are some of the areas that show more changes).

		Linus

---
Adam Litke (1):
      hugetlb: handle write-protection faults in follow_hugetlb_page

Adrian Bunk (3):
      x86: revert CONFIG_X86_HT semantics change
      x86: free_cache_attributes() section fix
      MAINTAINERS: remove the MTRR entry

Al Viro (5):
      regression: cifs endianness bug
      no need to mess with KBUILD_CFLAGS on uml-i386 anymore
      fcrypt endianness misannotations
      regression: bfs endianness bug
      remove nonsense force-casts from ocfs2

Alexey Dobriyan (1):
      proc: fix proc_dir_entry refcounting

Andrew Gallatin (1):
      [LRO]: fix lro_gen_skb() alignment

Andrew Morton (7):
      x86: arch_register_cpu() section fix
      [BRIDGE]: Section fix.
      [IA64] increase .data.patch offset
      [IA64] don't assume that unwcheck.py is executable
      [IA64] export copy_page() to modules
      aoe: properly initialise the request_queue's backing_dev_info
      revert "dpt_i2o: convert to SCSI hotplug model"

Anton Vorontsov (1):
      PHY: Add the phy_device_release device method.

Atsushi Nemoto (1):
      qemu: do not enable IP7 blindly

Auke Kok (1):
      e100: cleanup unneeded math

Bartlomiej Zolnierkiewicz (1):
      pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings

Ben Gardner (1):
      gpio_cs5535: disable AUX on output

Benjamin Herrenschmidt (6):
      ibm_newemac: Fix ZMII refcounting bug
      ibm_newemac: Workaround reset timeout when no link
      ibm_newemac: Cleanup/Fix RGMII MDIO support detection
      ibm_newemac: Cleanup/fix support for STACR register variants
      ibm_newemac: Update file headers copyright notices
      powerpc: Fix IDE legacy vs. native fixups

Bernhard Walle (1):
      [IA64] rename _bss to __bss_start

Bryan Wu (11):
      spi: initial BF54x SPI support
      spi: spi_bfin cleanups, error handling
      spi: spi_bfin handles spi_transfer.cs_change
      spi: spi_bfin uses platform device resources
      spi: spi_bfin: handle multiple spi_masters
      spi: spi_bfin: bugfix for 8..16 bit word sizes
      spi: spi_bfin: update handling of delay-after-deselect
      Blackfin SPI driver: use cpu_relax() to replace continue in while busywait
      Blackfin SPI driver: use void __iomem * for regs_base
      Blackfin SPI driver: move hard coded pin_req to board file
      Blackfin SPI driver: reconfigure speed_hz and bits_per_word in each spi transfer

Chris Dearman (1):
      [MIPS] Don't byteswap writes to display when running bigendian

Christian Borntraeger (2):
      [S390] dcssblk: prevent early access without own make_request function
      [S390] Fix compile error on 31bit without preemption

Christoph Hellwig (1):
      [XFS] revert to double-buffering readdir

Cornelia Huck (1):
      [S390] cio: Issue SenseID per path.

Cyrill Gorcunov (1):
      [SPARC64]: check for possible NULL pointer dereference

David Brownell (2):
      SPI: use mutex not semaphore
      spi: at25 driver is for EEPROM not FLASH

David Chinner (2):
      [XFS] Fix broken inode cluster setup.
      [XFS] Fix xfs_ichgtime()s broken usage of I_SYNC

David Howells (1):
      [AF_RXRPC]: Add a missing goto

David S. Miller (4):
      [SPARC64]: Missing mdesc_release() in ldc_init().
      [SYSCTL_CHECK]: Fix typo in KERN_SPARC_SCONS_PWROFF entry string.
      [SPARC64]: Update defconfig.
      [SPARC64]: Fix memory controller register access when non-SMP.

David Sterba (1):
      bonding: Fix time comparison

David Woodhouse (1):
      Don't claim to do IPv6 checksum offload

Denis Cheng (1):
      mm/backing-dev.c: fix percpu_counter_destroy call bug in bdi_init

Denis V. Lunev (1):
      [IPV4]: Remove prototype of ip_rt_advice

Divy Le Ray (2):
      cxgb - revert file mode changes.
      cxgb3 - T3C support update

Don Zickus (1):
      x86: add the word 'WARNING' in check_nmi_watchdog() output

Donald Douwsma (1):
      [XFS] Fix dbflush panic in xfs_qm_sync.

Eliezer Tamir (1):
      make bnx2x select ZLIB_INFLATE

Eric Paris (5):
      Security: allow capable check to permit mmap or low vm space
      security: protect from stack expantion into low vm addresses
      Security: round mmap hint address above mmap_min_addr
      VM/Security: add security hook to do_brk
      VM/Security: add security hook to do_brk

Eric W. Biederman (2):
      fix clone(CLONE_NEWPID)
      proc: remove/Fix proc generic d_revalidate

Evgeniy Dushistov (1):
      ufs: fix nexstep dir block size

Geoff Levand (1):
      [POWERPC] PS3: Update ps3_defconfig

Grant Likely (2):
      gianfar: fix compile warning
      [POWERPC] virtex bug fix: Use canonical value for AC97 interrupt xparams

Haavard Skinnemoen (9):
      [AVR32] Add TIF_RESTORE_SIGMASK to the work masks
      [AVR32] Fix invalid status register bit definitions in asm/ptrace.h
      [AVR32] Kconfig: Use def_bool instead of bool + default
      [AVR32] Implement stacktrace support
      [AVR32] Implement irqflags trace and lockdep support
      [AVR32] Clean up OCD register usage
      [AVR32] Follow the rules when dealing with the OCD system
      [AVR32] Fix copy_to_user_page() breakage
      [AVR32] Fix wrong pt_regs in critical exception handler

Heiko Carstens (1):
      [S390] Make sure the restore psw masks are initialized.

Hugh Blemings (1):
      ibm_newemac: Skip EMACs that are marked unused by the firmware

Ilpo Järvinen (3):
      [TCP] FRTO: Use of existing funcs make code more obvious & robust
      [TCP]: Move prior_in_flight collect to more robust place
      [TCP]: NAGLE_PUSH seems to be a wrong way around

Ingo Molnar (7):
      sched: fix crash in sys_sched_rr_get_interval()
      sched: default to more agressive yield for SCHED_BATCH tasks
      drivers/s390/net/ctcmain.c: fix build bug
      sched: style cleanups
      lockdep: fix debug_show_all_locks()
      lockdep: make cli/sti annotation warnings clearer
      sched: enable early use of sched_clock()

Jan Kara (1):
      jbd: Fix assertion failure in fs/jbd/checkpoint.c

Jarod Wilson (1):
      firewire: OHCI 1.0 Isochronous Receive support

Jay Vosburgh (2):
      bonding: Add new layer2+3 hash for xor/802.3ad modes
      bonding: Fix race at module unload

Jeff Moyer (1):
      aio: only account I/O wait time in read_events if there are active requests

Jeremy Fitzhardinge (1):
      xen: relax signature check

Jiri Kosina (1):
      RTC: assure proper memory ordering with respect to RTC_DEV_BUSY flag

Joe Perches (4):
      [SPARC64]: Add missing "space"
      [SPARC]: Add missing "space"
      [IA64] Add missing "space" to concatenated strings
      MAINTAINERS: update stale entries

Jon Smirl (1):
      Fix memory corruption in fec_mpc52xx

Julia Lawall (3):
      [SPARC64]: Add missing pci_dev_put
      [SPARC]: Add missing of_node_put
      drivers/serial/uartlite.c: Add missing of_node_put

Kenji Kaneshige (1):
      [IA64] Fix iosapic interrupt delivery mode for CPE

Kumar Gala (1):
      [POWERPC] Fix swapper_pg_dir size when CONFIG_PTE_64BIT=y on FSL_BOOKE

Kyle McMartin (5):
      Revert "[PARISC] import necessary bits of libgcc.a"
      [PARISC] timer interrupt should not be IRQ_DISABLED
      [PARISC] Update parisc-linux MAINTAINERS entries
      [PARISC] print more than one character at a time for pdc console
      [PARISC] lba_pci: pci_claim_resources disabled expansion roms

Lachlan McIlroy (3):
      [XFS] 971064 Various fixups for xfs_bulkstat().
      [XFS] Fixed a few bugs in xfs_buf_associate_memory()
      [XFS] Clear XBF_READ_AHEAD flag on I/O completion.

Li Zefan (1):
      [IA64] make full use of macro efi_md_size

Linus Torvalds (4):
      Tiny clean-up of OPROFILE/KPROBES configuration
      Avoid double memclear() in SLOB/SLUB
      Revert "PCI: fix IDE legacy mode resources"
      Linux 2.6.24-rc5

Maciej W. Rozycki (1):
      esp_scsi: fix reset cleanup spinlock recursion

Manuel Lauss (1):
      [MIPS] Alchemy: Fix Au1x SD controller IRQ

Marc Pignat (2):
      spi: simplify spi_sync() calling convention
      spi: use simplified spi_sync() calling convention

Mark Lord (1):
      sata_mv:  Warn about HPT RocketRAID BIOS treatment of "Legacy" drives

Michael Hennerich (1):
      spi: bfin spi uses portmux calls

Mike Frysinger (1):
      spi: spi_bfin, don't bypass spi framework

Mike Habeck (1):
      [IA64] SGI Altix : fix bug in sn_io_late_init()

Mirko Lindner (1):
      [NIU]: Fix link LED handling.

Mitsuru Chinen (2):
      [IPv6] SNMP: Increment OutNoRoutes when connecting to unreachable network
      [IPv4]: Reply net unreachable ICMP message

Neil Brown (1):
      Fix NULL dereference in umem.c

Nick Piggin (1):
      mm: fix XIP file writes

Oleg Nesterov (1):
      lockdep: in_range() fix

Olof Johansson (1):
      pasemi_mac: Fix reuse of free'd skb

Paul Mackerras (1):
      [POWERPC] Update defconfigs

Pavel Emelyanov (6):
      [IPVS]: Don't leak sysctl tables if the scheduler registration fails.
      [IPVS]: Fix sched registration race when checking for name collision.
      [ROSE]: Trivial compilation CONFIG_INET=n case
      [IRDA]: Move ircomm_tty_line_info() under #ifdef CONFIG_PROC_FS
      Avoid potential NULL dereference in unregister_sysctl_table
      [VLAN]: Lost rtnl_unlock() in vlan_ioctl()

Pavel Machek (1):
      ACPI: suspend: old debugging hacks sneaked back

Peter Oberparleiter (1):
      [S390] cio: add missing reprobe loop end statement

Peter Schwenke (1):
      ata_piix: add Toshiba Tecra M4 to broken suspend list

Rafael J. Wysocki (5):
      Freezer: Fix s2disk resume from initrd
      Freezer: Fix APM emulation breakage
      HWMON: coretemp, suspend fix
      Freezer: Fix JFFS2 garbage collector freezing issue (rev. 2)
      [XFS] Make xfsbufd threads freezable

Ralf Baechle (5):
      [MIPS] BCM1480: Fix interrupt routing, take 2.
      [MIPS] Oprofile: Fix computation of number of counters.
      Fix oprofile configuration breakage
      [MIPS] Bigsur: Enable tickless and and highres timers.
      [MIPS] Malta: Enable tickless and highres timers.

Randy Dunlap (1):
      pcmcia: fix kernel-doc comments

Richard Purdie (1):
      leds: Fix led trigger locking bugs

Rini van Zetten (1):
      atmel_spi: reload RCR before TCR

Robert Hancock (1):
      sata_nv: don't use legacy DMA in ADMA mode (v3)

Roel Kluin (3):
      e1000: fix memcpy in e1000_get_strings
      [IA64] operator priority fix in acpi_map_lsapic()
      asm-h8300: parentheses around definition CLOCK_TICK_RATE

Sam Ravnborg (2):
      kbuild: fix building with redirected output.
      kbuild: fix building with O=.. options

Sergei Shtylyov (2):
      [MIPS] Alchemy: replace ffs() with __ffs()
      [MIPS] Alchemy: fix IRQ bases

Shaohua Li (1):
      [IA64] kprobe: make kreturn probe handler stack unwind correct

Shi Weihua (1):
      [IA64] signal : fix missing error checkings

Simon Horman (1):
      [IA64] iosapic cleanup

Sonic Zhang (5):
      spi: spi_bfin uses portmux for additional busses
      spi: spi_bfin, rearrange portmux calls
      spi: spi_bfin: change handling of communication parameters
      spi: spi_bfin: relocate spin/waits
      spi: spi_bfin: resequence DMA start/stop

Sreenivasa Honnur (1):
      S2io: Check for register initialization completion before accesing device registers

Stefan Roese (2):
      ibm_newemac: Add BCM5248 and Marvell 88E1111 PHY support
      ibm_newemac: Add ET1011c PHY support

Stephen Hemminger (1):
      sky2: recovery deadlock fix

Stephen Rothwell (1):
      [POWERPC] Update iseries_defconfig

Stephen Smalley (2):
      SELinux: do not clear f_op when removing entries
      SELinux: detect dead booleans

Steven Rostedt (1):
      futex: fix for futex_wait signal stack corruption

Tejun Heo (3):
      ahci: fix engine reset failed message
      ahci: don't attach if ICH6 is in combined mode
      libata: kill spurious NCQ completion detection

Tetsuo Handa (1):
      Add EXPORT_SYMBOL(ksize);

Thomas Gleixner (4):
      futex: correctly return -EFAULT not -EINVAL
      hrtimers: avoid overflow for large relative timeouts
      clockevents: warn once when program_event() is called with negative expiry
      ACPI: move timer broadcast before busmaster disable

Tony Breeds (1):
      [POWERPC] Fix hardware IRQ time accounting problem.

Valentine Barshak (3):
      ibm_newemac: Correct opb_bus_freq value
      ibm_newemac: Fix typo reading TAH channel info
      ibm_newemac: Call dev_set_drvdata() before tah_reset()

Vegard Nossum (1):
      SLUB's ksize() fails for size > 2048

Vlad Yasevich (2):
      [SCTP]: Add bind hash locking to the migrate code
      [SCTP]: Fix the bind_addr info during migration.

Wagner Ferenc (5):
      bonding: Remove trailing NULs from sysfs interface.
      bonding: Return nothing for not applicable values
      bonding: Purely cosmetic: rename a local variable
      bonding: Coding style: break line after the if condition
      bonding: Allow setting and querying xmit policy regardless of mode

Wang Chen (1):
      SMC911X: Fix using of dereferenced skb after netif_rx

Will Newton (3):
      pxa2xx_spi: fix typo in description
      spi_bfin5xx: fix typo in description
      spi_imx: fix typo in description

peerchen (1):
      ahci: add the Device IDs of MCP79 AHCI controller to ahci.c

