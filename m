Return-Path: <linux-kernel-owner+w=401wt.eu-S1763792AbXHQWTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763792AbXHQWTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXHQWT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:19:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:49496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752646AbXHQWTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:19:23 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+UjvdWMqWUxiK07A7cLYD5RHu5OBPPS6DXjB6fQl
	DAjBz5NKfQx7vc
Message-ID: <46C62CF5.9080502@gmx.net>
Date: Sat, 18 Aug 2007 01:19:17 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708071750.51019.jimis@gmx.net> <46BA14A2.5030705@interia.pl> <200708091117.51687.jimis@gmx.net> <46BC0E5B.6030403@interia.pl>
In-Reply-To: <46BC0E5B.6030403@interia.pl>
Content-Type: multipart/mixed;
 boundary="------------090608080900060903030405"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090608080900060903030405
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hello list,

before trying to reproduce the problem with older kernels I did the 
necessary step of compiling and using a *vanilla* simple monolithic 
kernel for my measurements. The kernel config (attached config.gz) has 
many standard things disabled (like ACPI for example) so the oprofile 
output now seems very different. Please keep in mind that I switched 
back from libata to the old IDE driver, to be able to use the same 
config on old kernels.

The situations I attach are:

   idle:		The PC doing nothing. Note that now idle time is spent in 
irq_handler and not in poll_idle. Strange...
   one_disk:	Destructive badblocks (badblocks -v -w) on one disk. 
Everything is responsive and the CPU is 99% iowait as it should.
   two_disks:	Destructive badblocks on two disks before the problem 
appears. Things are starting to get sluggy.
   two_disks_bad2:	*PROBLEM* The previous situation after several 
minutes, and after several cron jobs kicked in (and never finished). 
System in a bad state, highly unresponsive.


The situation seems now completely different (but practically the 
problem is exactly the same), probably because of kernel options. Here 
are the first lines from opreport with debugging info, for the 
two_disks_bad2 scenario:

CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a 
unit mask of 0x00 (No unit mask) count 100000
samples  %        linenr info                 symbol name
282       9.3377  ide-iops.c:1081             pre_reset
231       7.6490  stats.c:187                 rpc_print_iostats
222       7.3510  ptrace.c:654                do_syscall_trace
146       4.8344  ide-io.c:1185               ide_do_request
144       4.7682  process.c:529               dump_task_regs
131       4.3377  stats.c:64                  rpc_proc_open
122       4.0397  backing-dev.c:46            congestion_wait
98        3.2450  vsprintf.c:622              vsscanf
52        1.7219  process.c:643               __switch_to
33        1.0927  sched.c:4065                interruptible_sleep_on
32        1.0596  slub.c:597                  check_object
32        1.0596  signal.c:244                setup_sigcontext
32        1.0596  signal.c:56                 sys_sigaction
31        1.0265  buffer.c:2452               block_truncate_page
31        1.0265  fadvise.c:28                sys_fadvise64_64
31        1.0265  page-writeback.c:987        test_set_page_writeback


If you think I should enable/disable other options in the kernel please 
tell me. Moreover it would be nice to know how to use the various 
debugging options that I enabled, to help figuring out the problem. So 
what do you think? Does this help or should I start trying older kernels 
(which is *hard* to do with latest libc and udev that I have)?


Thanks again,
Dimitris



--------------090608080900060903030405
Content-Type: application/x-gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

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
LWDySnBS3h+H94TpUAAA
--------------090608080900060903030405
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

[    0.000000] Linux version 2.6.22.3mango-monolithic-dbg (jimis@mango) (gcc version 4.2.1) #2 Fri Aug 17 19:18:43 EEST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
[    0.000000]  BIOS-e820: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000000fff3000 - 0000000010000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] using polling idle threads.
[    0.000000] 255MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 65520) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->    65520
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->    65520
[    0.000000] On node 0 totalpages: 65520
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 479 pages used for memmap
[    0.000000]   Normal zone: 60945 pages, LIFO batch:15
[    0.000000] DMI 2.2 present.
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 10000000:efff0000)
[    0.000000] Built 1 zonelists.  Total pages: 65009
[    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.22.3-dbg ro root=341 lapic nmi_watchdog=0 idle=poll
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Found and enabled local APIC!
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 1024 (order: 10, 4096 bytes)
[    0.000000] Detected 798.020 MHz processor.
[   36.983538] Console: colour VGA+ 80x25
[   36.986206] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[   36.986676] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[   37.012595] Memory: 256036k/262080k available (1963k kernel code, 5544k reserved, 611k data, 140k init, 0k highmem)
[   37.012781] virtual kernel memory layout:
[   37.012785]     fixmap  : 0xffffc000 - 0xfffff000   (  12 kB)
[   37.012789]     vmalloc : 0xd0800000 - 0xffffa000   ( 759 MB)
[   37.012792]     lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
[   37.012796]       .init : 0xc0386000 - 0xc03a9000   ( 140 kB)
[   37.012800]       .data : 0xc02eacd7 - 0xc0383b64   ( 611 kB)
[   37.012804]       .text : 0xc0100000 - 0xc02eacd7   (1963 kB)
[   37.013432] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   37.013699] SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[   37.163848] Calibrating delay using timer specific routine.. 1597.05 BogoMIPS (lpj=7985266)
[   37.164075] Mount-cache hash table entries: 512
[   37.164358] CPU: After generic identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
[   37.164382] CPU: L1 I cache: 16K, L1 D cache: 16K
[   37.164501] CPU: L2 cache: 256K
[   37.164587] CPU serial number disabled.
[   37.164675] CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
[   37.164688] Intel machine check architecture supported.
[   37.164782] Intel machine check reporting enabled on CPU#0.
[   37.164880] Compat vDSO mapped to ffffe000.
[   37.164986] CPU: Intel Pentium III (Coppermine) stepping 06
[   37.165168] Checking 'hlt' instruction... OK.
[   37.444042] NET: Registered protocol family 16
[   37.475344] PCI: PCI BIOS revision 2.10 entry at 0xfb370, last bus=1
[   37.475446] PCI: Using configuration type 1
[   37.475541] Setting up standard PCI resources
[   37.478177] PCI: Probing PCI hardware
[   37.478315] PCI: Probing PCI hardware (bus 00)
[   37.480044] PCI: Using IRQ router VIA [1106/0596] at 0000:00:07.0
[   37.489977] PCI: Bridge: 0000:00:01.0
[   37.490080]   IO window: disabled.
[   37.490180]   MEM window: d8000000-dfffffff
[   37.490276]   PREFETCH window: 20000000-200fffff
[   37.490390] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   37.490422] NET: Registered protocol family 2
[   37.493810] Time: tsc clocksource has been installed.
[   37.573854] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[   37.574034] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[   37.574363] TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
[   37.574578] TCP: Hash tables configured (established 8192 bind 8192)
[   37.574679] TCP reno registered
[   37.604371] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   37.611242] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   37.611678] fuse init (API version 7.8)
[   37.612390] io scheduler noop registered
[   37.612492] io scheduler anticipatory registered (default)
[   37.612592] io scheduler deadline registered
[   37.612862] io scheduler cfq registered
[   37.612980] PCI: VIA PCI bridge detected. Disabling DAC.
[   37.613082] Activating ISA DMA hang workarounds.
[   37.613213] Boot video device is 0000:01:00.0
[   37.678453] Real Time Clock Driver v1.12ac
[   37.678571] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   37.678740] Hangcheck: Using get_cycles().
[   37.678847] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   37.680289] serial8250.0: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   37.680872] serial8250.0: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   37.682616] loop: module loaded
[   37.682825] PCI: setting IRQ 12 as level-triggered
[   37.682834] PCI: Found IRQ 12 for device 0000:00:0a.0
[   37.683001] skge 1.11 addr 0xe4000000 irq 12 chip Yukon rev 1
[   37.683579] skge eth0: addr 00:0f:38:6a:9c:fe
[   37.684108] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   37.684219] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   37.684498] VP_IDE: IDE controller at PCI slot 0000:00:07.1
[   37.684617] VP_IDE: chipset revision 6
[   37.684714] VP_IDE: not 100% native mode: will probe irqs later
[   37.684828] VP_IDE: VIA vt82c596b (rev 12) IDE UDMA66 controller on pci0000:00:07.1
[   37.685004]     ide0: BM-DMA at 0xe000-0xe007, BIOS settings: hda:DMA, hdb:DMA
[   37.685233]     ide1: BM-DMA at 0xe008-0xe00f, BIOS settings: hdc:DMA, hdd:pio
[   37.685452] Probing IDE interface ide0...
[   38.133759] hda: WDC WD2500JB-55REA0, ATA DISK drive
[   38.433703] hdb: MAXTOR 6L020J1, ATA DISK drive
[   38.494132] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   38.494492] Probing IDE interface ide1...
[   38.933603] hdc: WDC WD2500JB-55REA0, ATA DISK drive
[   39.653537] ide1 at 0x170-0x177,0x376 on irq 15
[   39.653980] hda: max request size: 512KiB
[   39.662415] hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(66)
[   39.662778] hda: cache flushes supported
[   39.662941]  hda: unknown partition table
[   39.671391] hdb: max request size: 128KiB
[   39.672508] hdb: 40132503 sectors (20547 MB) w/1819KiB Cache, CHS=39813/16/63, UDMA(66)
[   39.672897] hdb: cache flushes supported
[   39.673023]  hdb: hdb1 hdb2
[   39.679890] hdc: max request size: 512KiB
[   39.688535] hdc: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(66)
[   39.688882] hdc: cache flushes supported
[   39.689028]  hdc: unknown partition table
[   39.943833] serio: i8042 KBD port at 0x60,0x64 irq 1
[   39.944151] mice: PS/2 mouse device common for all mice
[   39.964472] input: AT Translated Set 2 keyboard as /class/input/input0
[   39.964662] md: raid0 personality registered for level 0
[   39.964776] oprofile: using NMI interrupt.
[   39.964882] TCP cubic registered
[   39.965194] NET: Registered protocol family 1
[   39.965294] NET: Registered protocol family 17
[   39.965605] Using IPI Shortcut mode
[   39.966053] md: Autodetecting RAID arrays.
[   39.966151] md: autorun ...
[   39.966246] md: ... autorun DONE.
[   39.981714] kjournald starting.  Commit interval 5 seconds
[   39.981839] EXT3-fs: mounted filesystem with ordered data mode.
[   39.981955] VFS: Mounted root (ext3 filesystem) readonly.
[   39.982331] Freeing unused kernel memory: 140k freed
[   43.937797] md: md0 stopped.
[   47.134790] EXT3 FS on hdb1, internal journal
[   47.250784] ReiserFS: hdb2: found reiserfs format "3.6" with standard journal
[   47.250820] ReiserFS: hdb2: using ordered data mode
[   47.251544] ReiserFS: hdb2: journal params: device hdb2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   47.256771] ReiserFS: hdb2: checking transaction log (hdb2)
[   47.312336] ReiserFS: hdb2: Using r5 hash to sort names
[   48.732000] skge eth0: enabling interface
[   51.219364] skge eth0: Link is up at 1000 Mbps, full duplex, flow control both

