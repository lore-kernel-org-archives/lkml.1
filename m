Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbYHBXZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYHBXZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYHBXZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:25:33 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:60921 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYHBXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:25:24 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: 2.6.27-rc1-mm1: rmmod ide-cd_mod oops
Date: Sun, 3 Aug 2008 01:25:04 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080731000354.24b55d5b.akpm@linux-foundation.org> <200808021123.57952.m.kozlowski@tuxland.pl> <200808021815.57573.bzolnier@gmail.com>
In-Reply-To: <200808021815.57573.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QzOlIVAAu9bmjHi"
Message-Id: <200808030125.04737.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_QzOlIVAAu9bmjHi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
 
> > 	rmmod on ide-cd_mod causes this oops:
> > 
> > BUG: unable to handle kernel paging request at 83535683
> > IP: [<c0246ffa>] ide_device_put+0xc/0x33
> > *pde = 00000000 
> > Oops: 0000 [#1] PREEMPT 
> > last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/resource
> > Modules linked in: radeon drm nfsd lockd sunrpc exportfs pcmcia uhci_hcd ehci_hcd usbcore snd_ali5451 yenta_socket pcspkr snd_ac97_codec ac97_bus rsrc_nonstatic snd_pcm snd_timer ati_agp agpgart snd soundcore snd_page_alloc ide_cd_mod(-) cdrom 8139too psmouse sony_laptop backlight floppy rtc
> > 
> > Pid: 3890, comm: rmmod Not tainted (2.6.27-rc1-mm1 #2)
> > EIP: 0060:[<c0246ffa>] EFLAGS: 00010286 CPU: 0
> > EIP is at ide_device_put+0xc/0x33
> > EAX: 83535657 EBX: dc927a00 ECX: 00000003 EDX: 00000001
> > ESI: dec34e34 EDI: dec34e34 EBP: d9f46ee0 ESP: d9f46edc
> >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process rmmod (pid: 3890, ti=d9f46000 task=dd88e780 task.ti=d9f46000)
> > Stack: dc927c00 d9f46eec dec2e202 dc927c00 d9f46ef8 dec2e225 dd9138dc d9f46f00 
> >        c02469e0 d9f46f10 c024156f dd9138dc dd9139f4 d9f46f24 c024162c 00000880 
> >        dec34e34 c0397dc0 d9f46f38 c0240a33 00000880 dec34e34 00000000 d9f46f48 
> > Call Trace:
> >  [<dec2e202>] ? ide_cd_put+0x26/0x33 [ide_cd_mod]
> >  [<dec2e225>] ? ide_cd_remove+0x16/0x19 [ide_cd_mod]
> >  [<c02469e0>] ? generic_ide_remove+0x1a/0x1e
> >  [<c024156f>] ? __device_release_driver+0x59/0x7f
> >  [<c024162c>] ? driver_detach+0x97/0x99
> >  [<c0240a33>] ? bus_remove_driver+0x6f/0x8b
> >  [<c02419f1>] ? driver_unregister+0x2f/0x33
> >  [<dec31331>] ? ide_cdrom_exit+0xd/0xf [ide_cd_mod]
> >  [<c014265a>] ? sys_delete_module+0x10d/0x1e2
> >  [<c015fedc>] ? do_munmap+0x1d7/0x234
> >  [<c01e8684>] ? trace_hardirqs_on_thunk+0xc/0x10
> >  [<c0103015>] ? sysenter_do_call+0x12/0x35
> >  =======================
> > Code: ff ff 89 44 24 08 c7 44 24 04 a7 de 35 c0 89 34 24 e8 cb ce f9 ff 31 c0 83 c4 0c 5b 5e 5d c3 55 89 e5 53 89 c3 8b 40 24 8b 40 10 <8b> 40 2c 85 c0 74 12 8b 80 44 01 00 00 8b 40 08 85 c0 74 05 e8 
> > EIP: [<c0246ffa>] ide_device_put+0xc/0x33 SS:ESP 0068:d9f46edc
> > ---[ end trace a2eed48430d87636 ]---
> > 
> > this is easily reporoducible, more investigation points here:
> 
> Unfortunately, I'm unable to reproduce it here with 2.6.27-rc1-mm1.
> 
> Which IDE host driver is it happening with?  Could you send me your .config?

It's ALI M15x3 chipset. .config is attached.

# lspci 
00:00.0 Host bridge: ATI Technologies Inc RS200/RS200M AGP Bridge [IGP 340M] (rev 02)
00:01.0 PCI bridge: ATI Technologies Inc PCI Bridge [IGP 340M]
00:03.0 Modem: ALi Corporation M5457 AC'97 Modem Controller
00:04.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link Controller Audio Device (rev 02)
00:06.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
00:07.0 ISA bridge: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin IV/V/V+]
00:0a.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev aa)
00:0a.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev aa)
00:0a.2 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 02)
00:0c.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 50)
00:0c.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 50)
00:0c.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 51)
00:0f.0 IDE interface: ALi Corporation M5229 IDE (rev c4)
00:12.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon IGP 330M/340M/350M


