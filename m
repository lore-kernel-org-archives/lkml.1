Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZBIXuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZBIXuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZBIXuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:50:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57167 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZBIXuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:50:03 -0500
Date: Tue, 10 Feb 2009 00:49:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux@youmustbejoking.demon.co.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
Message-ID: <20090209234911.GB862@elte.hu>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Darren Salt <linux@youmustbejoking.demon.co.uk> wrote:

> I'm seeing various oopses with -rc4, where -rc3 is fine; config, dmesg
> (captured via netconsole) and decoded oops data attached ¹. The last few
> oopses were followed by a scrambled display and a hard lockup.
> 
> All oopses follow an otherwise successful suspend-to-RAM.

Various folks Cc:-ed. There's been a late, rather large ACPI merge, so
one post-rc3 suspect would be one of these commits:

f12b12a: Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
2d29c6a: Merge branches 'release', 'asus', 'bugzilla-12450', 'cpuidle', 'debug', 'ec', 'misc', 'printk' and 'processor' into release
370154b: ACPI: Kconfig text - Fix the ACPI_CONTAINER module name according to the real module name.
7695fb0: eeepc-laptop: fix oops when changing backlight brightness during eeepc-laptop init
386e4a8: ACPICA: Fix table entry truncation calculation
d96f94c: ACPI: Enable bit 11 in _PDC to advertise hw coord
db1461a: ACPI: struct device - replace bus_id with dev_name(), dev_set_name()
4d93915: ACPI: add missing KERN_* constants to printks
fc5a9f8: ACPI: dock: Don't eval _STA on every show_docked sysfs read
9e3a9d1: ACPI: disable ACPI cleanly when bad RSDP found
9fdd54f: ACPI: delete CPU_IDLE=n code
62663ea: ACPI: cpufreq: Remove deprecated /proc/acpi/processor/../performance proc entries
5ec5d38: ACPI: make some IO ports off-limits to AML
3e0676a: ACPICA: add debug dump of BIOS _OSI strings
f3b39f1: ACPI: proc_dir_entry 'video/VGA' already registered
0a3db1c: ACPI: Skip the first two elements in the _BCL package
31878dd: ACPI: remove BM_RLD access from idle entry path
a2b7b01: ACPI: remove locking from PM1x_STS register reads
2b25c9f: eeepc-laptop: use netlink interface
5740294: eeepc-laptop: Implement rfkill hotplugging in eeepc-laptop
c9ddf8f: eeepc-laptop: Check return values from rfkill_register
b5f6f26: eeepc-laptop: Add support for extended hotkeys
ed6f442: asus-laptop: fix label indentation
12d6f35: asus-laptop: update Kconfig for input layer
034ce90: asus-laptop: hotkeys via the generic input interface
2a7dc0d: asus-laptop: use generic netlink interface
1021e21: asus_acpi: Add R1F support
a9df80c: eeepc-laptop: split eeepc_backlight_exit()
2b190e7: panasonic-laptop: fix X[ ARRAY_SIZE(X) ]
4312495: ACPI: Fix crash on ASUS laptops
5d8b532: ACPI suspend: Fix compilation warnings in drivers/acpi/sleep.c
091d71e: PM: Fix compilation warning in kernel/power/main.c

> Also, I see that Fn-Fx don't seem to be reported via /proc/acpi/events any
> more, or at least I'm seeing no evidence of them via acpi_listen (and, not
> coincidentally, I can't adjust the volume etc. via eeepc-acpi-scripts).
> 
> The only other (significant) change is that I've installed X from Debian
> experimental, though -rc3 and 2.6.28.* seem fine with this. (Oh, and I can
> get UXA to cause OOM quite trivially... several Iceweasel tabs is enough.)
> 
> 
> ¹ Yes, I decided not to include symbol names in the running kernel...
> 
> -- 
> | Darren Salt    | linux or ds at              | nr. Ashington, | Toon
> | RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
> | + Use more efficient products. Use less.          BE MORE ENERGY EFFICIENT.
> 
> I'll have what the bloke on the floor is having...
> 