--------------090608080900060903030405
Content-Type: text/plain;
 name="oprof_idle.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprof_idle.txt"

+ date
Fri Aug 17 20:07:32 EEST 2007
+ rm -rf /var/lib/oprofile/
+ opcontrol --vmlinux=/home/jimis/dist/src/linux-2.6.22.3/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
    27648 96.8746 vmlinux
      360  1.2614 libc-2.6.1.so
      178  0.6237 bash
      139  0.4870 oprofiled
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      138 99.2806 oprofiled
	        1  0.7194 [vdso] (tgid:11997 range:0xb7f96000-0xb7f97000)
      131  0.4590 ld-2.6.1.so
       59  0.2067 ISO8859-1.so
        6  0.0210 locale-archive
        5  0.0175 gawk
        3  0.0105 libcrypto.so.0.9.8
        2  0.0070 libpthread-2.6.1.so
        2  0.0070 imap-login
        1  0.0035 ls
        1  0.0035 libhistory.so.5.2
        1  0.0035 screen-4.0.3
        1  0.0035 libnetsnmp.so.15.0.0
        1  0.0035 dovecot-auth
        1  0.0035 dovecot
        1  0.0035 sshd
+ echo

+ echo

+ echo

+ opreport -l /home/jimis/dist/src/linux-2.6.22.3/vmlinux
CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
26423    95.5693  irq_handler
288       1.0417  kmem_cache_shrink
190       0.6872  create_kmalloc_cache
105       0.3798  congestion_wait
38        0.1374  vsscanf
30        0.1085  assign_all_busses
30        0.1085  sys_fadvise64_64
28        0.1013  interruptible_sleep_on
25        0.0904  sys_madvise
24        0.0868  do_wp_page
14        0.0506  print_hex_dump
12        0.0434  check_object
12        0.0434  ext3_reserve_inode_write
11        0.0398  generic_file_buffered_write
11        0.0398  handle_vm86_fault
11        0.0398  vsnprintf
10        0.0362  kobject_rename
9         0.0326  __relay_reset
9         0.0326  do_syscall_trace
9         0.0326  rtc_cmos_read
8         0.0289  __handle_mm_fault
8         0.0289  setup_sigcontext
7         0.0253  access_process_vm
7         0.0253  locks_mandatory_area
7         0.0253  pcibios_setup
7         0.0253  print_bad_pte
6         0.0217  load_elf_binary
6         0.0217  pirq_piix_set
6         0.0217  vfs_mknod
5         0.0181  ext3_orphan_get
5         0.0181  fcntl_setlk
5         0.0181  loop_alloc
5         0.0181  process_slab
5         0.0181  rt_mutex_setprio
4         0.0145  __switch_to_xtra
4         0.0145  shrink_zone
3         0.0109  __dequeue_signal
3         0.0109  __switch_to
3         0.0109  __vmalloc_area_node
3         0.0109  block_invalidatepage
3         0.0109  do_mremap
3         0.0109  do_sync
3         0.0109  ext3_free_inode
3         0.0109  ext3_new_inode
3         0.0109  follow_page
3         0.0109  out_of_memory
3         0.0109  pcibios_enable_device
3         0.0109  pipe_write
3         0.0109  pirq_enable_irq
3         0.0109  posix_cpu_nsleep
3         0.0109  sys_remap_file_pages
3         0.0109  try_to_wake_up
3         0.0109  vfs_mkdir
3         0.0109  vfs_rename
3         0.0109  zoneinfo_show
2         0.0072  __free_slab
2         0.0072  __remove_shared_vm_struct
2         0.0072  background_writeout
2         0.0072  bitmap_find_free_region
2         0.0072  calibrate_delay
2         0.0072  dentry_open
2         0.0072  do_getitimer
2         0.0072  do_mmap_pgoff
2         0.0072  do_munmap
2         0.0072  do_page_fault
2         0.0072  elf_core_dump
2         0.0072  ext3_xattr_set
2         0.0072  install_page
2         0.0072  log_do_checkpoint
2         0.0072  lookup_one_len
2         0.0072  madvise_need_mmap_write
2         0.0072  pdflush
2         0.0072  prepare_timeout
2         0.0072  register_chrdev
2         0.0072  remap_pfn_range
2         0.0072  send_group_sigqueue
2         0.0072  swap_readpage
2         0.0072  sys_mincore
2         0.0072  sys_mprotect
2         0.0072  sys_timerfd
2         0.0072  t_start
2         0.0072  user_shm_lock
2         0.0072  vm_normal_page
2         0.0072  wake_up_new_task
1         0.0036  __cond_resched
1         0.0036  __filemap_copy_from_user_iovec_inatomic
1         0.0036  __follow_mount
1         0.0036  __free_pages_ok
1         0.0036  __get_user_2
1         0.0036  __inode_dir_notify
1         0.0036  __ip_route_output_key
1         0.0036  __journal_refile_buffer
1         0.0036  __journal_temp_unlink_buffer
1         0.0036  __kill_fasync
1         0.0036  __oom_kill_task
1         0.0036  __posix_lock_file
1         0.0036  __pte_alloc
1         0.0036  __set_special_pids
1         0.0036  __setscheduler
1         0.0036  __sigqueue_alloc
1         0.0036  __vma_link
1         0.0036  __wait_on_freeing_inode
1         0.0036  aio_complete
1         0.0036  badness
1         0.0036  clear_page_dirty_for_io
1         0.0036  clockevents_set_mode
1         0.0036  congestion_wait_interruptible
1         0.0036  copy_page_range
1         0.0036  copy_process
1         0.0036  cpu_idle
1         0.0036  d_lookup
1         0.0036  daemonize
1         0.0036  dcache_dir_lseek
1         0.0036  do_cpu_nanosleep
1         0.0036  do_lookup
1         0.0036  do_msgrcv
1         0.0036  do_notify_parent
1         0.0036  do_sendfile
1         0.0036  do_sync_read
1         0.0036  do_sysctl
1         0.0036  do_utimes
1         0.0036  dup_fd
1         0.0036  early_serial_putc
1         0.0036  early_serial_write
1         0.0036  ext3_count_dirs
1         0.0036  ext3_count_free_inodes
1         0.0036  ext3_read_inode
1         0.0036  ext3_readdir
1         0.0036  ext3_rename
1         0.0036  ext3_xattr_block_set
1         0.0036  ext3_xattr_get
1         0.0036  ext3_xattr_set_handle
1         0.0036  ext3_xattr_trusted_list
1         0.0036  file_send_actor
1         0.0036  find_inode
1         0.0036  find_mergeable_anon_vma
1         0.0036  force_sigsegv
1         0.0036  generic_permission
1         0.0036  generic_segment_checks
1         0.0036  generic_shutdown_super
1         0.0036  generic_write_checks
1         0.0036  get_next_timer_interrupt
1         0.0036  hrtimer_nanosleep
1         0.0036  i8259A_shutdown
1         0.0036  ide_do_request
1         0.0036  inode_sub_bytes
1         0.0036  insert_vm_struct
1         0.0036  internal_add_timer
1         0.0036  interruptible_sleep_on_timeout
1         0.0036  ioremap_nocache
1         0.0036  itimer_get_remtime
1         0.0036  journal_commit_transaction
1         0.0036  journal_get_create_access
1         0.0036  journal_recover
1         0.0036  journal_refile_buffer
1         0.0036  kill_block_super
1         0.0036  kill_litter_super
1         0.0036  kmem_cache_create
1         0.0036  kmem_cache_destroy
1         0.0036  kmem_ptr_validate
1         0.0036  kobject_get_path
1         0.0036  kobject_shadow_add
1         0.0036  kobject_uevent_env
1         0.0036  lock_timer
1         0.0036  locks_insert_block
1         0.0036  may_open
1         0.0036  memcmp
1         0.0036  memcpy
1         0.0036  mempool_resize
1         0.0036  microcode_write
1         0.0036  modify_acceptable_latency
1         0.0036  number
1         0.0036  pci_write
1         0.0036  percpu_pagelist_fraction_sysctl_handler
1         0.0036  pirq_serverworks_set
1         0.0036  posix_cpu_timer_set
1         0.0036  posix_timer_event
1         0.0036  prepare_to_wait
1         0.0036  prio_tree_remove
1         0.0036  proc_dodebug
1         0.0036  put_files_struct
1         0.0036  put_io_context
1         0.0036  rb_erase
1         0.0036  reiserfs_delete_xattrs
1         0.0036  reiserfs_listxattr
1         0.0036  reiserfs_xattr_init
1         0.0036  relay_create_buf
1         0.0036  relay_switch_subbuf
1         0.0036  rpc_print_iostats
1         0.0036  rpc_proc_exit
1         0.0036  rpc_proc_init
1         0.0036  sched_setscheduler
1         0.0036  send_signal
1         0.0036  set_bdi_congested
1         0.0036  set_page_dirty
1         0.0036  show_regs
1         0.0036  show_state_filter
1         0.0036  skb_checksum
1         0.0036  skb_seq_read
1         0.0036  skge_poll
1         0.0036  sprint_symbol
1         0.0036  submit_bh
1         0.0036  sync_cmos_clock
1         0.0036  sys_chroot
1         0.0036  sys_close
1         0.0036  sys_fchdir
1         0.0036  sys_get_thread_area
1         0.0036  sys_mq_timedreceive
1         0.0036  sys_sched_getparam
1         0.0036  sys_setreuid
1         0.0036  sys_setuid
1         0.0036  sys_sync_file_range
1         0.0036  sys_vm86old
1         0.0036  task_running_tick
1         0.0036  tcp_rcv_established
1         0.0036  test_clear_page_writeback
1         0.0036  test_set_page_writeback
1         0.0036  throttle_vm_writeout
1         0.0036  tick_notify
1         0.0036  timer_list_show
1         0.0036  trace
1         0.0036  unregister_timer_hook
1         0.0036  update_wall_time
1         0.0036  vfs_create
1         0.0036  vfs_ioctl
1         0.0036  vfs_unlink
1         0.0036  vm_insert_pfn
1         0.0036  vma_adjust
1         0.0036  vma_link
1         0.0036  vma_merge
1         0.0036  vprintk
1         0.0036  wakeup_pdflush
1         0.0036  walk_page_buffers
+ date
Fri Aug 17 20:07:38 EEST 2007