> > (gdb) l *ide_device_put+0xc
> > 0xc0246ffa is in ide_device_put (/home/mako/linux/lkt/sources/linux-2.6.27-rc1-mm1/drivers/ide/ide.c:717).
> > 712      * the underlying LLDD module.
> > 713      */
> > 714     void ide_device_put(ide_drive_t *drive)
> > 715     {
> > 716     #ifdef CONFIG_MODULE_UNLOAD
> > 717             struct device *host_dev = drive->hwif->host->dev[0]; <--------------------------
> 
> Could you please check whether it is drive->hwif or hwif->host exploding?
> [ hmm, both should never be changed after host driver initialization ]

I saw it exploding in two ways. I added simple debugging stuff:

--- linux-2.6.27-rc1-mm1/drivers/ide/ide.c      2008-08-02 11:42:05.000000000 +0200
+++ linux-2.6.27-rc1-mm1-dirty/drivers/ide/ide.c        2008-08-02 23:26:52.000000000 +0200
@@ -714,6 +714,21 @@ EXPORT_SYMBOL_GPL(ide_device_get);
 void ide_device_put(ide_drive_t *drive)
 {
 #ifdef CONFIG_MODULE_UNLOAD
+       void *tmp;
+
+       tmp = drive;
+       printk("drive: 0x%p\n", tmp);
+       tmp = drive->hwif;
+       printk("drive->hwif: 0x%p\n", tmp);
+       tmp = drive->hwif->host;
+       printk("drive->hwif->host: 0x%p\n", tmp);
+       tmp = drive->hwif->host->dev;
+       printk("drive->hwif->host->dev: 0x%p\n", tmp);
+       tmp = drive->hwif->host->dev[0];
+       printk("drive->hwif->host->dev[0]: 0x%p\n", tmp);
+       tmp = drive->hwif->host->dev[0]->driver;
+       printk("drive->hwif->host->dev[0]->driver: 0x%p\n", tmp);
+
        struct device *host_dev = drive->hwif->host->dev[0];
        struct module *module = host_dev ? host_dev->driver->owner : NULL;


1) on drive->hwif (drive is null)

drive: 0x00000000
BUG: unable to handle kernel NULL pointer dereference at 00000024
IP: [<c0247007>] ide_device_put+0x19/0xc3
*pde = 00000000 
Oops: 0000 [#1] PREEMPT 
last sysfs file: /sys/class/power_supply/BAT1/energy_full
Modules linked in: nfsd lockd sunrpc exportfs orinoco_cs orinoco hermes pcmcia ehci_hcd uhci_hcd usbcore yenta_socket snd_ali5451 snd_ac97_codec ac97_bus snd_pcm rsrc_nonstatic ati_agp snd_timer agpgart psmouse pcspkr rtc ide_cd_mod(-) snd soundcore snd_page_alloc cdrom 8139too sony_laptop backlight floppy

Pid: 4477, comm: rmmod Not tainted (2.6.27-rc1-mm1-dirty #7)
EIP: 0060:[<c0247007>] EFLAGS: 00010286 CPU: 0
EIP is at ide_device_put+0x19/0xc3
EAX: 00000015 EBX: 00000000 ECX: ddaac000 EDX: 00000000
ESI: dec3de34 EDI: dec3de34 EBP: ddaacee0 ESP: ddaaced4
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rmmod (pid: 4477, ti=ddaac000 task=dd901700 task.ti=ddaac000)
Stack: c035e577 00000000 dd83ae00 ddaaceec dec37202 dd83ae00 ddaacef8 dec37225 
       dd9138dc ddaacf00 c02469e0 ddaacf10 c024156f dd9138dc dd9139f4 ddaacf24 
       c024162c 00000880 dec3de34 c0398dc0 ddaacf38 c0240a33 00000880 dec3de34 
Call Trace:
 [<dec37202>] ? ide_cd_put+0x26/0x33 [ide_cd_mod]
 [<dec37225>] ? ide_cd_remove+0x16/0x19 [ide_cd_mod]
 [<c02469e0>] ? generic_ide_remove+0x1a/0x1e
 [<c024156f>] ? __device_release_driver+0x59/0x7f
 [<c024162c>] ? driver_detach+0x97/0x99
 [<c0240a33>] ? bus_remove_driver+0x6f/0x8b
 [<c02419f1>] ? driver_unregister+0x2f/0x33
 [<dec3a331>] ? ide_cdrom_exit+0xd/0xf [ide_cd_mod]
 [<c014265a>] ? sys_delete_module+0x10d/0x1e2
 [<c015fedc>] ? do_munmap+0x1d7/0x234
 [<c01e8684>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0103015>] ? sysenter_do_call+0x12/0x35
 =======================
Code: c0 89 34 24 e8 cb ce f9 ff 31 c0 83 c4 0c 5b 5e 5d c3 55 89 e5 53 83 ec 08 89 c3 89 44 24 04 c7 04 24 77 e5 35 c0 e8 25 6c ed ff <8b> 43 24 89 44 24 04 c7 04 24 84 e5 35 c0 e8 12 6c ed ff 8b 43 
EIP: [<c0247007>] ide_device_put+0x19/0xc3 SS:ESP 0068:ddaaced4
---[ end trace b3172ff03a3b3a53 ]---

(gdb) l *ide_device_put+0x19
0xc0247007 is in ide_device_put (/home/mako/linux/lkt/sources/linux-2.6.27-rc1-mm1-dirty/drivers/ide/ide.c:722).
717             void *tmp;
718     
719             tmp = drive;
720             printk("drive: 0x%p\n", tmp);
721             tmp = drive->hwif;
722             printk("drive->hwif: 0x%p\n", tmp); <----
723             tmp = drive->hwif->host;
724             printk("drive->hwif->host: 0x%p\n", tmp);
725             tmp = drive->hwif->host->dev;
726             printk("drive->hwif->host->dev: 0x%p\n", tmp);



2) on drive->hwif->host->dev[0] (->dev is bogus?)

drive: 0xdd97c200
drive->hwif: 0xc023f3b8
drive->hwif->host: 0x83535657
drive->hwif->host->dev: 0x83535683
BUG: unable to handle kernel paging request at 83535683
IP: [<c024704f>] ide_device_put+0x61/0xc3
*pde = 00000000 
Oops: 0000 [#1] PREEMPT 
last sysfs file: /sys/class/power_supply/BAT1/energy_full
Modules linked in: radeon drm nfsd lockd sunrpc exportfs orinoco_cs orinoco hermes pcmcia uhci_hcd ehci_hcd snd_ali5451 usbcore yenta_socket snd_ac97_codec ac97_bus snd_pcm snd_timer rsrc_nonstatic pcspkr ati_agp ide_cd_mod(-) snd psmouse sony_laptop agpgart floppy cdrom soundcore snd_page_alloc backlight rtc 8139too

Pid: 4596, comm: rmmod Not tainted (2.6.27-rc1-mm1-dirty #7)
EIP: 0060:[<c024704f>] EFLAGS: 00010286 CPU: 0
EIP is at ide_device_put+0x61/0xc3
EAX: 83535657 EBX: dd97c200 ECX: d9e68000 EDX: 00000000
ESI: dec53e34 EDI: dec53e34 EBP: d9e68ee0 ESP: d9e68ed4
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rmmod (pid: 4596, ti=d9e68000 task=dd837300 task.ti=d9e68000)
Stack: c035e5b0 83535683 dd97c600 d9e68eec dec4d202 dd97c600 d9e68ef8 dec4d225 
       dd9138dc d9e68f00 c02469e0 d9e68f10 c024156f dd9138dc dd9139f4 d9e68f24 
       c024162c 00000880 dec53e34 c0398dc0 d9e68f38 c0240a33 00000880 dec53e34 
Call Trace:
 [<dec4d202>] ? ide_cd_put+0x26/0x33 [ide_cd_mod]
 [<dec4d225>] ? ide_cd_remove+0x16/0x19 [ide_cd_mod]
 [<c02469e0>] ? generic_ide_remove+0x1a/0x1e
 [<c024156f>] ? __device_release_driver+0x59/0x7f
 [<c024162c>] ? driver_detach+0x97/0x99
 [<c0240a33>] ? bus_remove_driver+0x6f/0x8b
 [<c02419f1>] ? driver_unregister+0x2f/0x33
 [<dec50331>] ? ide_cdrom_exit+0xd/0xf [ide_cd_mod]
 [<c014265a>] ? sys_delete_module+0x10d/0x1e2
 [<c015fedc>] ? do_munmap+0x1d7/0x234
 [<c01e8684>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0103015>] ? sysenter_do_call+0x12/0x35
 =======================
Code: c7 04 24 97 e5 35 c0 e8 fc 6b ed ff 8b 43 24 8b 40 10 83 c0 2c 89 44 24 04 c7 04 24 b0 e5 35 c0 e8 e3 6b ed ff 8b 43 24 8b 40 10 <8b> 40 2c 89 44 24 04 c7 04 24 70 2a 35 c0 e8 ca 6b ed ff 8b 43 
EIP: [<c024704f>] ide_device_put+0x61/0xc3 SS:ESP 0068:d9e68ed4
---[ end trace ad4ca87090e240bd ]---

(gdb) l *ide_device_put+0x61
0xc024704f is in ide_device_put (/home/mako/linux/lkt/sources/linux-2.6.27-rc1-mm1-dirty/drivers/ide/ide.c:728).
723             tmp = drive->hwif->host;
724             printk("drive->hwif->host: 0x%p\n", tmp);
725             tmp = drive->hwif->host->dev;
726             printk("drive->hwif->host->dev: 0x%p\n", tmp);
727             tmp = drive->hwif->host->dev[0];
728             printk("drive->hwif->host->dev[0]: 0x%p\n", tmp); <----
729             tmp = drive->hwif->host->dev[0]->driver;
730             printk("drive->hwif->host->dev[0]->driver: 0x%p\n", tmp);
731     
732             struct device *host_dev = drive->hwif->host->dev[0];


Hope that helps.

	Mariusz



> 
> > 718             struct module *module = host_dev ? host_dev->driver->owner : NULL;
> > 719     
> > 720             if (module)
> > 721                     module_put(module);
> > 
> > 	Mariusz
> 



--Boundary-00=_QzOlIVAAu9bmjHi
Content-Type: text/plain;
  charset="iso-8859-1";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27-rc1-mm1
# Sat Aug  2 10:25:20 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=19
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_IGMP=y
CONFIG_FILE_LOCKING=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_DMA_ATTRS is not set
# CONFIG_USE_GENERIC_SMP_HELPERS is not set
# CONFIG_HAVE_CLK is not set

#
# GCOV profiling
#
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_CLASSIC_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=y
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=6
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_GET_USER_PAGES_FAST=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION="/dev/sda2"
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=y
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_LNE390 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_NE3210 is not set
# CONFIG_ES3210 is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
CONFIG_HERMES=m
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCI_HERMES is not set
CONFIG_PCMCIA_HERMES=m
# CONFIG_PCMCIA_SPECTRUM is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=m
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=m
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=m
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_RTCTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
# CONFIG_SND_ISA is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_GOTEMP is not set
# CONFIG_USB_GADGET is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_REISER4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=1250
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m

#
# Layered filesystems
#
# CONFIG_UNION_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp1250"
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-2"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_SYNCHRO_TEST is not set
# CONFIG_PROFILE_LIKELY is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_KERNEL_TESTS is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_KMEMCHECK is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_INTEGRITY is not set
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_PRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_QzOlIVAAu9bmjHi
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.27-rc1-mm1-dirty (mako@flyhigh) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #7 PREEMPT Sat Aug 2 23:39:25 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001df70000 (usable)
 BIOS-e820: 000000001df70000 - 000000001df7c000 (ACPI data)
 BIOS-e820: 000000001df7c000 - 000000001df80000 (ACPI NVS)
 BIOS-e820: 000000001df80000 - 000000001e000000 (reserved)
 BIOS-e820: 000000002df80000 - 000000002e000000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
last_pfn = 0x1df70 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 1df70000 @ 7000-d000
DMI present.
ACPI: RSDP 000F6FE0, 0014 (r0 PTLTD )
ACPI: RSDT 1DF774D1, 002C (r1 SONY   K7        6040000  LTP        0)
ACPI: FACP 1DF7BF64, 0074 (r1 SONY   K7        6040000 PTL     F4240)
ACPI: DSDT 1DF774FD, 4A67 (r1  SONY  K7        6040000 MSFT  100000E)
ACPI: FACS 1DF7CFC0, 0040
ACPI: BOOT 1DF7BFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: DMI detected: Sony
479MB LOWMEM available.
  mapped low ram: 0 - 1df70000
  low ram: 00000000 - 1df70000
  bootmap 00001000 - 00004bf0
(6 early reservations) ==> bootmem [0000000000 - 001df70000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 00006c8110]    TEXT DATA BSS ==> [0000100000 - 00006c8110]
  #2 [00006c9000 - 00006cc000]    INIT_PG_TABLE ==> [00006c9000 - 00006cc000]
  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #4 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #5 [0000001000 - 0000005000]          BOOTMAP ==> [0000001000 - 0000005000]
sizeof(struct page) = 32
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001df70
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001df70
On node 0 totalpages: 122639
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 117713 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x8008
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
mapped APIC to ffffb000 (fee00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 2e000000:d1f80000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 121680
Kernel command line: root=/dev/hda3 vga=0x318 video=vesafb:mtrr lapic pci=routeirq rootflags=data=writeback
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
CPU 0 irqstacks, hard=c03f2000 soft=c03f1000
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC calibrated against PM_TIMER
Detected 2392.448 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1056 kB
 per task-struct memory footprint: 1920 bytes
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 479920k/490944k available (1798k kernel code, 10480k reserved, 910k data, 284k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
    vmalloc : 0xde770000 - 0xfffb7000   ( 536 MB)
    lowmem  : 0xc0000000 - 0xddf70000   ( 479 MB)
      .init : 0xc03a7000 - 0xc03ee000   ( 284 kB)
      .data : 0xc02c19cf - 0xc03a5570   ( 910 kB)
      .text : 0xc0100000 - 0xc02c19cf   (1798 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. <6>4784.89 BogoMIPS (lpj=23924480)
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
CPU: Intel(R) Pentium(R) 4 CPU 2.40GHz stepping 09
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080609
ACPI: setting ELCR to 0200 (from 0c00)
net_namespace: 352 bytes
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8a0, last bus=1
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:03.0: PME# supported from D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:04.0: supports D1
pci 0000:00:04.0: supports D2
pci 0000:00:04.0: PME# supported from D2 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:06.0: quirk: region 8000-803f claimed by ali7101 ACPI
pci 0000:00:06.0: quirk: region 8040-805f claimed by ali7101 SMB
pci 0000:00:0a.0: supports D1
pci 0000:00:0a.0: supports D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0a.1: supports D1
pci 0000:00:0a.1: supports D2
pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.1: PME# disabled
pci 0000:00:0a.2: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.2: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:0c.1: PME# disabled
pci 0000:00:0c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:0c.2: PME# disabled
pci 0000:00:12.0: supports D1
pci 0000:00:12.0: supports D2
pci 0000:00:12.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:00:12.0: PME# disabled
pci 0000:01:05.0: supports D1
pci 0000:01:05.0: supports D2
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PPB_._PRT]
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 *10 11)
ACPI: PCI Interrupt Link [LNK5] (IRQs 10) *11
ACPI: PCI Interrupt Link [LNK6] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNK7] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNK8] (IRQs 3 4 5 7 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
ACPI: PCI Interrupt Link [LNK6] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:00:03.0: PCI INT A -> Link[LNK6] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNK7] enabled at IRQ 11
pci 0000:00:04.0: PCI INT A -> Link[LNK7] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 11
pci 0000:00:0a.0: PCI INT A -> Link[LNK2] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
pci 0000:00:0a.1: PCI INT B -> Link[LNK4] -> GSI 10 (level, low) -> IRQ 10
ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 10
pci 0000:00:0a.2: PCI INT C -> Link[LNK5] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:0c.0: PCI INT A -> Link[LNK2] -> GSI 11 (level, low) -> IRQ 11
pci 0000:00:0c.1: PCI INT B -> Link[LNK4] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:0c.2: PCI INT C -> Link[LNK5] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:0f.0: can't derive routing for PCI INT A
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 11
pci 0000:00:12.0: PCI INT A -> Link[LNK1] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNK0] enabled at IRQ 10
pci 0000:01:05.0: PCI INT A -> Link[LNK0] -> GSI 10 (level, low) -> IRQ 10
system 00:05: ioport range 0x40b-0x40b has been reserved
system 00:05: ioport range 0x480-0x48f has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
system 00:05: ioport range 0x4d6-0x4d6 has been reserved
system 00:05: ioport range 0x8000-0x807f could not be reserved
system 00:05: ioport range 0xfe00-0xfe01 has been reserved
system 00:05: ioport range 0xfe10-0xfe11 has been reserved
system 00:06: iomem range 0x0-0x9ffff could not be reserved
system 00:06: iomem range 0xdc000-0xdffff could not be reserved
system 00:06: iomem range 0xe0000-0xfffff could not be reserved
system 00:06: iomem range 0x100000-0x1dffffff could not be reserved
system 00:06: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:06: iomem range 0xf0800000-0xf0800fff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xa000-0xafff
pci 0000:00:01.0:   MEM window: 0xf0500000-0xf05fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000f8000000-0x000000fbffffff
pci 0000:00:0a.0: CardBus bridge, secondary bus 0000:02
pci 0000:00:0a.0:   IO window: 0x001000-0x0010ff
pci 0000:00:0a.0:   IO window: 0x001400-0x0014ff
pci 0000:00:0a.0:   PREFETCH window: 0x30000000-0x33ffffff
pci 0000:00:0a.0:   MEM window: 0x34000000-0x37ffffff
pci 0000:00:0a.1: CardBus bridge, secondary bus 0000:06
pci 0000:00:0a.1:   IO window: 0x001800-0x0018ff
pci 0000:00:0a.1:   IO window: 0x001c00-0x001cff
pci 0000:00:0a.1:   PREFETCH window: 0x38000000-0x3bffffff
pci 0000:00:0a.1:   MEM window: 0x3c000000-0x3fffffff
pci 0000:00:0a.0: PCI INT A -> Link[LNK2] -> GSI 11 (level, low) -> IRQ 11
pci 0000:00:0a.1: PCI INT B -> Link[LNK4] -> GSI 10 (level, low) -> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x35 set to 0x1
Machine check exception polling timer started.
msgmni has been set to 937
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:07.0: Activating ISA DMA hang workarounds
pci 0000:01:05.0: Boot video device
vesafb: framebuffer at 0xf8000000, mapped to 0xde780000, using 4608k, total 32704k
vesafb: mode is 1024x768x24, linelength=3072, pages=13
vesafb: protected mode interface info at c000:51eb
vesafb: pmi: set display start = c00c527f, set palette = c00c52cb
vesafb: pmi: ports = a010 a016 a054 a038 a03c a05c a000 a004 a0b0 a0b2 a0b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [ACAD] (on-line)
Switched to high resolution mode on CPU 0
ACPI: EC: GPE storm detected, disabling EC GPE
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PBTN]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [LID]
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ01] (47 C)
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
alim15x3 0000:00:0f.0: IDE controller (0x10b9:0x5229 rev 0xc4)
ALI15x3_IDE 0000:00:0f.0: can't derive routing for PCI INT A
alim15x3 0000:00:0f.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x80c0-0x80c7
    ide1: BM-DMA at 0x80c8-0x80cf