> ksymoops 2.4.11 on i686 2.6.29-rc4-eee901.  Options used
>      -V (default)
>      -k /proc/ksyms (default)
>      -l /proc/modules (default)
>      -o /lib/modules/2.6.29-rc4-eee901/ (default)
>      -m /boot/System.map-2.6.29-rc4-eee901 (default)
> 
> Warning: You did not tell me where to find symbol information.  I will
> assume that the log matches the kernel and modules that are running
> right now and I'll use the default options above for symbol resolution.
> If the current kernel and/or modules do not match the log, you can get
> more accurate output by telling me the kernel version and where to find
> map, modules, ksyms etc.  ksymoops -h explains the options.
> 
> Error (regular_file): read_ksyms stat /proc/ksyms failed
> No modules in ksyms, skipping objects
> No ksyms, skipping lsmod
> CPU 1 is now offline
> WARNING: at fs/sysfs/group.c:138 ()
> Pid: 330, comm: pciehpd Not tainted 2.6.29-rc4-eee901 #2
> Call Trace:
>  [<c011fab7>] 0xc011fab7
>  [<c032ca9d>] 0xc032ca9d
>  [<f81760d5>] 0xf81760d5
>  [<c01f112c>] 0xc01f112c
>  [<c0118940>] 0xc0118940
>  [<c011fc82>] 0xc011fc82
>  [<c016b8aa>] 0xc016b8aa
>  [<c0190b6b>] 0xc0190b6b
>  [<c016b9a8>] 0xc016b9a8
>  [<c016b738>] 0xc016b738
>  [<c019102a>] 0xc019102a
>  [<c0191faa>] 0xc0191faa
>  [<c025a8d4>] 0xc025a8d4
>  [<c025a9c9>] 0xc025a9c9
>  [<c01fae3c>] 0xc01fae3c
>  [<c01faf00>] 0xc01faf00
>  [<c0205ca4>] 0xc0205ca4
>  [<c0204a68>] 0xc0204a68
>  [<c0204eb3>] 0xc0204eb3
>  [<c0204e2d>] 0xc0204e2d
>  [<c012bd8f>] 0xc012bd8f
>  [<c012c51d>] 0xc012c51d
>  [<c012c5d1>] 0xc012c5d1
>  [<c012e9ac>] 0xc012e9ac
>  [<c012c51d>] 0xc012c51d
>  [<c012e8de>] 0xc012e8de
>  [<c012e8a6>] 0xc012e8a6
>  [<c010349b>] 0xc010349b
> BUG: unable to handle kernel NULL pointer dereference at 00000010
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT SMP 
> Pid: 330, comm: pciehpd Tainted: G        W  (2.6.29-rc4-eee901 #2) 901
> EIP: 0060:[<c03ccef7>] EFLAGS: 00010246 CPU: 0
> Using defaults from ksymoops -t elf32-i386 -a i386
> EAX: 00000000 EBX: 00000001 ECX: 00000046 EDX: 00000001
> ESI: f17dd470 EDI: f70f7c5c EBP: 00000000 ESP: f7339f00
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>  f17dd45c 00000000 f70f7c5c c025a9c9 f7060b40 f7311a80ff 83 c0 89 83 cf db 74 19 f6 06 01 74 11 6a 00 ---[ end trace 449537779ba90603 ]---
> Warning (Oops_read): Code line not seen, dumping what data is available
> 
> 
> Trace; c011fab7 <warn_slowpath+7d/94>
> Trace; c032ca9d <__alloc_skb+4b/103>
> Trace; f81760d5 <END_OF_CODE+37c160d5/????>
> Trace; c01f112c <cpumask_next_and+23/33>
> Trace; c0118940 <find_busiest_group+242/725>
> Trace; c011fc82 <__call_console_drivers+51/5d>
> Trace; c016b8aa <find_inode+1b/56>
> Trace; c0190b6b <sysfs_ilookup_test+0/d>
> Trace; c016b9a8 <ifind+3a/74>
> Trace; c016b738 <iput+21/4a>
> Trace; c019102a <sysfs_addrm_finish+4a/1ae>
> Trace; c0191faa <sysfs_remove_group+34/8d>
> Trace; c025a8d4 <device_del+32/11f>
> Trace; c025a9c9 <device_unregister+8/10>
> Trace; c01fae3c <pci_stop_dev+20/3a>
> Trace; c01faf00 <pci_remove_bus_device+27/88>
> Trace; c0205ca4 <pciehp_unconfigure_device+108/180>
> Trace; c0204a68 <pciehp_disable_slot+12d/1d6>
> Trace; c0204eb3 <pciehp_power_thread+86/cd>
> Trace; c0204e2d <pciehp_power_thread+0/cd>
> Trace; c012bd8f <run_workqueue+71/f1>
> Trace; c012c51d <worker_thread+0/bf>
> Trace; c012c5d1 <worker_thread+b4/bf>
> Trace; c012e9ac <autoremove_wake_function+0/2b>
> Trace; c012c51d <worker_thread+0/bf>
> Trace; c012e8de <kthread+38/5e>
> Trace; c012e8a6 <kthread+0/5e>
> Trace; c010349b <kernel_thread_helper+7/10>
> 
> >>EIP; c03ccef7 <klist_put+f/59>   <=====
> 
> BUG: unable to handle kernel paging request at 7a9d5f5c
> *pde = 00000000 
> Oops: 0000 [#2] PREEMPT SMP 
> Pid: 4094, comm: bash Tainted: G      D W  (2.6.29-rc4-eee901 #2) 901
> EIP: 0060:[<c015bb0a>] EFLAGS: 00010006 CPU: 1
> EAX: 00000000 EBX: c04c7d90 ECX: 7a9d5f5c EDX: c180ff6c
> ESI: 00000282 EDI: c04c7d90 EBP: 00000040 ESP: ee9f1e38
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  7a9d5f5c 000080d0 f173f7c0 c194c488 7ac532a8 fe280a2e c194c488 c0194004
>  f173f7c0 c194c488 f6e64498 0000003e f6e02458 c019aaa0 c194c488 00000000
>  ee949600 c194cff8 00000000 ee949600 ee949600 f6e02458 00000000 c019ab55
> Call Trace:
>  [<c0194004>] 0xc0194004
>  [<c019aaa0>] 0xc019aaa0
>  [<c019ab55>] 0xc019ab55
>  [<c01405ce>] 0xc01405ce
>  [<c0102cf1>] 0xc0102cf1
> 56 BUG: unable to handle kernel paging request at 7a9d5f5c
> *pde = 00000000 
> Oops: 0000 [#3] PREEMPT SMP 
> Pid: 3147, comm: xfce4-systemloa Tainted: G      D W  (2.6.29-rc4-eee901 #2) 901
> EIP: 0060:[<c015b4e5>] EFLAGS: 00010006 CPU: 1
> EAX: 00000000 EBX: 00000292 ECX: 7a9d5f5c EDX: c180ff6c
> ESI: 00000040 EDI: c018d53c EBP: c04c7d90 ESP: f16ebe34
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  7a9d5f5c 000000d0 f702c00a ee949300 f73e35e0 c018d53c 00000000 c017059b
>  00000000 f73e35e0 fffffff4 c018d53c ee949300 c0170678 00000000 f7029000
>  fffffff4 00001000 ee949300 c018d51e f173f2a0 f70e9680 c018d4d0 f70e96cc
> Call Trace:
>  [<c018d53c>] 0xc018d53c
>  [<c017059b>] 0xc017059b
>  [<c018d53c>] 0xc018d53c
>  [<c0170678>] 0xc0170678
>  [<c018d51e>] 0xc018d51e
>  [<c018d4d0>] 0xc018d4d0
>  [<c01887b8>] 0xc01887b8
>  [<c017006d>] 0xc017006d
>  [<c012e9ac>] 0xc012e9ac
>  [<c0102cf1>] 0xc0102cf1
> BUG: unable to handle kernel paging request at 7a9d5f5c
> *pde = 00000000 
> Oops: 0000 [#4] PREEMPT SMP 
> Pid: 3137, comm: xfce4-panel Tainted: G      D W  (2.6.29-rc4-eee901 #2) 901
> EIP: 0060:[<c015b4e5>] EFLAGS: 00010006 CPU: 1
> EAX: 00000000 EBX: 00000296 ECX: 7a9d5f5c EDX: c180ff6c
> ESI: 00000040 EDI: ee939f7c EBP: c04c7d90 ESP: f1653ecc
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  7a9d5f5c 000000d0 00000000 ee814440 00000000 ee939f7c 01200011 c012c900
>  ee938380 eea4fff8 c048d53c ee814440 c0101a87 01200011 ee814440 00000000
>  ee939f7c ee814440 00000000 ee939f7c 01200011 c011e9cb f1653fb8 bf9e8d30
> Call Trace:
>  [<c012c900>] 0xc012c900
>  [<c0101a87>] 0xc0101a87
>  [<c011e9cb>] 0xc011e9cb
>  [<c011f085>] 0xc011f085
> eb BUG: unable to handle kernel paging request at 7a9d5f5c
> *pde = 00000000 
> Oops: 0000 [#5] PREEMPT SMP 
> Pid: 2942, comm: Xorg Tainted: G      D W  (2.6.29-rc4-eee901 #2) 901
> EIP: 0060:[<c015bb0a>] EFLAGS: 00213006 CPU: 1
> EAX: 00000000 EBX: c04c7d90 ECX: 7a9d5f5c EDX: c180ff6c
> ESI: 00203282 EDI: c04c7d90 EBP: 00000040 ESP: f68adef4
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  7a9d5f5c 000000d0 00203286 00000000 fffffff4 40286454 f6a86800 f81ea6f4
>  f6b2d420 f8348c59 f83583e4 f6950080 bfbc1eb4 40286454 c0167680 bfbc1eb4
>  f6950080 f6f1e7f8 08a84b40 f68ac000 c0167bb4 0000000d 00203082 f68adf9c
> Call Trace:
>  [<f81ea6f4>] 0xf81ea6f4
>  [<f8348c59>] 0xf8348c59
>  [<c0167680>] 0xc0167680
>  [<c0167bb4>] 0xc0167bb4
>  [<c0122ac3>] 0xc0122ac3
>  [<c0122c59>] 0xc0122c59
> f4 BUG: unable to handle kernel paging request at 7a9d5f5c
> *pde = 00000000 
> Oops: 0000 [#6] PREEMPT SMP 
> Pid: 1219, comm: udevd Tainted: G      D W  (2.6.29-rc4-eee901 #2) 901
> EIP: 0060:[<c015b4e5>] EFLAGS: 00010006 CPU: 1
> EAX: 00000000 EBX: 00000292 ECX: 7a9d5f5c EDX: c180ff6c
> ESI: 00000040 EDI: c018d53c EBP: c04c7d90 ESP: f68fbe34
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  7a9d5f5c 000000d0 f708c00a ee949c80 f73e3720 c018d53c 00000000 c017059b
>  f6c12964 f73e3720 fffffff4 c018d53c ee949c80 c0170678 00000000 f708e000
>  fffffff4 00001000 ee949c80 c018d51e f173fa20 f70e9680 c018d4d0 f70e96cc
> Call Trace:
>  [<c018d53c>] 0xc018d53c
>  [<c017059b>] 0xc017059b
>  [<c018d53c>] 0xc018d53c
>  [<c0170678>] 0xc0170678
> Warning (Oops_read): Code line not seen, dumping what data is available
> 
> 
> >>EIP; c015bb0a <__kmalloc+83/c0>   <=====
> 
> >>EBX; c04c7d90 <kmalloc_caches+210/480>
> >>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>
> >>EDI; c04c7d90 <kmalloc_caches+210/480>
> 
> Trace; c0194004 <ext3_htree_store_dirent+26/de>
> Trace; c019aaa0 <htree_dirblock_to_tree+d6/11b>
> Trace; c019ab55 <ext3_htree_fill_tree+70/1cb>
> Trace; c01405ce <find_lock_page+10/43>
> Trace; c0102cf1 <sysenter_do_call+12/25>
> 
> >>EIP; c015b4e5 <kmem_cache_alloc+48/83>   <=====
> 
> >>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>
> >>EDI; c018d53c <show_stat+0/680>
> >>EBP; c04c7d90 <kmalloc_caches+210/480>
> 
> Trace; c018d53c <show_stat+0/680>
> Trace; c017059b <seq_open+23/6d>
> Trace; c018d53c <show_stat+0/680>
> Trace; c0170678 <single_open+48/68>
> Trace; c018d51e <stat_open+4e/6c>
> Trace; c018d4d0 <stat_open+0/6c>
> Trace; c01887b8 <proc_reg_open+89/ed>
> Trace; c017006d <single_release+0/1b>
> Trace; c012e9ac <autoremove_wake_function+0/2b>
> Trace; c0102cf1 <sysenter_do_call+12/25>
> 
> >>EIP; c015b4e5 <kmem_cache_alloc+48/83>   <=====
> 
> >>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>
> >>EBP; c04c7d90 <kmalloc_caches+210/480>
> 
> Trace; c012c900 <alloc_pid+18/2b6>
> Trace; c0101a87 <copy_thread+2f/f3>
> Trace; c011e9cb <copy_process+917/e42>
> Trace; c011f085 <do_fork+11a/268>
> 
> >>EIP; c015bb0a <__kmalloc+83/c0>   <=====
> 
> >>EBX; c04c7d90 <kmalloc_caches+210/480>
> >>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>
> >>ESI; 00203282 <phys_startup_32+103282/c0000000>
> >>EDI; c04c7d90 <kmalloc_caches+210/480>
> 
> Trace; f81ea6f4 <END_OF_CODE+37c8a6f4/????>
> Trace; f8348c59 <END_OF_CODE+37de8c59/????>
> Trace; c0167680 <vfs_ioctl+47/5d>
> Trace; c0167bb4 <do_vfs_ioctl+446/47c>
> Trace; c0122ac3 <do_setitimer+157/2a9>
> Trace; c0122c59 <sys_setitimer+44/71>
> 
> >>EIP; c015b4e5 <kmem_cache_alloc+48/83>   <=====
> 
> >>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>
> >>EDI; c018d53c <show_stat+0/680>
> >>EBP; c04c7d90 <kmalloc_caches+210/480>
> 
> Trace; c018d53c <show_stat+0/680>
> Trace; c017059b <seq_open+23/6d>
> Trace; c018d53c <show_stat+0/680>
> Trace; c0170678 <single_open+48/68>
> 
> 
> 3 warnings and 1 error issued.  Results may not be reliable.