--------------090608080900060903030405
Content-Type: text/plain;
 name="oprof_one_disk.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprof_one_disk.txt"

+ date
Fri Aug 17 20:17:46 EEST 2007
+ rm -rf /var/lib/oprofile/
+ opcontrol --vmlinux=/home/jimis/dist/src/linux-2.6.22.3/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
    10455 90.6922 vmlinux
      410  3.5566 libc-2.6.1.so
      239  2.0732 bash
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      237 99.1632 bash
	        2  0.8368 [vdso] (tgid:12553 range:0xb7f81000-0xb7f82000)
      190  1.6482 ld-2.6.1.so
      121  1.0496 oprofiled
       57  0.4944 ISO8859-1.so
       10  0.0867 gawk
       10  0.0867 badblocks
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        6 60.0000 badblocks
	        4 40.0000 [vdso] (tgid:10904 range:0xb7eed000-0xb7eee000)
        5  0.0434 grep
        5  0.0434 locale-archive
        4  0.0347 libext2fs.so.2.4
        3  0.0260 libcrypto.so.0.9.8
        3  0.0260 imap-login
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        2 66.6667 imap-login
	        1 33.3333 [vdso] (tgid:1946 range:0xb7f17000-0xb7f18000)
        2  0.0173 libncurses.so.5.6
        2  0.0173 screen-4.0.3
        2  0.0173 dovecot
        2  0.0173 sshd
        1  0.0087 cat
        1  0.0087 mkdir
        1  0.0087 rm
        1  0.0087 libreadline.so.5.2
        1  0.0087 libnetsnmp.so.15.0.0
        1  0.0087 libnetsnmphelpers.so.15.0.0
        1  0.0087 libnetsnmpmibs.so.15.0.0
        1  0.0087 syslog-ng
+ echo

+ echo

+ echo