Probing IDE interface ide0...
hda: HITACHI_DK23EA-30, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: QSI CD-RW/DVD-ROM SBW-241, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 58605120 sectors (30005 MB) w/2048KiB Cache, CHS=58140/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 17
Using IPI Shortcut mode
Marking TSC unstable due to TSC halts in idle
input: AT Translated Set 2 keyboard as /class/input/input3
kjournald starting.  Commit interval 5 seconds
EXT3-fs: hda3: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 1974903
ext3_orphan_cleanup: deleting unreferenced inode 1974850
EXT3-fs: hda3: 2 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 284k freed
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
8139too Fast Ethernet driver 0.9.28
8139too 0000:00:12.0: PCI INT A -> Link[LNK1] -> GSI 11 (level, low) -> IRQ 11
eth0: RealTek RTL8139 at 0xdec02c00, 08:00:46:a8:48:d3, IRQ 11
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
Real Time Clock Driver v1.12ac
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
Linux agpgart interface v0.103
sony-laptop: Sony Notebook Control Driver v0.6.
input: Sony Vaio Keys as /class/input/input4
input: Sony Vaio Jogdial as /class/input/input5
hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
agpgart-ati 0000:00:00.0: Ati IGP345M chipset
agpgart-ati 0000:00:00.0: AGP aperture is 64M @ 0xf4000000
input: PC Speaker as /class/input/input6
input: PS/2 Mouse as /class/input/input7
input: AlpsPS/2 ALPS GlidePoint as /class/input/input8
Yenta: CardBus bridge found at 0000:00:0a.0 [104d:8158]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Yenta: ISA IRQ mask 0x04a8, PCI irq 11
Socket status: 30000006
Yenta: CardBus bridge found at 0000:00:0a.1 [104d:8158]
USB Universal Host Controller Interface driver v3.0
Yenta: ISA IRQ mask 0x00a8, PCI irq 10
Socket status: 30000410
ALI 5451 0000:00:04.0: power state changed by ACPI to D0
ALI 5451 0000:00:04.0: PCI INT A -> Link[LNK7] -> GSI 11 (level, low) -> IRQ 11
pccard: PCMCIA card inserted into slot 1
AC'97 1 does not respond - RESET
AC'97 1 access is not valid [0xffffffff], removing mixer.
ali mixer 1 creating error.
uhci_hcd 0000:00:0c.0: PCI INT A -> Link[LNK2] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:0c.0: UHCI Host Controller
uhci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:0c.0: irq 11, io base 0x00008080
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:0c.2: PCI INT C -> Link[LNK5] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:0c.2: EHCI Host Controller
ehci_hcd 0000:00:0c.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:0c.2: irq 10, io mem 0xf0404800
ehci_hcd 0000:00:0c.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
uhci_hcd 0000:00:0c.1: PCI INT B -> Link[LNK4] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:0c.1: UHCI Host Controller
uhci_hcd 0000:00:0c.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:0c.1: irq 10, io base 0x000080a0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x378-0x37f 0x388-0x38f 0x3f8-0x3ff
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x378-0x37f 0x388-0x38f 0x3f8-0x3ff
cs: IO port probe 0xa00-0xaff: clean.
cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia: registering new device pcmcia1.0
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
eth1: Hardware identity 0001:0001:0004:0000
eth1: Station identity  001f:0001:0008:0048
eth1: Firmware determined as Lucent/Agere 8.72
eth1: Ad-hoc demo mode supported
eth1: IEEE standard IBSS ad-hoc mode supported
eth1: WEP supported, 104-bit key
eth1: MAC address 00:e0:63:82:2d:3f
eth1: Station name "HERMES I"
eth1: ready
eth1: orinoco_cs at 1.0, irq 3, io 0x0100-0x013f
EXT3 FS on hda3, internal journal
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
eth0: link down
eth1: New link status: Connected (0001)
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
hda: UDMA/100 mode selected
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
hdc: UDMA/33 mode selected
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913050
drive->hwif: 0xdd913000
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
pcmcia: Detected deprecated PCMCIA ioctl usage from process: cardmgr.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:05.0: PCI INT A -> Link[LNK0] -> GSI 10 (level, low) -> IRQ 10
[drm] Initialized radeon 1.29.0 20080528 on minor 0
drive: 0xdd913850
drive->hwif: 0xdd913800
drive->hwif->host: 0xdd92fb80
drive->hwif->host->dev: 0xdd92fbac
drive->hwif->host->dev[0]: 0xdd90f058
drive->hwif->host->dev[0]->driver: 0xc03991f4
agpgart-ati 0000:00:00.0: AGP 2.0 bridge
agpgart-ati 0000:00:00.0: putting AGP V2 device into 4x mode
pci 0000:01:05.0: putting AGP V2 device into 4x mode
[drm] Setting GART location based on old memory map
[drm] Loading R100 Microcode
[drm] writeback test succeeded in 1 usecs

--Boundary-00=_QzOlIVAAu9bmjHi--