+ opreport -l /home/jimis/dist/src/linux-2.6.22.3/vmlinux
CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
6879     65.7963  irq_handler
881       8.4266  kmem_cache_shrink
672       6.4275  create_kmalloc_cache
188       1.7982  congestion_wait
140       1.3391  pre_reset
104       0.9947  vsscanf
84        0.8034  do_syscall_trace
78        0.7461  ide_do_request
51        0.4878  assign_all_busses
46        0.4400  interruptible_sleep_on
35        0.3348  sys_fadvise64_64
33        0.3156  sys_madvise
30        0.2869  rtc_cmos_read
29        0.2774  do_wp_page
28        0.2678  kobject_rename
25        0.2391  check_object
25        0.2391  print_hex_dump
19        0.1817  __relay_reset
17        0.1626  setup_sigcontext
16        0.1530  vsnprintf
15        0.1435  ide_setup_pci_devices
15        0.1435  zoneinfo_show
14        0.1339  block_truncate_page
14        0.1339  test_set_page_writeback
13        0.1243  __blkdev_put
13        0.1243  cont_prepare_write
13        0.1243  load_elf_binary
12        0.1148  access_process_vm
12        0.1148  pcibios_setup
11        0.1052  __handle_mm_fault
11        0.1052  __switch_to
11        0.1052  do_ide_setup_pci_device
11        0.1052  dump_task_extended_fpu
11        0.1052  rpc_print_iostats
11        0.1052  zap_pte
10        0.0956  bdget
10        0.0956  blk_release_queue
10        0.0956  do_page_fault
10        0.0956  elv_next_request
10        0.0956  sys_mq_open
9         0.0861  bdev_clear_inode
9         0.0861  generic_file_buffered_write
9         0.0861  locks_mandatory_area
9         0.0861  scsi_cmd_ioctl
8         0.0765  bd_claim_by_disk
8         0.0765  bd_release_from_disk
8         0.0765  dump_task_regs
8         0.0765  fcntl_setlk
7         0.0670  blk_cleanup_queue
7         0.0670  do_mpage_readpage
7         0.0670  loop_alloc
7         0.0670  unmap_vmas
7         0.0670  vfs_rename
6         0.0574  __end_that_request_first
6         0.0574  bio_split
6         0.0574  blkdev_close
6         0.0574  do_generic_mapping_read
6         0.0574  do_mremap
6         0.0574  generic_ide_ioctl
6         0.0574  pirq_piix_set
6         0.0574  prio_tree_insert
6         0.0574  test_clear_page_writeback
5         0.0478  __break_lease
5         0.0478  __switch_to_xtra
5         0.0478  daemonize
5         0.0478  dio_complete
5         0.0478  flush_old_exec
5         0.0478  handle_vm86_fault
5         0.0478  kmem_cache_create
5         0.0478  pipe_write
5         0.0478  pirq_enable_irq
5         0.0478  process_slab
5         0.0478  read_cache_page_async
5         0.0478  vfs_mkdir
4         0.0383  __blk_put_request
4         0.0383  add_to_page_cache
4         0.0383  cap_inode_removexattr
4         0.0383  cap_task_post_setuid
4         0.0383  dio_cleanup
4         0.0383  dio_get_page
4         0.0383  do_kern_mount
4         0.0383  do_mmap_pgoff
4         0.0383  do_notify_parent
4         0.0383  do_sendfile
4         0.0383  do_sysctl
4         0.0383  do_sysctl_strategy
4         0.0383  ext3_xattr_set_handle
4         0.0383  generic_write_checks
4         0.0383  idedisk_check_hpa
4         0.0383  interruptible_sleep_on_timeout
4         0.0383  log_do_checkpoint
4         0.0383  pcibios_scan_root
4         0.0383  print_bad_pte
4         0.0383  ptrace_request
4         0.0383  send_group_sigqueue
4         0.0383  set_using_dma
4         0.0383  sys_remap_file_pages
4         0.0383  vmtruncate
3         0.0287  __pte_alloc
3         0.0287  alloc_node_mem_map
3         0.0287  as_read_expire_store
3         0.0287  bitmap_find_free_region
3         0.0287  check_disk_change
3         0.0287  do_open
3         0.0287  do_sync
3         0.0287  do_sync_readv_writev
3         0.0287  early_serial_putc
3         0.0287  generic_ide_resume
3         0.0287  generic_shutdown_super
3         0.0287  ide_intr
3         0.0287  ide_register_hw_with_fixup
3         0.0287  install_file_pte
3         0.0287  install_page
3         0.0287  kobject_get_path
3         0.0287  ll_back_merge_fn
3         0.0287  lock_timer
3         0.0287  mpage_readpages
3         0.0287  on_freelist
3         0.0287  posix_cpu_nsleep
3         0.0287  rb_erase
3         0.0287  release_task
3         0.0287  rt_mutex_setprio
3         0.0287  sched_exit
3         0.0287  sg_scsi_ioctl
3         0.0287  show_partition
3         0.0287  show_schedstat
3         0.0287  sprint_symbol
3         0.0287  svc_seq_show
3         0.0287  sync_page_range
3         0.0287  sys_chown
3         0.0287  sys_mincore
3         0.0287  sys_mprotect
3         0.0287  sys_statfs
3         0.0287  sys_tee
3         0.0287  wake_up_new_task
2         0.0191  __elv_add_request
2         0.0191  __is_prefetch
2         0.0191  __register_chrdev_region
2         0.0191  account_steal_time
2         0.0191  apply_microcode
2         0.0191  as_antic_expire_store
2         0.0191  bd_forget
2         0.0191  bdput
2         0.0191  blk_init_queue_node
2         0.0191  blk_recount_segments
2         0.0191  blkdev_open
2         0.0191  calibrate_delay
2         0.0191  clear_page_dirty_for_io
2         0.0191  copy_page_range
2         0.0191  copy_process
2         0.0191  d_invalidate
2         0.0191  dentry_open
2         0.0191  dio_new_bio
2         0.0191  dio_send_cur_page
2         0.0191  do_brk
2         0.0191  do_msgrcv
2         0.0191  do_sync_read
2         0.0191  do_utimes
2         0.0191  dx_probe
2         0.0191  elv_insert
2         0.0191  elv_iosched_allow_merge
2         0.0191  elv_rb_del
2         0.0191  est_time_show
2         0.0191  exit_itimers
2         0.0191  ext3_free_inode
2         0.0191  ext3_mknod
2         0.0191  ext3_new_inode
2         0.0191  ext3_orphan_get
2         0.0191  filemap_nopage
2         0.0191  find_mergeable_anon_vma
2         0.0191  free_as_io_context
2         0.0191  freed_request
2         0.0191  get_signal_to_deliver
2         0.0191  get_timestamp
2         0.0191  grab_cache_page_nowait
2         0.0191  handle_stop_signal
2         0.0191  hrtimer_run_queues
2         0.0191  init_once
2         0.0191  inode_wait
2         0.0191  kobject_move
2         0.0191  kobject_shadow_rename
2         0.0191  load_elf_library
2         0.0191  lookup_address
2         0.0191  number
2         0.0191  open_namei
2         0.0191  pcibios_enable_device
2         0.0191  pcibios_fixup_bus
2         0.0191  poison_store
2         0.0191  prio_tree_next
2         0.0191  prio_tree_remove
2         0.0191  put_io_context
2         0.0191  read_port
2         0.0191  register_blkdev
2         0.0191  register_chrdev
2         0.0191  reiserfs_delete_xattrs
2         0.0191  reiserfs_xattr_init
2         0.0191  relay_destroy_buf
2         0.0191  request_irq
2         0.0191  rpc_proc_exit
2         0.0191  rpc_proc_init
2         0.0191  rpc_proc_open
2         0.0191  rw_copy_check_uvector
2         0.0191  sb_set_blocksize
2         0.0191  sched_setscheduler
2         0.0191  simple_strtoul
2         0.0191  skge_probe
2         0.0191  slab_pad_check
2         0.0191  strcspn
2         0.0191  sys_chdir
2         0.0191  sys_faccessat
2         0.0191  sys_fchdir
2         0.0191  sys_mq_timedreceive
2         0.0191  sys_mq_timedsend
2         0.0191  sys_openat
2         0.0191  sys_sync_file_range
2         0.0191  t_start
2         0.0191  tick_notify
2         0.0191  timer_list_show
2         0.0191  try_to_wake_up
2         0.0191  vfs_mknod
2         0.0191  vgacon_startup
2         0.0191  vm_normal_page
2         0.0191  vmtruncate_range
2         0.0191  zone_watermark_ok
1         0.0096  __activate_task
1         0.0096  __blockdev_direct_IO
1         0.0096  __call_usermodehelper
1         0.0096  __cleanup_sighand
1         0.0096  __d_lookup
1         0.0096  __ext3_get_inode_loc
1         0.0096  __free_pages_ok
1         0.0096  __free_slab
1         0.0096  __generic_file_aio_write_nolock
1         0.0096  __journal_drop_transaction
1         0.0096  __link_path_walk
1         0.0096  __posix_lock_file
1         0.0096  __ptrace_link
1         0.0096  __remove_shared_vm_struct
1         0.0096  __round_jiffies_relative
1         0.0096  __sigqueue_alloc
1         0.0096  __vma_link_rb
1         0.0096  __vmalloc_area_node
1         0.0096  __wait_on_freeing_inode
1         0.0096  __wake_up_common
1         0.0096  arch_ptrace
1         0.0096  arp_ioctl
1         0.0096  as_can_break_anticipation
1         0.0096  as_choose_req
1         0.0096  athlon_setup_ctrs
1         0.0096  background_writeout
1         0.0096  badness
1         0.0096  bd_get_sb
1         0.0096  bio_alloc_bioset
1         0.0096  blk_execute_rq_nowait
1         0.0096  blk_hw_contig_segment
1         0.0096  blk_ordered_complete_seq
1         0.0096  blk_ordered_cur_seq
1         0.0096  blk_ordered_req_seq
1         0.0096  blk_queue_find_tag
1         0.0096  blk_queue_make_request
1         0.0096  blk_queue_resize_tags
1         0.0096  blk_sync_queue
1         0.0096  blkdev_get_block
1         0.0096  blkdev_get_blocks
1         0.0096  block_fsync
1         0.0096  block_invalidatepage
1         0.0096  block_uevent_filter
1         0.0096  call_filldir
1         0.0096  call_usermodehelper_pipe
1         0.0096  cap_bprm_apply_creds
1         0.0096  cap_bprm_secureexec
1         0.0096  cap_capset_check
1         0.0096  cap_inode_setxattr
1         0.0096  cap_settime
1         0.0096  cap_vm_enough_memory
1         0.0096  cdev_get
1         0.0096  chrdev_show
1         0.0096  clockevents_set_mode
1         0.0096  common_timer_get
1         0.0096  complete_all
1         0.0096  congestion_wait_interruptible
1         0.0096  cp_old_stat
1         0.0096  cpu_idle
1         0.0096  current_io_context
1         0.0096  d_rehash
1         0.0096  deactivate_slab
1         0.0096  dev_kfree_skb_any
1         0.0096  discard_slab
1         0.0096  dma_declare_coherent_memory
1         0.0096  do_fcntl
1         0.0096  do_getitimer
1         0.0096  do_lookup
1         0.0096  do_munmap
1         0.0096  do_sched_setscheduler
1         0.0096  do_tkill
1         0.0096  do_wait
1         0.0096  drive_stat_acct
1         0.0096  dupfd
1         0.0096  elevator_alloc
1         0.0096  elevator_init
1         0.0096  elf_core_dump
1         0.0096  elv_attr_store
1         0.0096  elv_completed_request
1         0.0096  elv_unregister
1         0.0096  end_buffer_async_write
1         0.0096  expand_files
1         0.0096  expand_stack
1         0.0096  ext3_count_dirs
1         0.0096  ext3_find_entry
1         0.0096  ext3_free_blocks_sb
1         0.0096  ext3_getblk
1         0.0096  ext3_group_add
1         0.0096  ext3_new_blocks
1         0.0096  ext3_read_inode
1         0.0096  ext3_reserve_inode_write
1         0.0096  ext3_setattr
1         0.0096  ext3_symlink
1         0.0096  ext3_try_to_allocate
1         0.0096  ext3_xattr_block_set
1         0.0096  ext3_xattr_get
1         0.0096  ext3_xattr_trusted_list
1         0.0096  ext3_xattr_user_set
1         0.0096  file_send_actor
1         0.0096  filemap_fdatawait
1         0.0096  find_extend_vma
1         0.0096  follow_up
1         0.0096  force_sig_info_fault
1         0.0096  frag_show
1         0.0096  free_compound_page
1         0.0096  free_pgd_range
1         0.0096  generic_drop_inode
1         0.0096  generic_permission
1         0.0096  generic_unplug_device
1         0.0096  get_request_wait
1         0.0096  get_symbol_pos
1         0.0096  getname
1         0.0096  ide_hwif_request_regions
1         0.0096  ide_mm_inb
1         0.0096  ide_pci_setup_ports
1         0.0096  ide_setup_ports
1         0.0096  init_idedisk_capacity
1         0.0096  init_object
1         0.0096  init_request_from_bio
1         0.0096  init_tag_map
1         0.0096  inode_sub_bytes
1         0.0096  invalidate_bh_lrus
1         0.0096  ioctl_by_bdev
1         0.0096  ip_fragment
1         0.0096  iput
1         0.0096  it_real_fn
1         0.0096  itimer_get_remtime
1         0.0096  journal_commit_transaction
1         0.0096  journal_recover
1         0.0096  journal_refile_buffer
1         0.0096  kill_anon_super
1         0.0096  kill_litter_super
1         0.0096  kmem_cache_destroy
1         0.0096  kobject_shadow_add
1         0.0096  ll_rw_block
1         0.0096  lo_ioctl
1         0.0096  lookup_bdev
1         0.0096  may_attach
1         0.0096  may_open
1         0.0096  mb_cache_create
1         0.0096  mb_cache_entry_insert
1         0.0096  microcode_write
1         0.0096  modify_acceptable_latency
1         0.0096  mounts_release
1         0.0096  mpage_end_io_write
1         0.0096  neigh_resolve_output
1         0.0096  netif_rx
1         0.0096  nobh_prepare_write
1         0.0096  notify_arch_cmos_timer
1         0.0096  open_by_devnum
1         0.0096  p4_fill_in_addresses
1         0.0096  page_address_in_vma
1         0.0096  pci_write
1         0.0096  pcibios_assign_all_busses
1         0.0096  pcibios_disable_device
1         0.0096  pdflush
1         0.0096  pipe_read_open
1         0.0096  pirq_serverworks_set
1         0.0096  poll_idle
1         0.0096  posix_cpu_timer_del
1         0.0096  posix_timer_event
1         0.0096  prepare_to_wait_exclusive
1         0.0096  proc_dodebug
1         0.0096  proc_pid_auxv
1         0.0096  proc_task_lookup
1         0.0096  ptrace_attach
1         0.0096  ptrace_writedata
1         0.0096  raw_bind
1         0.0096  read_chan
1         0.0096  register_chrdev_region
1         0.0096  reiserfs_listxattr
1         0.0096  relay_file_mmap
1         0.0096  relay_file_open
1         0.0096  rpc_mkdir
1         0.0096  rpc_proc_show
1         0.0096  rt_check_expire
1         0.0096  run_local_timers
1         0.0096  run_posix_cpu_timers
1         0.0096  sb_min_blocksize
1         0.0096  schedule_tail
1         0.0096  set_blocksize
1         0.0096  set_ksettings
1         0.0096  set_load_weight
1         0.0096  setup_arg_pages
1         0.0096  setup_irq
1         0.0096  sg_io
1         0.0096  show_regs
1         0.0096  show_stat
1         0.0096  show_state_filter
1         0.0096  shrink_zone
1         0.0096  skb_checksum
1         0.0096  skge_get_coalesce
1         0.0096  skge_poll
1         0.0096  skge_set_coalesce
1         0.0096  sock_aio_write
1         0.0096  strnicmp
1         0.0096  svc_proc_register
1         0.0096  sys_chroot
1         0.0096  sys_fchmodat
1         0.0096  sys_get_thread_area
1         0.0096  sys_getcwd
1         0.0096  sys_mknodat
1         0.0096  sys_mlockall
1         0.0096  sys_nice
1         0.0096  sys_renameat
1         0.0096  sys_sched_get_priority_min
1         0.0096  sys_sendfile
1         0.0096  sys_sendfile64
1         0.0096  sys_timer_settime
1         0.0096  sys_uselib
1         0.0096  sysctl_head_next
1         0.0096  sysfs_follow_link
1         0.0096  sysfs_slab_add
1         0.0096  tcp_enter_quickack_mode
1         0.0096  tcp_v4_connect
1         0.0096  tcp_v4_hash
1         0.0096  throttle_vm_writeout
1         0.0096  trace
1         0.0096  udp_lib_unhash
1         0.0096  udp_proc_unregister
1         0.0096  uevent_helper_store
1         0.0096  unmap_mapping_range_vma
1         0.0096  unuse_table
1         0.0096  user_shm_unlock
1         0.0096  validate_store
1         0.0096  vfs_ioctl
1         0.0096  vgacon_scrolldelta
1         0.0096  vm_stat_account
1         0.0096  vma_adjust
1         0.0096  vprintk
1         0.0096  wait_for_helper
1         0.0096  wait_for_partner
1         0.0096  wait_on_retry_sync_kiocb
1         0.0096  wq_sleep
1         0.0096  write_boundary_block
1         0.0096  write_cache_pages
+ date
Fri Aug 17 20:17:53 EEST 2007

--------------090608080900060903030405
Content-Type: text/plain;
 name="oprof_two_disks.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprof_two_disks.txt"

+ date
Fri Aug 17 20:22:29 EEST 2007
+ rm -rf /var/lib/oprofile/
+ opcontrol --vmlinux=/home/jimis/dist/src/linux-2.6.22.3/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
     2528 52.9535 vmlinux
      874 18.3075 libc-2.6.1.so
      759 15.8986 ld-2.6.1.so
      358  7.4990 bash
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      357 99.7207 bash
	        1  0.2793 [vdso] (tgid:13041 range:0xb7f12000-0xb7f13000)
      109  2.2832 gawk
       68  1.4244 ISO8859-1.so
       13  0.2723 grep
       10  0.2095 locale-archive
        7  0.1466 badblocks
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        5 71.4286 badblocks
	        2 28.5714 [vdso] (tgid:10910 range:0xb7fc6000-0xb7fc7000)
        7  0.1466 libnetsnmp.so.15.0.0
        7  0.1466 imap-login
        5  0.1047 libdl-2.6.1.so
        4  0.0838 libncurses.so.5.6
        3  0.0628 ophelp
        3  0.0628 libcrypto.so.0.9.8
        3  0.0628 libpopt.so.0.0.0
        3  0.0628 dovecot-auth
        2  0.0419 libhistory.so.5.2
        2  0.0419 libnetsnmpmibs.so.15.0.0
        1  0.0209 ls
        1  0.0209 libext2fs.so.2.4
        1  0.0209 libreadline.so.5.2
        1  0.0209 init
        1  0.0209 id
        1  0.0209 oprofiled
        1  0.0209 screen-4.0.3
        1  0.0209 libnetsnmpagent.so.15.0.0
        1  0.0209 sshd
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        1 100.000 [vdso] (tgid:6746 range:0xb7f31000-0xb7f32000)
+ echo

+ echo

+ echo

+ opreport -l /home/jimis/dist/src/linux-2.6.22.3/vmlinux
CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
227       8.9794  rpc_print_iostats
206       8.1487  pre_reset
175       6.9225  kmem_cache_shrink
160       6.3291  irq_handler
112       4.4304  congestion_wait
100       3.9557  rpc_proc_open
79        3.1250  create_kmalloc_cache
76        3.0063  ide_do_request
72        2.8481  dump_task_extended_fpu
64        2.5316  vsscanf
56        2.2152  dump_task_regs
52        2.0570  do_syscall_trace
41        1.6218  interruptible_sleep_on
39        1.5427  __relay_reset
32        1.2658  do_wp_page
31        1.2263  kobject_rename
29        1.1472  sys_madvise
27        1.0680  __switch_to
24        0.9494  print_hex_dump
22        0.8703  test_set_page_writeback
20        0.7911  check_object
19        0.7516  do_ide_setup_pci_device
18        0.7120  sys_fadvise64_64
17        0.6725  rpc_proc_show
15        0.5934  ide_setup_pci_devices
14        0.5538  __handle_mm_fault
14        0.5538  handle_vm86_fault
14        0.5538  iput
13        0.5142  svc_seq_show
12        0.4747  do_page_fault
12        0.4747  vsnprintf
11        0.4351  calibrate_delay
11        0.4351  generic_file_buffered_write
11        0.4351  zap_pte
11        0.4351  zoneinfo_show
10        0.3956  access_process_vm
10        0.3956  vm_normal_page
9         0.3560  blk_release_queue
9         0.3560  block_truncate_page
9         0.3560  kmem_cache_create
9         0.3560  setup_sigcontext
8         0.3165  dio_get_page
7         0.2769  bdev_clear_inode
7         0.2769  elv_next_request
7         0.2769  loop_alloc
7         0.2769  print_bad_pte
7         0.2769  rpc_proc_exit
7         0.2769  unmap_vmas
7         0.2769  write_cache_pages
6         0.2373  __switch_to_xtra
6         0.2373  bio_split
6         0.2373  load_elf_binary
6         0.2373  on_freelist
6         0.2373  sys_mprotect
5         0.1978  __blk_put_request
5         0.1978  __blkdev_put
5         0.1978  bdget
5         0.1978  blk_cleanup_queue
5         0.1978  cont_prepare_write
5         0.1978  do_open
5         0.1978  do_sysctl_strategy
5         0.1978  idedisk_check_hpa
5         0.1978  lock_timer
5         0.1978  posix_cpu_nsleep
5         0.1978  sys_mq_timedsend
5         0.1978  test_clear_page_writeback
4         0.1582  __pte_alloc
4         0.1582  __setlease
4         0.1582  assign_all_busses
4         0.1582  bd_release_from_disk
4         0.1582  blk_get_request
4         0.1582  cdev_get
4         0.1582  dio_cleanup
4         0.1582  generic_ide_ioctl
4         0.1582  ioctl_by_bdev
4         0.1582  lookup_bdev
4         0.1582  prio_tree_insert
4         0.1582  relay_switch_subbuf
4         0.1582  rpc_count_iostats
4         0.1582  rpc_proc_init
4         0.1582  sched_setscheduler
4         0.1582  scsi_cmd_ioctl
4         0.1582  svc_proc_unregister
4         0.1582  sys_chroot
4         0.1582  sys_mincore
4         0.1582  sys_mq_open
4         0.1582  wake_up_new_task
3         0.1187  as_can_break_anticipation
3         0.1187  blk_init_queue_node
3         0.1187  blk_phys_contig_segment
3         0.1187  blkdev_close
3         0.1187  cap_bprm_apply_creds
3         0.1187  dio_new_bio
3         0.1187  do_sendfile
3         0.1187  do_sync_readv_writev
3         0.1187  do_sysctl
3         0.1187  elf_core_dump
3         0.1187  fcntl_setlk
3         0.1187  filemap_nopage
3         0.1187  follow_page
3         0.1187  generic_unplug_device
3         0.1187  locks_mandatory_area
3         0.1187  pcibios_setup
3         0.1187  pipe_write
3         0.1187  prio_tree_next
3         0.1187  proc_dodebug
3         0.1187  register_chrdev
3         0.1187  remap_pfn_range
3         0.1187  rw_copy_check_uvector
3         0.1187  send_group_sigqueue
3         0.1187  sys_fchmodat
3         0.1187  sys_remap_file_pages
3         0.1187  vfs_mkdir
3         0.1187  vfs_mknod
3         0.1187  vma_adjust
3         0.1187  vma_merge
2         0.0791  __end_that_request_first
2         0.0791  __free_slab
2         0.0791  add_to_page_cache_lru
2         0.0791  as_fifo_expired
2         0.0791  bd_claim_by_disk
2         0.0791  bio_pair_end_2
2         0.0791  blk_alloc_queue_node
2         0.0791  blk_done_softirq
2         0.0791  blk_ordered_req_seq
2         0.0791  blk_sync_queue
2         0.0791  calculate_totalreserve_pages
2         0.0791  copy_page_range
2         0.0791  dentry_open
2         0.0791  do_exit
2         0.0791  do_mmap_pgoff
2         0.0791  do_mremap
2         0.0791  do_msgrcv
2         0.0791  do_munmap
2         0.0791  do_notify_parent
2         0.0791  dump_thread
2         0.0791  elv_rb_del
2         0.0791  ext3_count_dirs
2         0.0791  ext3_free_inode
2         0.0791  ext3_new_inode
2         0.0791  flush_old_exec
2         0.0791  force_sig_info_fault
2         0.0791  generic_shutdown_super
2         0.0791  grab_cache_page_nowait
2         0.0791  handle_stop_signal
2         0.0791  ide_hwif_request_regions
2         0.0791  init_cpu_workqueue
2         0.0791  init_idedisk_capacity
2         0.0791  insert_vm_struct
2         0.0791  install_file_pte
2         0.0791  interruptible_sleep_on_timeout
2         0.0791  ll_back_merge_fn
2         0.0791  page_address_in_vma
2         0.0791  pirq_enable_irq
2         0.0791  proc_task_lookup
2         0.0791  read_port
2         0.0791  relay_file_read_consume
2         0.0791  rt_mutex_setprio
2         0.0791  rtc_cmos_read
2         0.0791  sg_scsi_ioctl
2         0.0791  subbuf_send_actor
2         0.0791  sync_page_range
2         0.0791  sys_chdir
2         0.0791  sys_chown
2         0.0791  sys_mlockall
2         0.0791  sys_sendfile
2         0.0791  sys_setfsuid
2         0.0791  sys_sysinfo
2         0.0791  t_start
2         0.0791  tick_notify
2         0.0791  vfs_rename
2         0.0791  vfs_unlink
2         0.0791  vgacon_startup
2         0.0791  vmtruncate
1         0.0396  __blk_free_tags
1         0.0396  __d_find_alias
1         0.0396  __elv_add_request
1         0.0396  __f_setown
1         0.0396  __filemap_copy_from_user_iovec_inatomic
1         0.0396  __group_complete_signal
1         0.0396  __is_prefetch
1         0.0396  __link_path_walk
1         0.0396  __netif_rx_schedule
1         0.0396  __oom_kill_task
1         0.0396  __pte_alloc_kernel
1         0.0396  __put_user_1
1         0.0396  __remove_suid
1         0.0396  __set_page_dirty_buffers
1         0.0396  __set_special_pids
1         0.0396  __strncpy_from_user
1         0.0396  __vmalloc_area_node
1         0.0396  __wait_on_freeing_inode
1         0.0396  __wake_up_common
1         0.0396  alloc_chrdev_region
1         0.0396  apply_microcode
1         0.0396  arch_align_stack
1         0.0396  as_antic_stop
1         0.0396  as_choose_req
1         0.0396  as_read_batch_expire_show
1         0.0396  as_read_expire_store
1         0.0396  as_update_iohist
1         0.0396  badness
1         0.0396  blk_execute_rq
1         0.0396  blk_execute_rq_nowait
1         0.0396  blk_free_tags
1         0.0396  blk_hw_contig_segment
1         0.0396  blk_plug_device
1         0.0396  blk_queue_find_tag
1         0.0396  blk_queue_hardsect_size
1         0.0396  blk_register_queue
1         0.0396  blk_remove_plug
1         0.0396  blkdev_direct_IO
1         0.0396  blkdev_get
1         0.0396  blkdev_open
1         0.0396  block_fsync
1         0.0396  call_usermodehelper_pipe
1         0.0396  can_do_mlock
1         0.0396  cap_ptrace
1         0.0396  cap_settime
1         0.0396  cap_task_post_setuid
1         0.0396  cascade
1         0.0396  cdev_del
1         0.0396  check_disk_change
1         0.0396  check_slab
1         0.0396  congestion_wait_interruptible
1         0.0396  cpu_idle_wait
1         0.0396  create_new_namespaces
1         0.0396  current_io_context
1         0.0396  d_alloc
1         0.0396  d_hash_and_lookup
1         0.0396  del_timer
1         0.0396  dev_hard_start_xmit
1         0.0396  dio_complete
1         0.0396  do_brk
1         0.0396  do_fcntl
1         0.0396  do_generic_mapping_read
1         0.0396  do_iret_error
1         0.0396  do_mpage_readpage
1         0.0396  do_sched_setscheduler
1         0.0396  do_sync
1         0.0396  do_writepages
1         0.0396  dup_fd
1         0.0396  elevator_alloc
1         0.0396  elv_completed_request
1         0.0396  elv_insert
1         0.0396  elv_merged_request
1         0.0396  elv_requeue_request
1         0.0396  elv_unregister
1         0.0396  end_buffer_read_sync
1         0.0396  exit_itimers
1         0.0396  ext3_bread
1         0.0396  ext3_rename
1         0.0396  ext3_xattr_trusted_list
1         0.0396  free_pgtables
1         0.0396  freed_request
1         0.0396  generic_drop_inode
1         0.0396  generic_file_sendfile
1         0.0396  generic_fillattr
1         0.0396  generic_ide_resume
1         0.0396  generic_ide_suspend
1         0.0396  generic_permission
1         0.0396  get_next_timer_interrupt
1         0.0396  get_symbol_offset
1         0.0396  get_timestamp
1         0.0396  getname
1         0.0396  ide_intr
1         0.0396  ide_pci_setup_ports
1         0.0396  ide_setup_pci_device
1         0.0396  ide_taskfile_ioctl
1         0.0396  init_object
1         0.0396  init_once
1         0.0396  internal_add_timer
1         0.0396  ip_options_get_from_user
1         0.0396  journal_add_journal_head
1         0.0396  kill_anon_super
1         0.0396  kmem_ptr_validate
1         0.0396  kobject_get_path
1         0.0396  kobject_move
1         0.0396  laptop_io_completion
1         0.0396  link_path_walk
1         0.0396  lock_task_sighand
1         0.0396  log_do_checkpoint
1         0.0396  lookup_one_len
1         0.0396  madvise_need_mmap_write
1         0.0396  may_open
1         0.0396  mb_cache_create
1         0.0396  microcode_write
1         0.0396  mm_release
1         0.0396  mounts_release
1         0.0396  mpage_readpages
1         0.0396  mqueue_read_file
1         0.0396  netstat_show
1         0.0396  nobh_prepare_write
1         0.0396  normalize_rt_tasks
1         0.0396  notify_arch_cmos_timer
1         0.0396  nr_processes
1         0.0396  number
1         0.0396  open_bdev_excl
1         0.0396  open_namei
1         0.0396  out_of_memory
1         0.0396  p4_start
1         0.0396  page_cache_read
1         0.0396  page_mkclean
1         0.0396  pcibios_disable_device
1         0.0396  pdflush
1         0.0396  pipe_poll
1         0.0396  poison_store
1         0.0396  posix_cpu_nsleep_restart
1         0.0396  prepare_timeout
1         0.0396  prio_tree_remove
1         0.0396  proc_pid_auxv
1         0.0396  profile_event_unregister
1         0.0396  profile_hits
1         0.0396  ptmx_open
1         0.0396  ptrace_attach
1         0.0396  read_cache_page_async
1         0.0396  read_profile
1         0.0396  recalc_task_prio
1         0.0396  register_console
1         0.0396  relay_file_mmap
1         0.0396  relay_file_open
1         0.0396  relay_file_poll
1         0.0396  release_task
1         0.0396  reparent_thread
1         0.0396  request_irq
1         0.0396  rpc_alloc_iostats
1         0.0396  rt_fill_info
1         0.0396  run_posix_cpu_timers
1         0.0396  rw_verify_area
1         0.0396  sb_set_blocksize
1         0.0396  sched_exit
1         0.0396  sched_fork
1         0.0396  send_signal
1         0.0396  set_bdi_congested
1         0.0396  set_blocksize
1         0.0396  set_load_weight
1         0.0396  set_page_dirty_lock
1         0.0396  setup_irq
1         0.0396  sg_io
1         0.0396  show_partition
1         0.0396  show_regs
1         0.0396  show_schedstat
1         0.0396  shrink_zone
1         0.0396  strpbrk
1         0.0396  subbuf_read_actor
1         0.0396  svc_proc_register
1         0.0396  sys_faccessat
1         0.0396  sys_io_getevents
1         0.0396  sys_mlock
1         0.0396  sys_munlock
1         0.0396  sys_sched_get_priority_min
1         0.0396  sys_setitimer
1         0.0396  sys_setregid
1         0.0396  sys_sigaction
1         0.0396  sys_splice
1         0.0396  sys_stat
1         0.0396  sys_statfs
1         0.0396  sys_sync_file_range
1         0.0396  sys_sysctl
1         0.0396  sys_vm86old
1         0.0396  sysctl_head_finish
1         0.0396  sysctl_head_next
1         0.0396  try_to_free_buffers
1         0.0396  unuse_table
1         0.0396  user_shm_lock
1         0.0396  validate_store
1         0.0396  vfs_ioctl
1         0.0396  vm_stat_account
1         0.0396  vma_link
1         0.0396  vprintk
1         0.0396  wait_on_retry_sync_kiocb
1         0.0396  wait_on_work
1         0.0396  wake_up_inode
1         0.0396  will_become_orphaned_pgrp
1         0.0396  write_boundary_block
1         0.0396  write_full
+ date
Fri Aug 17 20:23:34 EEST 2007

--------------090608080900060903030405
Content-Type: text/plain;
 name="oprof_two_disks_bad2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprof_two_disks_bad2.txt"

+ date
Sat Aug 18 00:13:48 EEST 2007
+ rm -rf /var/lib/oprofile/
+ opcontrol --vmlinux=/home/jimis/dist/src/linux-2.6.22.3/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
     3020 34.9902 vmlinux
     1920 22.2454 libc-2.6.1.so
     1274 14.7607 libpython2.5.so.1.0
     1140 13.2082 perl
      432  5.0052 mpop
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      430 99.5370 mpop
	        2  0.4630 [vdso] (tgid:16432 range:0xb7f24000-0xb7f25000)
      253  2.9313 bash
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      252 99.6047 bash
	        1  0.3953 [vdso] (tgid:16796 range:0xb7fbe000-0xb7fbf000)
      229  2.6532 ld-2.6.1.so
      105  1.2165 libgnutls.so.13.3.0
       49  0.5677 ISO8859-1.so
       46  0.5330 libgcrypt.so.11.2.3
       38  0.4403 libpthread-2.6.1.so
       27  0.3128 badblocks
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       17 62.9630 badblocks
	        8 29.6296 [vdso] (tgid:16297 range:0xb7fb6000-0xb7fb7000)
	        2  7.4074 [vdso] (tgid:16298 range:0xb7f62000-0xb7f63000)
       20  0.2317 screen-4.0.3
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       19 95.0000 screen-4.0.3
	        1  5.0000 [vdso] (tgid:16282 range:0xb7f25000-0xb7f26000)
       11  0.1274 slocate
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        7 63.6364 slocate
	        4 36.3636 [vdso] (tgid:16652 range:0xb7efe000-0xb7eff000)
       10  0.1159 imap-login
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        8 80.0000 imap-login
	        2 20.0000 [vdso] (tgid:15896 range:0xb7ef9000-0xb7efa000)
        9  0.1043 libncurses.so.5.6
        8  0.0927 gawk
        7  0.0811 grep
        6  0.0695 python2.5
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        5 83.3333 [vdso] (tgid:16627 range:0xb7efd000-0xb7efe000)
	        1 16.6667 [vdso] (tgid:16686 range:0xb7fa7000-0xb7fa8000)
        6  0.0695 libnetsnmp.so.15.0.0
        5  0.0579 libext2fs.so.2.4
        3  0.0348 dovecot
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        2 66.6667 dovecot
	        1 33.3333 [vdso] (tgid:1923 range:0xb7ef7000-0xb7ef8000)
        3  0.0348 sshd
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        2 66.6667 sshd
	        1 33.3333 [vdso] (tgid:15858 range:0xb7f64000-0xb7f65000)
        2  0.0232 libcrypto.so.0.9.8
        1  0.0116 ls
        1  0.0116 tr
        1  0.0116 libpcre.so.0.0.1
        1  0.0116 which
        1  0.0116 libnetsnmpagent.so.15.0.0
        1  0.0116 libnetsnmpmibs.so.15.0.0
        1  0.0116 locale-archive
        1  0.0116 dovecot-auth
+ echo

+ echo

+ echo

+ opreport -l /home/jimis/dist/src/linux-2.6.22.3/vmlinux
CPU: PIII, speed 798.02 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
282       9.3377  pre_reset
231       7.6490  rpc_print_iostats
222       7.3510  do_syscall_trace
146       4.8344  ide_do_request
144       4.7682  dump_task_regs
131       4.3377  rpc_proc_open
122       4.0397  congestion_wait
98        3.2450  vsscanf
52        1.7219  __switch_to
33        1.0927  interruptible_sleep_on
32        1.0596  check_object
32        1.0596  setup_sigcontext
32        1.0596  sys_sigaction
31        1.0265  block_truncate_page
31        1.0265  sys_fadvise64_64
31        1.0265  test_set_page_writeback
28        0.9272  __blkdev_put
28        0.9272  sys_madvise
26        0.8609  svc_seq_show
22        0.7285  do_wp_page
22        0.7285  zap_pte
21        0.6954  dump_task_extended_fpu
21        0.6954  elv_next_request
21        0.6954  generic_file_buffered_write
21        0.6954  unmap_vmas
20        0.6623  zoneinfo_show
19        0.6291  __relay_reset
19        0.6291  cont_prepare_write
18        0.5960  bdget
18        0.5960  calibrate_delay
18        0.5960  do_page_fault
17        0.5629  ide_setup_pci_devices
17        0.5629  scsi_cmd_ioctl
17        0.5629  vsnprintf
16        0.5298  bd_release_from_disk
16        0.5298  bdev_clear_inode
16        0.5298  do_ide_setup_pci_device
15        0.4967  kobject_rename
14        0.4636  blkdev_close
14        0.4636  print_hex_dump
13        0.4305  access_process_vm
13        0.4305  do_open
12        0.3974  bio_split
12        0.3974  blk_release_queue
12        0.3974  do_sendfile
12        0.3974  handle_vm86_fault
11        0.3642  __handle_mm_fault
11        0.3642  bd_claim_by_disk
11        0.3642  rpc_proc_show
10        0.3311  __switch_to_xtra
10        0.3311  posix_cpu_nsleep
9         0.2980  do_generic_mapping_read
9         0.2980  install_file_pte
9         0.2980  sg_scsi_ioctl
9         0.2980  vgacon_startup
8         0.2649  do_mpage_readpage
8         0.2649  prio_tree_insert
8         0.2649  test_clear_page_writeback
7         0.2318  init_once
7         0.2318  locks_mandatory_area
7         0.2318  loop_alloc
7         0.2318  register_blkdev
7         0.2318  rt_mutex_setprio
6         0.1987  daemonize
6         0.1987  idedisk_check_hpa
6         0.1987  pcibios_setup
6         0.1987  ptrace_request
6         0.1987  shrink_zone
6         0.1987  sys_chdir
6         0.1987  sys_mq_open
5         0.1656  as_update_iohist
5         0.1656  blk_cleanup_queue
5         0.1656  blkdev_direct_IO
5         0.1656  current_io_context
5         0.1656  do_sysctl_strategy
5         0.1656  ext3_xattr_list
5         0.1656  ide_setup_ports
5         0.1656  igrab
5         0.1656  on_freelist
5         0.1656  register_chrdev
5         0.1656  show_partition
5         0.1656  vfs_rename
5         0.1656  vgacon_scrolldelta
5         0.1656  vm_normal_page
5         0.1656  vmtruncate
5         0.1656  write_cache_pages
4         0.1325  __free_slab
4         0.1325  __generic_file_aio_write_nolock
4         0.1325  __make_request
4         0.1325  bd_forget
4         0.1325  blk_queue_make_request
4         0.1325  dio_get_page
4         0.1325  dio_new_bio
4         0.1325  do_exit
4         0.1325  do_fcntl
4         0.1325  elv_insert
4         0.1325  generic_file_sendfile
4         0.1325  generic_ide_suspend
4         0.1325  generic_segment_checks
4         0.1325  init_idedisk_capacity
4         0.1325  kill_litter_super
4         0.1325  load_elf_binary
4         0.1325  lock_timer
4         0.1325  number
4         0.1325  page_cache_read
4         0.1325  prio_tree_next
4         0.1325  process_slab
4         0.1325  read_cache_page_async
4         0.1325  setup_irq
4         0.1325  sg_io
4         0.1325  sync_page_range
3         0.0993  __break_lease
3         0.0993  __end_that_request_first
3         0.0993  add_to_page_cache
3         0.0993  athlon_setup_ctrs
3         0.0993  blk_execute_rq_nowait
3         0.0993  blk_hw_contig_segment
3         0.0993  blk_ordered_req_seq
3         0.0993  blk_queue_find_tag
3         0.0993  blk_rq_map_kern
3         0.0993  cap_bprm_apply_creds
3         0.0993  cap_settime
3         0.0993  cap_task_post_setuid
3         0.0993  check_disk_change
3         0.0993  check_slab
3         0.0993  d_invalidate
3         0.0993  dio_cleanup
3         0.0993  dio_complete
3         0.0993  do_mremap
3         0.0993  do_sync_write
3         0.0993  do_wait
3         0.0993  elv_completed_request
3         0.0993  est_time_show
3         0.0993  ext3_xattr_set_handle
3         0.0993  fcntl_setlk
3         0.0993  generic_ide_ioctl
3         0.0993  ioctl_by_bdev
3         0.0993  iput
3         0.0993  ll_back_merge_fn
3         0.0993  lookup_bdev
3         0.0993  open_by_devnum
3         0.0993  page_address_in_vma
3         0.0993  pipe_write
3         0.0993  posix_cpu_nsleep_restart
3         0.0993  relay_file_read
3         0.0993  rpc_proc_init
3         0.0993  sb_min_blocksize
3         0.0993  sb_set_blocksize
3         0.0993  svc_proc_unregister
3         0.0993  sys_mprotect
3         0.0993  sys_mq_timedsend
3         0.0993  tcp_rcv_state_process
3         0.0993  vma_adjust
2         0.0662  __blk_free_tags
2         0.0662  __journal_abort_hard
2         0.0662  __journal_drop_transaction
2         0.0662  __pte_alloc
2         0.0662  __vmalloc_area_node
2         0.0662  add_to_page_cache_lru
2         0.0662  aio_complete
2         0.0662  alloc_node_mem_map
2         0.0662  as_can_break_anticipation
2         0.0662  as_choose_req
2         0.0662  as_read_batch_expire_store
2         0.0662  as_read_expire_store
2         0.0662  assign_all_busses
2         0.0662  background_writeout
2         0.0662  bdput
2         0.0662  bio_alloc_bioset
2         0.0662  bio_endio
2         0.0662  blk_alloc_queue_node
2         0.0662  blk_end_sync_rq
2         0.0662  blkdev_open
2         0.0662  block_uevent_filter
2         0.0662  cdev_del
2         0.0662  cdev_get
2         0.0662  copy_page_range
2         0.0662  dio_send_cur_page
2         0.0662  do_mmap_pgoff
2         0.0662  do_notify_parent
2         0.0662  do_sync_readv_writev
2         0.0662  early_serial_putc
2         0.0662  early_serial_write
2         0.0662  elevator_init
2         0.0662  elv_iosched_allow_merge
2         0.0662  elv_rq_merge_ok
2         0.0662  free_as_io_context
2         0.0662  generic_shutdown_super
2         0.0662  grab_cache_page_nowait
2         0.0662  hwif_request_region
2         0.0662  ide_pci_setup_ports
2         0.0662  ide_setup_pci_device
2         0.0662  ide_taskfile_ioctl
2         0.0662  idle_cpu
2         0.0662  journal_flush
2         0.0662  kmem_cache_create
2         0.0662  lookup_one_len
2         0.0662  mpage_readpages
2         0.0662  notify_arch_cmos_timer
2         0.0662  open_bdev_excl
2         0.0662  pirq_piix_set
2         0.0662  print_bad_pte
2         0.0662  prio_tree_remove
2         0.0662  proc_dodebug
2         0.0662  release_task
2         0.0662  rpc_proc_exit
2         0.0662  rtc_cmos_read
2         0.0662  send_sigio
2         0.0662  set_blocksize
2         0.0662  set_ksettings
2         0.0662  set_using_dma
2         0.0662  sha_transform
2         0.0662  show_schedstat
2         0.0662  sprint_symbol
2         0.0662  sys_faccessat
2         0.0662  sys_fchmodat
2         0.0662  sys_remap_file_pages
2         0.0662  sys_vm86old
2         0.0662  sysctl_head_next
2         0.0662  t_start
2         0.0662  throttle_vm_writeout
2         0.0662  vfs_ioctl
2         0.0662  vfs_mknod
2         0.0662  vfs_unlink
2         0.0662  vgacon_deinit
2         0.0662  vmalloc_sync_all
2         0.0662  wake_up_new_task
2         0.0662  write_boundary_block
2         0.0662  zone_watermark_ok
1         0.0331  __blk_put_request
1         0.0331  __blkdev_get
1         0.0331  __filemap_copy_from_user_iovec_inatomic
1         0.0331  __find_get_block
1         0.0331  __follow_mount
1         0.0331  __free_pages_ok
1         0.0331  __is_prefetch
1         0.0331  __netif_schedule
1         0.0331  __register_chrdev_region
1         0.0331  __remove_hrtimer
1         0.0331  __set_page_dirty_buffers
1         0.0331  __set_page_dirty_nobuffers
1         0.0331  add_timer_randomness
1         0.0331  arch_ptrace
1         0.0331  as_fifo_expired
1         0.0331  as_put_io_context
1         0.0331  as_trim
1         0.0331  badness
1         0.0331  bio_pair_end_2
1         0.0331  bitmap_find_free_region
1         0.0331  blk_free_tags
1         0.0331  blk_init_queue_node
1         0.0331  blk_ordered_cur_seq
1         0.0331  blk_queue_resize_tags
1         0.0331  blk_remove_plug
1         0.0331  blk_sync_queue
1         0.0331  blkdev_get_block
1         0.0331  calculate_totalreserve_pages
1         0.0331  cap_vm_enough_memory
1         0.0331  clocksource_watchdog
1         0.0331  complete
1         0.0331  complete_all
1         0.0331  congestion_wait_interruptible
1         0.0331  copy_process
1         0.0331  cpu_idle
1         0.0331  create_new_namespaces
1         0.0331  current_is_keventd
1         0.0331  dentry_open
1         0.0331  dma_declare_coherent_memory
1         0.0331  do_alignment_check
1         0.0331  do_coredump
1         0.0331  do_getitimer
1         0.0331  do_kern_mount
1         0.0331  do_munmap
1         0.0331  do_sched_setscheduler
1         0.0331  do_sync
1         0.0331  do_sync_read
1         0.0331  do_sys_poll
1         0.0331  do_sysctl
1         0.0331  do_syslog
1         0.0331  do_timer
1         0.0331  do_utimes
1         0.0331  drive_stat_acct
1         0.0331  dump_thread
1         0.0331  dup_fd
1         0.0331  elevator_alloc
1         0.0331  eligible_child
1         0.0331  elv_attr_store
1         0.0331  elv_rb_add
1         0.0331  elv_rb_del
1         0.0331  elv_unregister
1         0.0331  end_buffer_async_write
1         0.0331  expand_stack
1         0.0331  ext3_count_dirs
1         0.0331  ext3_new_blocks
1         0.0331  ext3_orphan_get
1         0.0331  ext3_rename
1         0.0331  ext3_xattr_block_set
1         0.0331  ext3_xattr_get
1         0.0331  ext3_xattr_set
1         0.0331  f_delown
1         0.0331  filemap_fdatawait
1         0.0331  filemap_nopage
1         0.0331  flush_old_exec
1         0.0331  flush_thread
1         0.0331  fn_hash_insert
1         0.0331  follow_mount
1         0.0331  force_sig_info_fault
1         0.0331  force_sigsegv
1         0.0331  frag_start
1         0.0331  free_fdtable_work
1         0.0331  freed_request
1         0.0331  generic_fillattr
1         0.0331  generic_ide_resume
1         0.0331  generic_permission
1         0.0331  generic_unplug_device
1         0.0331  get_request_wait
1         0.0331  get_signal_to_deliver
1         0.0331  get_symbol_offset
1         0.0331  ide_abort
1         0.0331  init_object
1         0.0331  init_tag_map
1         0.0331  inode_add_bytes
1         0.0331  insert_wq_barrier
1         0.0331  install_page
1         0.0331  interruptible_sleep_on_timeout
1         0.0331  ip_fragment
1         0.0331  itimer_get_remtime
1         0.0331  journal_start
1         0.0331  kill_anon_super
1         0.0331  kill_fasync
1         0.0331  kmem_ptr_validate
1         0.0331  kobject_register
1         0.0331  kobject_shadow_add
1         0.0331  kobject_uevent_env
1         0.0331  ktime_get_real
1         0.0331  link_path_walk
1         0.0331  lo_ioctl
1         0.0331  locks_insert_block
1         0.0331  log_do_checkpoint
1         0.0331  madvise_need_mmap_write
1         0.0331  memory_open
1         0.0331  mincore_page
1         0.0331  nobh_prepare_write
1         0.0331  normalize_rt_tasks
1         0.0331  out_of_memory
1         0.0331  page_mkclean
1         0.0331  pcibios_fixup_bus
1         0.0331  posix_cpu_timer_set
1         0.0331  posix_timer_event
1         0.0331  prepare_to_wait_exclusive
1         0.0331  prio_tree_left
1         0.0331  proc_pid_auxv
1         0.0331  proc_task_lookup
1         0.0331  profile_hits
1         0.0331  profile_task_exit
1         0.0331  ptrace_attach
1         0.0331  ptrace_detach
1         0.0331  ptrace_writedata
1         0.0331  put_io_context
1         0.0331  rb_first
1         0.0331  read_port
1         0.0331  read_profile
1         0.0331  red_zone_store
1         0.0331  register_posix_clock
1         0.0331  relay_file_mmap
1         0.0331  relay_file_open
1         0.0331  relay_file_read_consume
1         0.0331  relay_file_release
1         0.0331  release_console_sem
1         0.0331  reparent_thread
1         0.0331  request_irq
1         0.0331  rq_init
1         0.0331  run_local_timers
1         0.0331  run_posix_cpu_timers
1         0.0331  rw_copy_check_uvector
1         0.0331  rw_verify_area
1         0.0331  sched_exit
1         0.0331  sched_setscheduler
1         0.0331  send_group_sigqueue
1         0.0331  set_close_on_exec
1         0.0331  set_load_weight
1         0.0331  skge_set_coalesce
1         0.0331  sock_aio_write
1         0.0331  sock_sendmsg
1         0.0331  strcasecmp
1         0.0331  strncasecmp
1         0.0331  strstr
1         0.0331  subbuf_send_actor
1         0.0331  svc_proc_register
1         0.0331  sys_chroot
1         0.0331  sys_mincore
1         0.0331  sys_munlockall
1         0.0331  sys_openat
1         0.0331  sys_sendfile64
1         0.0331  sys_setfsuid
1         0.0331  sys_sysctl
1         0.0331  sys_tee
1         0.0331  sysfs_follow_link
1         0.0331  task_prio
1         0.0331  tcp_add_reno_sack
1         0.0331  timekeeping_resume
1         0.0331  try_acquire_console_sem
1         0.0331  uevent_helper_store
1         0.0331  unix_release_sock
1         0.0331  unregister_timer_hook
1         0.0331  unuse_table
1         0.0331  update_iter
1         0.0331  user_shm_lock
1         0.0331  vfs_mkdir
1         0.0331  vma_merge
1         0.0331  wait_on_page_writeback_range
1         0.0331  wait_on_retry_sync_kiocb
1         0.0331  wb_kupdate
+ date
Sat Aug 18 00:16:13 EEST 2007

--------------090608080900060903030405
Content-Type: text/plain;
 name="vmstat_idle.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmstat_idle.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 138400  28520  68632    0    0    35  1854  143   96 20  3 72  5
 0  0      0 138400  28520  68632    0    0     0     0  101   11  0  0 100  0
 0  0      0 138400  28520  68632    0    0     0     0  103   13  0  0 100  0
 0  0      0 138400  28520  68632    0    0     0   756  154   15  0  0 100  0
 0  0      0 138400  28520  68632    0    0     0     0  106   13  0  0 100  0
 0  0      0 138400  28520  68632    0    0     0     0  106   13  0  0 100  0
 0  0      0 138400  28528  68632    0    0     0    52  111   21  0  0 100  0
 0  0      0 138400  28528  68632    0    0     0     0  104   18  0  1 99  0
 0  0      0 138400  28528  68632    0    0     0     0  102   18  0  0 100  0
 0  0      0 138400  28528  68632    0    0     0     0  103    9  0  0 100  0

--------------090608080900060903030405
Content-Type: text/plain;
 name="vmstat_one_disk.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmstat_one_disk.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  1      0 137068  29776  68644    0    0    28  2948  160  126 23  4 67  6
 0  1      0 137068  29776  68644    0    0     0 21696  442  690  0  2  0 98
 0  1      0 137068  29776  68644    0    0     0 21632  440  690  0  1  0 99
 0  1      0 137068  29776  68644    0    0     0 21696  440  688  0  3  0 97
 1  1      0 137068  29776  68644    0    0     0 21632  440  690  0  3  0 97
 1  1      0 137068  29784  68644    0    0     0 21688  441  697  0  2  0 98
 1  1      0 137068  29784  68644    0    0     0 21696  444  695  0  1  0 99
 0  1      0 137068  29784  68644    0    0     0 21632  439  689  0  1  0 99
 0  1      0 137068  29784  68644    0    0     0 21632  439  689  0  3  0 97
 0  1      0 137068  29784  68644    0    0     0 21696  440  687  0  2  0 98

--------------090608080900060903030405
Content-Type: text/plain;
 name="vmstat_two_disks.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmstat_two_disks.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  2      0 133908  31200  70236    0    0    26  4585  185  177 22  4 61 14
 2  2      0 133908  31200  70236    0    0     0 15936  354  488  0  2  0 98
 1  2      0 133908  31200  70236    0    0     0 16064  356  514  0  1  0 99
 1  2      0 133908  31200  70236    0    0     0 16000  354  496  0  1  0 99
 2  2      0 133908  31200  70236    0    0     0 15872  350  481  0  3  0 97
 2  2      0 133908  31200  70236    0    0     0 15872  350  477  0  3  0 97
 2  2      0 133908  31208  70236    0    0     0 15984  357  507  0  2  0 98
 2  2      0 133908  31208  70236    0    0     0 15872  352  481  0  4  0 96
 3  2      0 133908  31208  70236    0    0     0 15872  351  469  0  2  0 98
 3  2      0 133908  31208  70236    0    0     0 16000  355  500  0  1  0 99

--------------090608080900060903030405
Content-Type: text/plain;
 name="vmstat_two_disks_bad2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmstat_two_disks_bad2.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 8  1      0   8260  64260 117276    0    0    18  2481  239  279 44  7 44  5
 8  2      0   8200  64260 117276    0    0     0 15920  361  510 89 11  0  0
 9  2      0   8200  64268 117276    0    0     0 16100  362  511 89 11  0  0
 9  2      0   8200  64268 117276    0    0     0 16000  353  495 85 15  0  0
 8  2      0   8200  64268 117276    0    0     0 16000  352  502 90 10  0  0
 9  2      0   8200  64268 117276    0    0     0 15872  350  494 88 12  0  0
 8  2      0   8200  64268 117276    0    0     0 15872  350  497 91  9  0  0
 9  2      0   8200  64268 117276    0    0     0 15872  353  471 75 25  0  0
 8  2      0   8200  64276 117276    0    0     0 15956  356  521 88 12  0  0
 9  2      0   8200  64276 117276    0    0     0 16000  353  516 92  8  0  0

--------------090608080900060903030405--
