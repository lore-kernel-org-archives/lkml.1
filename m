Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0BFRBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:01:45 -0500
Received: from relay01.mx.bawue.net ([193.7.176.67]:57062 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab0BFRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:01:39 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Feb 2010 12:01:37 EST
Date: Sat, 6 Feb 2010 17:53:52 +0100
From: lkml@Think-Future.de
To: Linux Kernel-Liste <linux-kernel@vger.kernel.org>
Subject: PROBLEM: oops w/ bridge in 2.6.32.7
Message-ID: <20100206165351.GA9411@localhost>
Reply-To: lkml@Think-Future.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi, 


One line summary of the problem:    
With vboxdrv module loaded, tap0 device (no IP assigned), adding a bridge if w/ tap0 as single port: kernel ooops @brctl
command. See oops msg below.


A small shell script or example program which triggers the problem:
ifup br0 did it already. 
Goal was to use tap0 as bridge port and enable host to guest networking with virtualbox bridge networking.
virtualbox-ose              3.1.2-dfsg-1+b1
virtualbox-ose-source       3.1.2-dfsg-1


Keywords (i.e., modules, networking, kernel):
bridge, tap, uml, virtualbox, kernel is bigmem, 4gb, lxc enabled


/proc/version:
--------------
Linux version 2.6.32.7 (me@mypole) (gcc version 4.3.4 (Debian 4.3.4-6) ) #8 SMP PREEMPT Thu Feb 4 22:01:23 CET 2010


Output of Oops.. message:

Feb  6 16:40:27 localhost kernel: [463555.689331] BUG: unable to handle kernel NULL pointer dereference at 00000022
Feb  6 16:40:27 localhost kernel: [463555.689343] IP: [<c1134a3a>] sysfs_addrm_start+0x2a/0xb0
Feb  6 16:40:27 localhost kernel: [463555.689361] *pdpt = 0000000027de2001 *pde = 0000000000000000
Feb  6 16:40:27 localhost kernel: [463555.689371] Oops: 0000 [#1] PREEMPT SMP
Feb  6 16:40:27 localhost kernel: [463555.689379] last sysfs file: /sys/devices/virtual/net/br0/address
Feb  6 16:40:27 localhost kernel: [463555.689386] Modules linked in: bridge vboxdrv iwlagn iwlcore btusb stp tp_smapi thinkpad_ec uvcvideo nf_conntrack_netlink iptable_nat nf_nat iptable_mangle ipt_LOG xt_tcpudp xt_state xt_multiport iptable_filter ip_tables x_tables e1000e rtc_cmos [last unloaded: vboxdrv]
Feb  6 16:40:27 localhost kernel: [463555.689433]
Feb  6 16:40:27 localhost kernel: [463555.689440] Pid: 30082, comm: brctl Not tainted (2.6.32.7 #7) 7666B4G
Feb  6 16:40:27 localhost kernel: [463555.689447] EIP: 0060:[<c1134a3a>] EFLAGS: 00210282 CPU: 1
Feb  6 16:40:27 localhost kernel: [463555.689455] EIP is at sysfs_addrm_start+0x2a/0xb0
Feb  6 16:40:27 localhost kernel: [463555.689461] EAX: c19bf5c8 EBX: 00000002 ECX: 00000000 EDX: ee27a000
Feb  6 16:40:27 localhost kernel: [463555.689467] ESI: ee27be34 EDI: ee27be44 EBP: 00000002 ESP: ee27be20
Feb  6 16:40:27 localhost kernel: [463555.689473]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb  6 16:40:27 localhost kernel: [463555.689480] Process brctl (pid: 30082, ti=ee27a000 task=f016aa70 task.ti=ee27a000)
Feb  6 16:40:27 localhost kernel: [463555.689486] Stack:
Feb  6 16:40:27 localhost kernel: [463555.689489]  f02372bc f02372bc e8e81400 fffffff4 c1134f9f 00000002 00000000 00000000
Feb  6 16:40:27 localhost kernel: [463555.689504] <0> 00000000 fa2f6cda 00000002 f0237000 c1b5be80 c1135053 ee27be74 00000000
Feb  6 16:40:27 localhost kernel: [463555.689520] <0> c1136522 00000000 fa2f7380 00000000 f02372bc 00000010 00000000 f02372bc
Feb  6 16:40:27 localhost kernel: [463555.689537] Call Trace:
Feb  6 16:40:27 localhost kernel: [463555.689548]  [<c1134f9f>] ? create_dir+0x3f/0x90
Feb  6 16:40:27 localhost kernel: [463555.689558]  [<c1135053>] ? sysfs_create_subdir+0x13/0x20
Feb  6 16:40:27 localhost kernel: [463555.689568]  [<c1136522>] ? internal_create_group+0x52/0x180
Feb  6 16:40:27 localhost kernel: [463555.689582]  [<fa2f4973>] ? br_sysfs_addbr+0x23/0xf0 [bridge]
Feb  6 16:40:27 localhost kernel: [463555.689594]  [<fa2f0b2f>] ? br_add_bridge+0x18f/0x1a0 [bridge]
Feb  6 16:40:27 localhost kernel: [463555.689605]  [<fa2f1799>] ? br_ioctl_deviceless_stub+0x209/0x230 [bridge]
Feb  6 16:40:27 localhost kernel: [463555.689617]  [<fa2f1590>] ? br_ioctl_deviceless_stub+0x0/0x230 [bridge]
Feb  6 16:40:27 localhost kernel: [463555.689629]  [<c15b234d>] ? sock_ioctl+0xcd/0x260
Feb  6 16:40:27 localhost kernel: [463555.689638]  [<c15b2280>] ? sock_ioctl+0x0/0x260
Feb  6 16:40:27 localhost kernel: [463555.689647]  [<c10ec05b>] ? vfs_ioctl+0x2b/0x90
Feb  6 16:40:27 localhost kernel: [463555.689656]  [<c10ec553>] ? do_vfs_ioctl+0x3b3/0x5d0
Feb  6 16:40:27 localhost kernel: [463555.689664]  [<c15b3be0>] ? sys_socket+0x60/0x80
Feb  6 16:40:27 localhost kernel: [463555.689675]  [<c1024f1e>] ? do_page_fault+0x12e/0x300
Feb  6 16:40:27 localhost kernel: [463555.689684]  [<c10ec7d6>] ? sys_ioctl+0x66/0x70
Feb  6 16:40:27 localhost kernel: [463555.689692]  [<c1002ef0>] ? sysenter_do_call+0x12/0x22
Feb  6 16:40:27 localhost kernel: [463555.689698] Code: 00 83 ec 10 b9 04 00 00 00 89 5c 24 04 89 d3 89 74 24 08 89 c6 89 7c 24 0c 89 c7 31 c0 f3 ab b8 c8 f5 9b c1 89 16 e8 56 bc 5f 00 <8b> 53 20 b9 20 44 13 c1 a1 24 38 b3 c1 89 1c 24 e8 41 d5 fb ff
Feb  6 16:40:27 localhost kernel: [463555.689793] EIP: [<c1134a3a>] sysfs_addrm_start+0x2a/0xb0 SS:ESP 0068:ee27be20
Feb  6 16:40:27 localhost kernel: [463555.689807] CR2: 0000000000000022
Feb  6 16:40:27 localhost kernel: [463555.689814] ---[ end trace 9bf3a7ef2bd853ba ]---


/usr/src/linux/scripts/ver_linux:
---------------------------------
Linux mypole 2.6.32.7 #8 SMP PREEMPT Thu Feb 4 22:01:23 CET 2010 i686 GNU/Linux
 
Gnu C                  4.3.4
Gnu make               3.81
binutils               2.20
util-linux             2.16.2
mount                  support
module-init-tools      3.11
e2fsprogs              1.41.9
PPP                    2.4.4
Linux C Library        2.10.2
Dynamic linker (ldd)   2.10.2
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.1
Sh-utils               7.4
wireless-tools         30
Modules Loaded         vboxdrv ipt_LOG xt_tcpudp xt_state iptable_filter iptable_mangle iptable_nat nf_nat ip_tables x_tables tp_smapi thinkpad_ec iwlagn rtc_cmos e1000e iwlcore


/proc/cpuinfo:
--------------

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     L7700  @ 1.80GHz
stepping	: 11
cpu MHz		: 1800.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida tpr_shadow vnmi flexpriority
bogomips	: 3591.04
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     L7700  @ 1.80GHz
stepping	: 11
cpu MHz		: 1801.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida tpr_shadow vnmi flexpriority
bogomips	: 3590.82
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:



/proc/modules:
--------------

vboxdrv 140109 1 - Live 0xfd2be000
ipt_LOG 4487 5 - Live 0xf8ec8000
xt_tcpudp 1887 15 - Live 0xf8ebd000
xt_state 975 12 - Live 0xf8eb3000
iptable_filter 1898 1 - Live 0xf8e9f000
iptable_mangle 2425 0 - Live 0xf8e8c000
iptable_nat 3979 1 - Live 0xf8e79000
nf_nat 12235 1 iptable_nat, Live 0xf8e6c000
ip_tables 9034 3 iptable_filter,iptable_mangle,iptable_nat, Live 0xf8e5f000
x_tables 10572 5 ipt_LOG,xt_tcpudp,xt_state,iptable_nat,ip_tables, Live 0xf8e50000
tp_smapi 15816 0 - Live 0xf89e4000
thinkpad_ec 3782 1 tp_smapi, Live 0xf89d5000
iwlagn 71544 0 - Live 0xf88bd000
rtc_cmos 7728 0 - Live 0xf883c000
e1000e 115466 0 - Live 0xf880f000
iwlcore 83530 1 iwlagn, Live 0xf87c9000


/proc/ioports:
--------------

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
004f-004f : smapi
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00b2-00b2 : smapi
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
02f8-02ff : serial
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
03f8-03ff : serial
0800-080f : pnp 00:02
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-107f : pnp 00:02
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102f : ACPI GPE0_BLK
1180-11bf : 0000:00:1f.0
  1180-11bf : pnp 00:02
15e0-15ef : pnp 00:02
1600-161f : thinkpad_ec
164e-164f : pnp 00:02
1800-1807 : 0000:00:02.0
1840-185f : 0000:00:19.0
1860-187f : 0000:00:1a.0
  1860-187f : uhci_hcd
1880-189f : 0000:00:1a.1
  1880-189f : uhci_hcd
18a0-18bf : 0000:00:1d.0
  18a0-18bf : uhci_hcd
18c0-18df : 0000:00:1d.1
  18c0-18df : uhci_hcd
18e0-18ef : 0000:00:1f.1
  18e0-18ef : ata_piix
1c00-1c1f : 0000:00:1f.2
  1c00-1c1f : ahci
1c20-1c23 : 0000:00:1f.2
  1c20-1c23 : ahci
1c24-1c27 : 0000:00:1f.2
  1c24-1c27 : ahci
1c28-1c2f : 0000:00:1f.2
  1c28-1c2f : ahci
1c30-1c37 : 0000:00:1f.2
  1c30-1c37 : ahci
1c40-1c5f : 0000:00:1f.3
  1c40-1c5f : i801_smbus
2000-2fff : PCI Bus 0000:02
3000-3fff : PCI Bus 0000:03
4000-7fff : PCI Bus 0000:05
  4000-40ff : PCI CardBus 0000:06
  4400-44ff : PCI CardBus 0000:06


/proc/iomem:
------------

00000000-00001fff : System RAM
00002000-00005fff : reserved
00006000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cbfff : pnp 00:00
000cc000-000cffff : pnp 00:00
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-bf6affff : System RAM
  01000000-01747a89 : Kernel code
  01747a8a-01a5b6b7 : Kernel data
  01ada000-01b7d5a7 : Kernel bss
bf6b0000-bf6cbfff : ACPI Tables
bf6cc000-bf6fffff : ACPI Non-volatile Storage
bf700000-bfffffff : reserved
c0000000-c3ffffff : PCI CardBus 0000:06
c4000000-c4000fff : Intel Flush Page
d4000000-d7efffff : PCI Bus 0000:05
  d7efe400-d7efe4ff : 0000:05:00.2
    d7efe400-d7efe4ff : mmc0
  d7efe800-d7efefff : 0000:05:00.1
  d7eff000-d7efffff : 0000:05:00.0
    d7eff000-d7efffff : yenta_socket
d8000000-dbffffff : PCI Bus 0000:05
  d8000000-dbffffff : PCI CardBus 0000:06
e0000000-efffffff : 0000:00:02.0
f0000000-f3ffffff : PCI MMCONFIG 0 [00-3f]
  f0000000-f3ffffff : reserved
    f0000000-f3ffffff : pnp 00:02
f4000000-f5ffffff : PCI Bus 0000:02
f6000000-f7ffffff : PCI Bus 0000:03
  f7f00000-f7f01fff : 0000:03:00.0
    f7f00000-f7f01fff : iwlagn
f8000000-f80fffff : 0000:00:02.0
f8100000-f81fffff : 0000:00:02.1
f8200000-f821ffff : 0000:00:19.0
  f8200000-f821ffff : e1000e
f8220000-f8223fff : 0000:00:1b.0
  f8220000-f8223fff : ICH HD audio
f8225000-f8225fff : 0000:00:19.0
  f8225000-f8225fff : e1000e
f8426000-f84267ff : 0000:00:1f.2
  f8426000-f84267ff : ahci
f8426c00-f8426fff : 0000:00:1a.7
  f8426c00-f8426fff : ehci_hcd
f8427000-f84273ff : 0000:00:1d.7
  f8427000-f84273ff : ehci_hcd
f8427400-f84274ff : 0000:00:1f.3
f8500000-f85fffff : PCI Bus 0000:02
f8600000-f86fffff : PCI Bus 0000:03
fec00000-fec0ffff : reserved
  fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
  fed14000-fed17fff : pnp 00:02
  fed18000-fed18fff : pnp 00:02
  fed19000-fed19fff : pnp 00:02
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:02
  fed45000-fed4bfff : pnp 00:02
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
100000000-13bffffff : System RAM


lspci -vvv:
-----------

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
	Subsystem: Lenovo T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA controller])
	Subsystem: Lenovo T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 26
	Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=1M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
	Subsystem: Lenovo T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f8100000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>

00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network Connection (rev 03)
	Subsystem: Lenovo Device 20de
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 28
	Region 0: Memory at f8200000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f8225000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1840 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1860 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T60
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1880 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at f8426c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at f8220000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f4000000-f5ffffff
	Prefetchable memory behind bridge: 00000000f8500000-00000000f85fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f6000000-f7ffffff
	Prefetchable memory behind bridge: 00000000f8600000-00000000f86fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18a0 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 18c0 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f8427000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=08, sec-latency=32
	I/O behind bridge: 00004000-00007fff
	Memory behind bridge: d4000000-d7efffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000dbffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface Controller (rev 03)
	Subsystem: Lenovo T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin C routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 18e0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 27
	Region 0: I/O ports at 1c30 [size=8]
	Region 1: I/O ports at 1c24 [size=4]
	Region 2: I/O ports at 1c28 [size=8]
	Region 3: I/O ports at 1c20 [size=4]
	Region 4: I/O ports at 1c00 [size=32]
	Region 5: Memory at f8426000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f8427400 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1c40 [size=32]
	Kernel driver in use: i801_smbus

03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [Kedron] Network Connection (rev 61)
	Subsystem: Intel Corporation Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 29
	Region 0: Memory at f7f00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlagn

05:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
	Subsystem: Lenovo Device 20c6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d7eff000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=05, secondary=06, subordinate=07, sec-latency=176
	Memory window 0: d8000000-dbfff000 (prefetchable)
	Memory window 1: c0000000-c3fff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

05:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10 [OHCI])
	Subsystem: Lenovo Device 20c7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max)
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at d7efe800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>

05:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
	Subsystem: Lenovo Device 20c8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at d7efe400 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: sdhci-pci


/proc/cmdline:
--------------

root=/dev/sda1 ro selinux=0 quiet thinkpad_acpi.experimental=1 thinkpad_acpi.fan_control=1 fastboot i915.modeset=1 video=intelfb:off


/proc/interrupts:
-----------------

           CPU0       CPU1       
  0:     301541     304446   IO-APIC-edge      timer
  1:          4          4   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc0
  9:       4160       4240   IO-APIC-fasteoi   acpi
 12:         82         72   IO-APIC-edge      i8042
 14:          0          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:       7058       7346   IO-APIC-fasteoi   yenta, uhci_hcd:usb5
 17:       2286       2268   IO-APIC-fasteoi   uhci_hcd:usb6, HDA Intel
 18:          0          0   IO-APIC-fasteoi   mmc0
 19:          0          3   IO-APIC-fasteoi   ehci_hcd:usb2
 20:         30         26   IO-APIC-fasteoi   uhci_hcd:usb3
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 22:          1          2   IO-APIC-fasteoi   ehci_hcd:usb1
 26:       7304       7248   PCI-MSI-edge      i915
 27:      16997      16401   PCI-MSI-edge      ahci
 28:       2648       2738   PCI-MSI-edge      eth0
 29:      36782      33811   PCI-MSI-edge      iwlagn
NMI:          0          0   Non-maskable interrupts
LOC:     295497     234740   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
PND:          0          0   Performance pending work
RES:     169127     182977   Rescheduling interrupts
CAL:      13546      17347   Function call interrupts
TLB:        832       1097   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          4          4   Machine check polls
ERR:          1
MIS:          0


cat /proc/config.gz | grep "[y|m]":
-----------------------------------

# Automatically generated make config: don't edit
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_BZIP2=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# RCU Subsystem
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_MM_OWNER=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y
# Kernel Performance Events And Counters
CONFIG_PERF_EVENTS=y
CONFIG_EVENT_PROFILE=y
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_SLOW_WORK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_FREEZER=y
# Processor type and features
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_MEMTEST=y
CONFIG_MCORE2=y
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=y
CONFIG_HIGHMEM64G=y
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_KSM=y
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_SECCOMP=y
CONFIG_HZ_1000=y
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
# Power management and ACPI options
CONFIG_PM=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_RUNTIME=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_POWER_METER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
# CPU Frequency scaling
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# Executable file formats / Emulations
CONFIG_BINFMT_ELF=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_CUBIC=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_SCTP=y
CONFIG_SCTP_HMAC_MD5=y
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_IRDA=y
CONFIG_IRLAN=y
CONFIG_IRNET=y
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRTTY_SIR=m
CONFIG_USB_IRDA=y
CONFIG_SMC_IRCC_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_MAC80211=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_MISC_DEVICES=y
CONFIG_EEPROM_93CX6=m
CONFIG_HAVE_IDE=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# SCSI support type (disk, tape, CD-ROM)
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_ATA_SFF=y
CONFIG_ATA_PIIX=y
CONFIG_MD=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_MULTIPATH=y
# See the help texts for more information.
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
CONFIG_NETDEVICES=y
CONFIG_MACVLAN=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_MII=y
CONFIG_NETDEV_1000=y
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_WLAN=y
CONFIG_WLAN_80211=y
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_LEDS=y
CONFIG_ATH_COMMON=m
CONFIG_ATH5K=m
CONFIG_ATH9K=m
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
CONFIG_ZD1211RW=m
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2500USB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_HERMES=m
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_HSO=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=y
CONFIG_SLIP=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_VMXNET3=m
CONFIG_INPUT=y
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_UINPUT=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_DEVKMEM=y
CONFIG_NOZOMI=m
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_NVRAM=y
CONFIG_IPWIRELESS=m
CONFIG_HANGCHECK_TIMER=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_I801=y
# I2C system bus drivers (mostly embedded / system-on-chip)
CONFIG_SPI=y
CONFIG_SPI_MASTER=y
CONFIG_SPI_BITBANG=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_POWER_SUPPLY=y
CONFIG_HWMON=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_HDAPS=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_BQ24022=y
CONFIG_MEDIA_SUPPORT=y
# Multimedia core support
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_MEDIA=y
# Multimedia drivers
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=y
CONFIG_USB_STV06XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_QUICKCAM_MESSENGER=m
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
CONFIG_USB_ZC0301=m
CONFIG_USB_PWC=m
CONFIG_USB_PWC_DEBUG=y
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_VGA_ARB=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_MODE_HELPERS=y
# Frame buffer hardware drivers
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# Display device support
CONFIG_DISPLAY_SUPPORT=y
# Display hardware drivers
# Console display driver support
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
CONFIG_FONT_SUN8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_PCI=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_USB_HID=y
CONFIG_USB_HIDDEV=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_HID_WACOM=y
CONFIG_HID_ZEROPLUS=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_MON=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_CS=y
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
# also be needed; see USB_STORAGE Help for more info
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_LIBUSUAL=y
# USB Imaging devices
CONFIG_USB_MICROTEK=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_RIO500=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_ISIGHTFW=m
CONFIG_MMC=y
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
CONFIG_EDAC=y
# Reporting subsystems
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82860=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# Platform RTC drivers
CONFIG_RTC_DRV_CMOS=m
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_INTEL_MENLOW=y
# Firmware Drivers
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
# File systems
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
CONFIG_JBD2=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_GENERIC_ACL=y
# CD-ROM/DVD Filesystems
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
# DOS/FAT/NT Filesystems
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_NTFS_FS=y
CONFIG_NTFS_RW=y
# Pseudo filesystems
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_MINIX_FS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_SMB_FS=y
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_CIFS=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# Partition Types
CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_LDM_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_BRANCH_PROFILE_NONE=y
CONFIG_POWER_TRACER=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_RODATA=y
CONFIG_DOUBLEFAULT=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_0X80=y
# Security options
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SMACK=y
CONFIG_CRYPTO=y
# Crypto core or helper
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
# Authenticated Encryption with Associated Data
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y
# Block modes
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_PCBC=y
# Hash modes
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y
# Compression
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# Random Number Generation
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y
# Library routines
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y


uptime:
-------

 17:38:41 up 17 min, 14 users,  load average: 0.12, 0.43, 0.45


free:
-----

             total       used       free     shared    buffers     cached
Mem:       4040720    1589392    2451328          0      38248     758072
-/+ buffers/cache:     793072    3247648
Swap:      1951856          0    1951856


dmesg:
------

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32.7 (me@mypole) (gcc version 4.3.4 (Debian 4.3.4-6) ) #8 SMP PREEMPT Thu Feb 4 22:01:23 CET 2010
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 13C000000 mask FFC000000 uncachable
[    0.000000]   2 base 000000000 mask F00000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 0BF700000 mask FFFF00000 uncachable
[    0.000000]   5 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 00000000bf700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009d800 (usable)
[    0.000000]  modified: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf6b0000 (usable)
[    0.000000]  modified: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
[    0.000000]  modified: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
[    0.000000]  modified: 00000000bf700000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] initial memory mapped : 0 - 02000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037800000 page 2M
[    0.000000]  0037800000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ 7000-d000
[    0.000000] RAMDISK: 7fe7c000 - 7ffef118
[    0.000000] Allocated new RAMDISK: 00100000 - 00273118
[    0.000000] Move RAMDISK from 000000007fe7c000 - 000000007ffef117 to 00100000 - 00273117
[    0.000000] ACPI: RSDP 000f6950 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT bf6bd368 00094 (v01 LENOVO TP-7N    00002190  LTP 00000000)
[    0.000000] ACPI: FACP bf6bd500 000F4 (v03 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20090903/tbfadt-526)
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 000000000000102C/0 (20090903/tbfadt-557)
[    0.000000] ACPI: DSDT bf6bd8db 0E32A (v01 LENOVO TP-7N    00002190 MSFT 03000000)
[    0.000000] ACPI: FACS bf6e4000 00040
[    0.000000] ACPI: SSDT bf6bd6b4 00227 (v01 LENOVO TP-7N    00002190 MSFT 03000000)
[    0.000000] ACPI: ECDT bf6cbc05 00052 (v01 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: TCPA bf6cbc57 00032 (v02 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: APIC bf6cbc89 00068 (v01 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: MCFG bf6cbcf1 0003C (v01 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: HPET bf6cbd2d 00038 (v01 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: SLIC bf6cbdf0 00176 (v01 LENOVO TP-7N    00002190  LTP 00000000)
[    0.000000] ACPI: BOOT bf6cbf66 00028 (v01 LENOVO TP-7N    00002190  LTP 00000001)
[    0.000000] ACPI: ASF! bf6cbf8e 00072 (v16 LENOVO TP-7N    00002190 PTL  00000001)
[    0.000000] ACPI: SSDT bf6e2697 0025F (v01 LENOVO TP-7N    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT bf6e28f6 000A6 (v01 LENOVO TP-7N    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT bf6e299c 004F7 (v01 LENOVO TP-7N    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT bf6e2e93 001D8 (v01 LENOVO TP-7N    00002190 INTL 20050513)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad X61
[    0.000000] ACPI: Added _OSI(Linux)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 4166MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000]   node 0 low ram: 00000000 - 379fe000
[    0.000000]   node 0 bootmap 00009000 - 0000ff40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001b7d5a8]    TEXT DATA BSS ==> [0001000000 - 0001b7d5a8]
[    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
[    0.000000]   #5 [0001b7e000 - 0001b8e138]              BRK ==> [0001b7e000 - 0001b8e138]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000100000 - 0000273118]      NEW RAMDISK ==> [0000100000 - 0000273118]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f6980] f6980
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf6b0
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1029705
[    0.000000] free_area_init_node: node 0, pgdat c1a4f780, node_mem_map c1b90000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3961 pages, LIFO batch:0
[    0.000000]   Normal zone: 1748 pages used for memmap
[    0.000000]   Normal zone: 221994 pages, LIFO batch:31
[    0.000000]   HighMem zone: 8333 pages used for memmap
[    0.000000]   HighMem zone: 793637 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:30000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c4400000 s35224 r0 d22120 u1048576
[    0.000000] pcpu-alloc: s35224 r0 d22120 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1019592
[    0.000000] Kernel command line: root=/dev/sda1 ro selinux=0 quiet thinkpad_acpi.experimental=1 thinkpad_acpi.fan_control=1 fastboot i915.modeset=1 video=intelfb:off
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 25886720 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000379fe:0013c000)
[    0.000000] Memory: 4037836k/5177344k available (7454k kernel code, 80060k reserved, 3151k data, 476k init, 3207880k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff91000 - 0xfffff000   ( 440 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000000]       .init : 0xc1a5c000 - 0xc1ad3000   ( 476 kB)
[    0.000000]       .data : 0xc1747a8a - 0xc1a5b6b8   (3151 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1747a8a   (7454 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Experimental preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1795.523 MHz processor.
[    0.001005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3591.04 BogoMIPS (lpj=1795523)
[    0.001044] Security Framework initialized
[    0.001051] SELinux:  Disabled at boot.
[    0.001067] Mount-cache hash table entries: 512
[    0.001182] Initializing cgroup subsys debug
[    0.001185] Initializing cgroup subsys ns
[    0.001188] Initializing cgroup subsys cpuacct
[    0.001191] Initializing cgroup subsys memory
[    0.001197] Initializing cgroup subsys devices
[    0.001199] Initializing cgroup subsys freezer
[    0.001223] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001225] CPU: L2 cache: 4096K
[    0.001228] CPU: Physical Processor ID: 0
[    0.001229] CPU: Processor Core ID: 0
[    0.001233] mce: CPU supports 6 MCE banks
[    0.001240] CPU0: Thermal monitoring enabled (TM2)
[    0.001244] using mwait in idle threads.
[    0.001250] Performance Events: Core2 events, Intel PMU driver.
[    0.001255] ... version:                2
[    0.001257] ... bit width:              40
[    0.001258] ... generic registers:      2
[    0.001260] ... value mask:             000000ffffffffff
[    0.001261] ... max period:             000000007fffffff
[    0.001263] ... fixed-purpose events:   3
[    0.001264] ... event mask:             0000000700000003
[    0.001268] Checking 'hlt' instruction... OK.
[    0.005985] ACPI: Core revision 20090903
[    0.026451] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036743] CPU0: Intel(R) Core(TM)2 Duo CPU     L7700  @ 1.80GHz stepping 0b
[    0.037015] Booting processor 1 APIC 0x1 ip 0x6000
[    0.001999] Initializing CPU#1
[    0.001999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001999] CPU: L2 cache: 4096K
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 1
[    0.001999] CPU1: Thermal monitoring enabled (TM2)
[    0.108101] CPU1: Intel(R) Core(TM)2 Duo CPU     L7700  @ 1.80GHz stepping 0b
[    0.108114] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.108983] Measured 924102 cycles TSC warp between CPUs, turning off TSC clock.
[    0.108983] Marking TSC unstable due to check_tsc_sync_source failed
[    0.109007] Brought up 2 CPUs
[    0.109010] Total of 2 processors activated (7181.87 BogoMIPS).
[    0.109628] CPU0 attaching sched-domain:
[    0.109632]  domain 0: span 0-1 level MC
[    0.109634]   groups: 0 1
[    0.109640] CPU1 attaching sched-domain:
[    0.109643]  domain 0: span 0-1 level MC
[    0.109645]   groups: 1 0
[    0.111209] regulator: core version 0.5
[    0.111230] NET: Registered protocol family 16
[    0.112014] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.112014] ACPI: bus type pci registered
[    0.112028] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.112028] PCI: MCFG area at f0000000 reserved in E820
[    0.112028] PCI: Using MMCONFIG for extended config space
[    0.112028] PCI: Using configuration type 1 for base access
[    0.122054] bio: create slab <bio-0> at 0
[    0.125498] ACPI: EC: EC description table is found, configuring boot EC
[    0.132054] ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.140805] ACPI: Interpreter enabled
[    0.140812] ACPI: (supports S0 S3 S5)
[    0.140833] ACPI: Using IOAPIC for interrupt routing
[    0.152185] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
[    0.152185] ACPI: Power Resource [PUBS] (on)
[    0.155176] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.155569] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.155608] pci 0000:00:02.0: reg 10 64bit mmio: [0xf8000000-0xf80fffff]
[    0.155608] pci 0000:00:02.0: reg 18 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.155608] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.155608] pci 0000:00:02.1: reg 10 64bit mmio: [0xf8100000-0xf81fffff]
[    0.155990] pci 0000:00:19.0: reg 10 32bit mmio: [0xf8200000-0xf821ffff]
[    0.156006] pci 0000:00:19.0: reg 14 32bit mmio: [0xf8225000-0xf8225fff]
[    0.156023] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.156154] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.156163] pci 0000:00:19.0: PME# disabled
[    0.156295] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.156454] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.156609] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf8426c00-0xf8426fff]
[    0.156754] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.156764] pci 0000:00:1a.7: PME# disabled
[    0.156884] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf8220000-0xf8223fff]
[    0.157042] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.157051] pci 0000:00:1b.0: PME# disabled
[    0.157277] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.157287] pci 0000:00:1c.0: PME# disabled
[    0.157520] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.157527] pci 0000:00:1c.1: PME# disabled
[    0.157695] pci 0000:00:1d.0: reg 20 io port: [0x18a0-0x18bf]
[    0.157856] pci 0000:00:1d.1: reg 20 io port: [0x18c0-0x18df]
[    0.158035] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf8427000-0xf84273ff]
[    0.158192] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.158202] pci 0000:00:1d.7: PME# disabled
[    0.158584] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.158591] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.158598] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
[    0.158605] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
[    0.158611] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
[    0.158723] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.158740] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.158758] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.158775] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.158792] pci 0000:00:1f.1: reg 20 io port: [0x18e0-0x18ef]
[    0.158982] pci 0000:00:1f.2: reg 10 io port: [0x1c30-0x1c37]
[    0.158999] pci 0000:00:1f.2: reg 14 io port: [0x1c24-0x1c27]
[    0.159017] pci 0000:00:1f.2: reg 18 io port: [0x1c28-0x1c2f]
[    0.159034] pci 0000:00:1f.2: reg 1c io port: [0x1c20-0x1c23]
[    0.159051] pci 0000:00:1f.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.159069] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf8426000-0xf84267ff]
[    0.159178] pci 0000:00:1f.2: PME# supported from D3hot
[    0.159188] pci 0000:00:1f.2: PME# disabled
[    0.159265] pci 0000:00:1f.3: reg 10 32bit mmio: [0xf8427400-0xf84274ff]
[    0.159325] pci 0000:00:1f.3: reg 20 io port: [0x1c40-0x1c5f]
[    0.159534] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.159543] pci 0000:00:1c.0: bridge 32bit mmio: [0xf4000000-0xf5ffffff]
[    0.159559] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8500000-0xf85fffff]
[    0.159709] pci 0000:03:00.0: reg 10 64bit mmio: [0xf7f00000-0xf7f01fff]
[    0.159859] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.159871] pci 0000:03:00.0: PME# disabled
[    0.160029] pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
[    0.160039] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6000000-0xf7ffffff]
[    0.160056] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xf8600000-0xf86fffff]
[    0.160154] pci 0000:05:00.0: reg 10 32bit mmio: [0xd7eff000-0xd7efffff]
[    0.160210] pci 0000:05:00.0: supports D1 D2
[    0.160212] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.160222] pci 0000:05:00.0: PME# disabled
[    0.160324] pci 0000:05:00.1: reg 10 32bit mmio: [0xd7efe800-0xd7efefff]
[    0.160473] pci 0000:05:00.1: supports D1 D2
[    0.160476] pci 0000:05:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.160486] pci 0000:05:00.1: PME# disabled
[    0.160587] pci 0000:05:00.2: reg 10 32bit mmio: [0xd7efe400-0xd7efe4ff]
[    0.160736] pci 0000:05:00.2: supports D1 D2
[    0.160739] pci 0000:05:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.160749] pci 0000:05:00.2: PME# disabled
[    0.160903] pci 0000:00:1e.0: transparent bridge
[    0.160913] pci 0000:00:1e.0: bridge io port: [0x4000-0x7fff]
[    0.160923] pci 0000:00:1e.0: bridge 32bit mmio: [0xd4000000-0xd7efffff]
[    0.160941] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd8000000-0xdbffffff]
[    0.161039] pci_bus 0000:00: on NUMA node 0
[    0.161044] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.161216] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.161289] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.161373] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.168125] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
[    0.168333] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.168537] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.168740] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.169098] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.169301] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.169504] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.169706] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.169805] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.169805] vgaarb: loaded
[    0.170079] SCSI subsystem initialized
[    0.171991] libata version 3.00 loaded.
[    0.172012] usbcore: registered new interface driver usbfs
[    0.172012] usbcore: registered new interface driver hub
[    0.172013] usbcore: registered new device driver usb
[    0.172013] PCI: Using ACPI for IRQ routing
[    0.172238] NET: Registered protocol family 23
[    0.172238] Bluetooth: Core ver 2.15
[    0.172986] NET: Registered protocol family 31
[    0.172986] Bluetooth: HCI device and connection manager initialized
[    0.172986] Bluetooth: HCI socket layer initialized
[    0.173017] cfg80211: Using static regulatory domain info
[    0.173017] cfg80211: Regulatory domain: US
[    0.173017] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.173017] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.173017] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.173017] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.173017] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.173017] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.173017] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.173017] cfg80211: Calling CRDA for country: US
[    0.173024] NetLabel: Initializing
[    0.173024] NetLabel:  domain hash size = 128
[    0.173024] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.173024] NetLabel:  unlabeled traffic allowed by default
[    0.173990] Switching to clocksource hpet
[    0.178279] pnp: PnP ACPI init
[    0.178289] ACPI: bus type pnp registered
[    0.182336] pnp: PnP ACPI: found 11 devices
[    0.182338] ACPI: ACPI bus type pnp unregistered
[    0.182349] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.182353] system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
[    0.182357] system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
[    0.182360] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.182363] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.182366] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.182370] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.182373] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.182376] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.182379] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.182383] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.182386] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.182390] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.182398] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.182402] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.182405] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    0.182408] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.182411] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.182414] system 00:02: ioport range 0x1600-0x165f could not be reserved
[    0.182418] system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.182421] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.182425] system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.182428] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.182431] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.182435] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
[    0.219681] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.219687] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.219699] pci 0000:00:1c.0:   MEM window: 0xf4000000-0xf5ffffff
[    0.219709] pci 0000:00:1c.0:   PREFETCH window: 0x000000f8500000-0x000000f85fffff
[    0.219727] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.219733] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
[    0.219746] pci 0000:00:1c.1:   MEM window: 0xf6000000-0xf7ffffff
[    0.219756] pci 0000:00:1c.1:   PREFETCH window: 0x000000f8600000-0x000000f86fffff
[    0.219777] pci 0000:05:00.0: CardBus bridge, secondary bus 0000:06
[    0.219780] pci 0000:05:00.0:   IO window: 0x004000-0x0040ff
[    0.219788] pci 0000:05:00.0:   IO window: 0x004400-0x0044ff
[    0.219798] pci 0000:05:00.0:   PREFETCH window: 0xd8000000-0xdbffffff
[    0.219808] pci 0000:05:00.0:   MEM window: 0xc0000000-0xc3ffffff
[    0.219818] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.219824] pci 0000:00:1e.0:   IO window: 0x4000-0x7fff
[    0.219838] pci 0000:00:1e.0:   MEM window: 0xd4000000-0xd7efffff
[    0.219848] pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
[    0.219886] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.219896] pci 0000:00:1c.0: setting latency timer to 64
[    0.219919] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.219927] pci 0000:00:1c.1: setting latency timer to 64
[    0.219938] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.219951] pci 0000:00:1e.0: setting latency timer to 64
[    0.219973] pci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.219985] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.219987] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.219990] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.219993] pci_bus 0000:02: resource 1 mem: [0xf4000000-0xf5ffffff]
[    0.219996] pci_bus 0000:02: resource 2 pref mem [0xf8500000-0xf85fffff]
[    0.219999] pci_bus 0000:03: resource 0 io:  [0x3000-0x3fff]
[    0.220002] pci_bus 0000:03: resource 1 mem: [0xf6000000-0xf7ffffff]
[    0.220017] pci_bus 0000:03: resource 2 pref mem [0xf8600000-0xf86fffff]
[    0.220020] pci_bus 0000:05: resource 0 io:  [0x4000-0x7fff]
[    0.220023] pci_bus 0000:05: resource 1 mem: [0xd4000000-0xd7efffff]
[    0.220025] pci_bus 0000:05: resource 2 pref mem [0xd8000000-0xdbffffff]
[    0.220028] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.220031] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.220034] pci_bus 0000:06: resource 0 io:  [0x4000-0x40ff]
[    0.220036] pci_bus 0000:06: resource 1 io:  [0x4400-0x44ff]
[    0.220039] pci_bus 0000:06: resource 2 pref mem [0xd8000000-0xdbffffff]
[    0.220041] pci_bus 0000:06: resource 3 mem: [0xc0000000-0xc3ffffff]
[    0.220115] NET: Registered protocol family 2
[    0.220227] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.220581] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.220926] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.221120] TCP: Hash tables configured (established 131072 bind 65536)
[    0.221123] TCP reno registered
[    0.221217] NET: Registered protocol family 1
[    0.223081] RPC: Registered udp transport module.
[    0.223083] RPC: Registered tcp transport module.
[    0.223085] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.223095] pci 0000:00:02.0: Boot video device
[    0.223308] Trying to unpack rootfs image as initramfs...
[    0.264622] Freeing initrd memory: 1484k freed
[    0.265286] Simple Boot Flag at 0x35 set to 0x1
[    0.266392] cpu0(2) debug files 152
[    0.269405] cpu1(2) debug files 152
[    0.269972] microcode: CPU0 sig=0x6fb, pf=0x80, revision=0xb6
[    0.269984] microcode: CPU1 sig=0x6fb, pf=0x80, revision=0xb6
[    0.270054] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.270057] Scanning for low memory corruption every 60 seconds
[    0.270503] audit: initializing netlink socket (disabled)
[    0.270515] type=2000 audit(1265476886.270:1): initialized
[    0.270755] highmem bounce pool size: 64 pages
[    0.273019] VFS: Disk quotas dquot_6.5.2
[    0.273061] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.273299] DLM (built Feb  4 2010 21:32:56) installed
[    0.273520] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.273711] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.273978] Slow work thread pool: Starting up
[    0.274033] Slow work thread pool: Ready
[    0.274035] NTFS driver 2.1.29 [Flags: R/W].
[    0.274096] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.274115] fuse init (API version 7.13)
[    0.274312] msgmni has been set to 1625
[    0.277050] alg: No test for cipher_null (cipher_null-generic)
[    0.277083] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.277112] alg: No test for digest_null (digest_null-generic)
[    0.277141] alg: No test for compress_null (compress_null-generic)
[    0.280361] alg: No test for stdrng (krng)
[    0.287375] alg: No test for ghash (ghash-generic)
[    0.287388] io scheduler noop registered
[    0.287390] io scheduler anticipatory registered
[    0.287392] io scheduler deadline registered
[    0.287419] io scheduler cfq registered (default)
[    0.287720] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.287747] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.288224] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.288249] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.289119] ACPI: AC Adapter [AC] (on-line)
[    0.289284] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.289481] ACPI: Lid Switch [LID]
[    0.289565] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.289574] ACPI: Sleep Button [SLPB]
[    0.289665] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.289668] ACPI: Power Button [PWRF]
[    0.290248] ACPI: SSDT bf6e1b32 00282 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.290969] ACPI: SSDT bf6e1e39 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.294023] Monitor-Mwait will be used to enter C-1 state
[    0.295022] Monitor-Mwait will be used to enter C-2 state
[    0.296022] Monitor-Mwait will be used to enter C-3 state
[    0.296142] processor LNXCPU:00: registered as cooling_device0
[    0.296502] ACPI: SSDT bf6e1a6a 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.296975] ACPI: SSDT bf6e1db4 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.298694] processor LNXCPU:01: registered as cooling_device1
[    0.303866] thermal LNXTHERM:01: registered as thermal_zone0
[    0.303874] ACPI: Thermal Zone [THM0] (67 C)
[    0.305513] thermal LNXTHERM:02: registered as thermal_zone1
[    0.305522] ACPI: Thermal Zone [THM1] (67 C)
[    0.316432] ACPI: Battery Slot [BAT0] (battery present)
[    0.349266] Non-volatile memory driver v1.3
[    0.349355] Linux agpgart interface v0.103
[    0.349371] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    0.350650] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    0.355710] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.355776] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    0.355779] Hangcheck: Using get_cycles().
[    0.355845] [drm] Initialized drm 1.1.0 20060810
[    0.355922] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.355929] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.355934] i915 0000:00:02.0: setting latency timer to 64
[    0.357195] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    0.357198] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.357298] i915 0000:00:02.0: irq 26 for MSI/MSI-X
[    0.357305] [drm] set up 7M of stolen space
[    0.992597] [drm] LVDS-8: set mode 1024x768 c
[    1.081420] Console: switching to colour frame buffer device 128x48
[    1.103621] fb0: inteldrmfb frame buffer device
[    1.103623] registered panic notifier
[    1.106087] acpi device:01: registered as cooling_device2
[    1.106356] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.106364] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.106448] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.106518] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.118058] floppy0: no floppy controllers found
[    4.120435] brd: module loaded
[    4.121572] loop: module loaded
[    4.121846] nbd: registered device at major 43
[    4.124535] ahci 0000:00:1f.2: version 3.0
[    4.124560] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    4.124644] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    4.124722] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x5 impl SATA mode
[    4.124726] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    4.124737] ahci 0000:00:1f.2: setting latency timer to 64
[    4.124904] scsi0 : ahci
[    4.125097] scsi1 : ahci
[    4.125239] scsi2 : ahci
[    4.125418] ata1: SATA max UDMA/133 abar m2048@0xf8426000 port 0xf8426100 irq 27
[    4.125421] ata2: DUMMY
[    4.125426] ata3: SATA max UDMA/133 abar m2048@0xf8426000 port 0xf8426200 irq 27
[    4.125494] ata_piix 0000:00:1f.1: version 2.13
[    4.125505] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    4.125551] ata_piix 0000:00:1f.1: setting latency timer to 64
[    4.125663] scsi3 : ata_piix
[    4.125797] scsi4 : ata_piix
[    4.126645] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x18e0 irq 14
[    4.126649] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18e8 irq 15
[    4.126706] PPP generic driver version 2.4.2
[    4.126830] PPP Deflate Compression module registered
[    4.126835] PPP BSD Compression module registered
[    4.127065] ata5: port disabled. ignoring.
[    4.127175] PPP MPPE Compression module registered
[    4.127178] NET: Registered protocol family 24
[    4.127192] PPPoL2TP kernel driver, V1.0
[    4.127195] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[    4.127197] CSLIP: code copyright 1989 Regents of the University of California.
[    4.127199] SLIP linefill/keepalive option.
[    4.127202] tun: Universal TUN/TAP device driver, 1.6
[    4.127204] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.127323] usbcore: registered new interface driver cdc_ether
[    4.127368] usbcore: registered new interface driver rndis_host
[    4.127420] usbcore: registered new interface driver irda-usb
[    4.127424] USB IrDA support registered
[    4.127473] yenta_cardbus 0000:05:00.0: CardBus bridge found [17aa:20c6]
[    4.430041] ata3: SATA link down (SStatus 0 SControl 300)
[    4.430070] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.431143] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    4.431147] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    4.431151] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    4.431945] ata1.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
[    4.431948] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.433123] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    4.433127] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    4.433130] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    4.433998] ata1.00: configured for UDMA/133
[    4.446930] ata1.00: configured for UDMA/133
[    4.446933] ata1: EH complete
[    4.447047] scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
[    4.447387] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.447423] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    4.447474] sd 0:0:0:0: [sda] Write Protect is off
[    4.447477] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.447502] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.447632]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    4.483593] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.605880] yenta_cardbus 0000:05:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    4.605886] yenta_cardbus 0000:05:00.0: Socket status: 30000006
[    4.605891] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x7fff
[    4.605894] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge Memory window: 0xd4000000 - 0xd7efffff
[    4.605897] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge Memory window: 0xd8000000 - 0xdbffffff
[    4.857330] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.857552] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.857567] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.857582] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.857588] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.857678] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.861618] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    4.861634] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xf8426c00
[    4.871024] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.871046] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.871048] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.871051] usb usb1: Product: EHCI Host Controller
[    4.871053] usb usb1: Manufacturer: Linux 2.6.32.7 ehci_hcd
[    4.871055] usb usb1: SerialNumber: 0000:00:1a.7
[    4.871158] usb usb1: configuration #1 chosen from 1 choice
[    4.871223] hub 1-0:1.0: USB hub found
[    4.871232] hub 1-0:1.0: 4 ports detected
[    4.871530] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.871545] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.871560] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.871566] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.871647] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.871690] ehci_hcd 0000:00:1d.7: debug port 1
[    4.875599] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.875615] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf8427000
[    4.885028] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.885045] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.885048] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.885051] usb usb2: Product: EHCI Host Controller
[    4.885053] usb usb2: Manufacturer: Linux 2.6.32.7 ehci_hcd
[    4.885055] usb usb2: SerialNumber: 0000:00:1d.7
[    4.885161] usb usb2: configuration #1 chosen from 1 choice
[    4.885230] hub 2-0:1.0: USB hub found
[    4.885237] hub 2-0:1.0: 4 ports detected
[    4.885388] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.885438] uhci_hcd: USB Universal Host Controller Interface driver
[    4.885472] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.885483] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.885489] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.885565] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.885609] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.885648] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.885650] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.885653] usb usb3: Product: UHCI Host Controller
[    4.885655] usb usb3: Manufacturer: Linux 2.6.32.7 uhci_hcd
[    4.885657] usb usb3: SerialNumber: 0000:00:1a.0
[    4.885751] usb usb3: configuration #1 chosen from 1 choice
[    4.885813] hub 3-0:1.0: USB hub found
[    4.885820] hub 3-0:1.0: 2 ports detected
[    4.886084] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[    4.886093] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.886104] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.886110] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.886202] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.886248] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.886287] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.886290] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.886292] usb usb4: Product: UHCI Host Controller
[    4.886294] usb usb4: Manufacturer: Linux 2.6.32.7 uhci_hcd
[    4.886297] usb usb4: SerialNumber: 0000:00:1a.1
[    4.886389] usb usb4: configuration #1 chosen from 1 choice
[    4.886451] hub 4-0:1.0: USB hub found
[    4.886458] hub 4-0:1.0: 2 ports detected
[    4.886752] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.886761] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.886772] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.886777] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.886858] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    4.886894] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
[    4.886930] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.886933] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.886936] usb usb5: Product: UHCI Host Controller
[    4.886938] usb usb5: Manufacturer: Linux 2.6.32.7 uhci_hcd
[    4.886940] usb usb5: SerialNumber: 0000:00:1d.0
[    4.887067] usb usb5: configuration #1 chosen from 1 choice
[    4.887132] hub 5-0:1.0: USB hub found
[    4.887139] hub 5-0:1.0: 2 ports detected
[    4.887246] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.887258] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.887262] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.887338] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    4.887379] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
[    4.887415] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.887417] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.887420] usb usb6: Product: UHCI Host Controller
[    4.887422] usb usb6: Manufacturer: Linux 2.6.32.7 uhci_hcd
[    4.887424] usb usb6: SerialNumber: 0000:00:1d.1
[    4.887516] usb usb6: configuration #1 chosen from 1 choice
[    4.887580] hub 6-0:1.0: USB hub found
[    4.887587] hub 6-0:1.0: 2 ports detected
[    4.887743] sl811: driver sl811-hcd, 19 May 2005
[    4.887881] usbcore: registered new interface driver cdc_acm
[    4.887885] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    4.887935] usbcore: registered new interface driver usblp
[    4.887984] usbcore: registered new interface driver cdc_wdm
[    4.887987] Initializing USB Mass Storage driver...
[    4.888071] usbcore: registered new interface driver usb-storage
[    4.888074] USB Mass Storage support registered.
[    4.888140] usbcore: registered new interface driver libusual
[    4.888188] usbcore: registered new interface driver ums-alauda
[    4.888238] usbcore: registered new interface driver ums-datafab
[    4.888298] usbcore: registered new interface driver ums-freecom
[    4.888346] usbcore: registered new interface driver ums-isd200
[    4.888392] usbcore: registered new interface driver ums-jumpshot
[    4.888439] usbcore: registered new interface driver ums-karma
[    4.888486] usbcore: registered new interface driver ums-onetouch
[    4.888533] usbcore: registered new interface driver ums-sddr09
[    4.888580] usbcore: registered new interface driver ums-sddr55
[    4.888628] usbcore: registered new interface driver ums-usbat
[    4.888678] usbcore: registered new interface driver berry_charge
[    4.888797] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    4.900359] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.900365] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.900591] mice: PS/2 mouse device common for all mice
[    4.901067] i2c /dev entries driver
[    4.901306] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.901493] Linux video capture interface: v2.00
[    4.901537] gspca: main v2.7.0 registered
[    4.902236] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    4.904334] device-mapper: multipath: version 1.1.0 loaded
[    4.904337] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.904410] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    4.904458] EDAC MC: Ver: 2.1.0 Feb  4 2010
[    4.907489] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    4.908386] cpuidle: using governor ladder
[    4.909167] cpuidle: using governor menu
[    4.909365] sdhci: Secure Digital Host Controller Interface driver
[    4.909367] sdhci: Copyright(c) Pierre Ossman
[    4.909385] sdhci-pci 0000:05:00.2: SDHCI controller found [1180:0822] (rev 21)
[    4.909419] sdhci-pci 0000:05:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.910439] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[    4.910450] sdhci-pci 0000:05:00.2: setting latency timer to 64
[    4.911608] Registered led device: mmc0::
[    4.912766] mmc0: SDHCI controller on PCI [0000:05:00.2] using DMA
[    4.912870] ricoh-mmc: Ricoh MMC Controller disabling driver
[    4.912872] ricoh-mmc: Copyright(c) Philip Langdale
[    4.912972] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    4.912974] wbsd: Copyright(c) Pierre Ossman
[    4.918841] wacom driver registered
[    4.919292] usbcore: registered new interface driver hiddev
[    4.919415] usbcore: registered new interface driver usbhid
[    4.919418] usbhid: v2.6:USB HID core driver
[    4.920050] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[    4.920053] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.920055] thinkpad_acpi: ThinkPad BIOS 7NETB9WW (2.19 ), EC 7MHT25WW-1.03
[    4.920057] thinkpad_acpi: Lenovo ThinkPad X61s, model 7666B4G
[    4.920353] thinkpad_acpi: radio switch found; radios are enabled
[    4.920464] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    4.920466] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    4.926615] Registered led device: tpacpi::thinklight
[    4.926759] Registered led device: tpacpi::power
[    4.926885] Registered led device: tpacpi::standby
[    4.927036] Registered led device: tpacpi::thinkvantage
[    4.930329] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[    4.930829] input: ThinkPad Extra Buttons as /devices/virtual/input/input5
[    4.931076] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    4.932503] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.932507] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
[    4.932529] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.336295] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[    5.340030] usbcore: registered new interface driver snd-usb-audio
[    5.340034] ALSA device list:
[    5.340036]   #0: HDA Intel at 0xf8220000 irq 17
[    5.340130] NET: Registered protocol family 26
[    5.340133] Mirror/redirect action on
[    5.340493] netem: version 1.2
[    5.340495] u32 classifier
[    5.340496]     Performance counters on
[    5.340498]     input device check on 
[    5.340499]     Actions configured 
[    5.340503] Netfilter messages via NETLINK v0.30.
[    5.340519] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.340644] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    5.340647] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[    5.340649] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    5.341164] IPv4 over IPv4 tunneling driver
[    5.341529] GRE over IPv4 tunneling driver
[    5.342318] TCP cubic registered
[    5.342320] Initializing XFRM netlink socket
[    5.342324] NET: Registered protocol family 17
[    5.342329] NET: Registered protocol family 15
[    5.343115] IrCOMM protocol (Dag Brattli)
[    5.348059] Bluetooth: L2CAP ver 2.14
[    5.348061] Bluetooth: L2CAP socket layer initialized
[    5.348064] Bluetooth: SCO (Voice Link) ver 0.6
[    5.348066] Bluetooth: SCO socket layer initialized
[    5.348089] Bluetooth: RFCOMM TTY layer initialized
[    5.348092] Bluetooth: RFCOMM socket layer initialized
[    5.348094] Bluetooth: RFCOMM ver 1.11
[    5.348096] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.348098] Bluetooth: BNEP filters: protocol multicast
[    5.348100] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    5.348674] SCTP: Hash tables configured (established 65536 bind 65536)
[    5.349862] Using IPI No-Shortcut mode
[    5.350311] registered taskstats version 1
[    5.351252] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    5.351355] Freeing unused kernel memory: 476k freed
[    5.351642] Write protecting the kernel text: 7456k
[    5.351774] Write protecting the kernel read-only data: 2504k
[    5.434116] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    5.452387] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input7
[    5.583125] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    5.732704] usb 3-1: New USB device found, idVendor=0a5c, idProduct=2110
[    5.732711] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.732717] usb 3-1: Product: BCM2045B
[    5.732722] usb 3-1: Manufacturer: Broadcom Corp
[    5.733069] usb 3-1: configuration #1 chosen from 1 choice
[    5.942124] usb 3-2: new full speed USB device using uhci_hcd and address 3
[    6.102703] usb 3-2: New USB device found, idVendor=0483, idProduct=2016
[    6.102710] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.102716] usb 3-2: Product: Biometric Coprocessor
[    6.102721] usb 3-2: Manufacturer: STMicroelectronics
[    6.103073] usb 3-2: configuration #1 chosen from 1 choice
[   12.753713] EXT3-fs: INFO: recovery required on readonly filesystem.
[   12.753720] EXT3-fs: write access will be enabled during recovery.
[   13.059470] EXT3-fs: recovery complete.
[   13.059668] kjournald starting.  Commit interval 5 seconds
[   13.066962] EXT3-fs: mounted filesystem with writeback data mode.
[   18.334910] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   18.334917] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   18.335051] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   18.335075] e1000e 0000:00:19.0: setting latency timer to 64
[   18.336604] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   18.339011] rtc_cmos 00:07: RTC can wake from S4
[   18.339365] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   18.339433] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   18.345437] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   18.346241] usbcore: registered new interface driver btusb
[   18.408803] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[   18.408806] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   18.408904] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   18.408941] iwlagn 0000:03:00.0: setting latency timer to 64
[   18.408996] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[   18.461043] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[   18.461141] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[   18.465767] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   18.476812] udev: renamed network interface wlan0 to eth1
[   18.570366] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:d3:c6:d1:c1
[   18.570373] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   18.570412] 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: ffffff-0ff
[   19.671561] EXT3 FS on dm-0, internal journal
[   23.387140] thinkpad_ec: thinkpad_ec 0.40 loaded.
[   23.397492] tp_smapi 0.40 loading...
[   23.397958] tp_smapi successfully loaded (smapi_port=0xb2).
[   23.498470] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   23.498474] vboxdrv: Successfully done.
[   23.498475] vboxdrv: Found 2 processor cores.
[   23.498654] vboxdrv: fAsync=1 offMin=0xe1024 offMax=0xe1024
[   23.498945] vboxdrv: TSC mode is 'asynchronous', kernel timer mode is 'normal'.
[   23.498947] vboxdrv: Successfully loaded version 1.6.6_OSE (interface 0x00100001).
[   23.911188] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   23.911220] kjournald starting.  Commit interval 5 seconds
[   23.911643] EXT3 FS on sda1, internal journal
[   23.911649] EXT3-fs: recovery complete.
[   23.911656] EXT3-fs: mounted filesystem with writeback data mode.
[   24.409303] kjournald starting.  Commit interval 5 seconds
[   24.420536] EXT3 FS on dm-1, internal journal
[   24.420542] EXT3-fs: recovery complete.
[   24.420919] EXT3-fs: mounted filesystem with writeback data mode.
[   24.506354] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   24.506534] kjournald starting.  Commit interval 5 seconds
[   24.514296] EXT3 FS on dm-2, internal journal
[   24.514302] EXT3-fs: recovery complete.
[   24.514309] EXT3-fs: mounted filesystem with writeback data mode.
[   24.673459] Adding 1951856k swap on /dev/mapper/cswap.  Priority:-1 extents:1 across:1951856k 
[   26.253756] ip_tables: (C) 2000-2006 Netfilter Core Team
[   28.078446] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
[   28.190080] iwlagn 0000:03:00.0: loaded firmware version 228.61.2.24
[   28.407977] Registered led device: iwl-phy0::radio
[   28.407996] Registered led device: iwl-phy0::assoc
[   28.408012] Registered led device: iwl-phy0::RX
[   28.408028] Registered led device: iwl-phy0::TX
[   29.747044] ttyS0: LSR safety check engaged!
[   29.748210] ttyS0: LSR safety check engaged!
[   29.749735] ttyS1: LSR safety check engaged!
[   29.755419] ttyS1: LSR safety check engaged!
[   30.404058] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input11
[   34.982146] smapi smapi: set_real_thresh: set start to 79 for bat=0
[   35.190171] smapi smapi: set_real_thresh: set stop to 93 for bat=0
[   42.954199] usb 3-1: USB disconnect, address 2
[   43.002415] usbcore: deregistering interface driver btusb
[   44.105667] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   44.156225] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   45.993769] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   45.993778] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   47.590769] ttyS0: LSR safety check engaged!
[   47.591892] ttyS1: LSR safety check engaged!
[   55.803510] eth1: deauthenticating from 02:24:01:49:a6:a9 by local choice (reason=3)
[   55.803540] eth1: direct probe to AP 02:24:01:49:a6:a9 (try 1)
[   56.003058] eth1: direct probe to AP 02:24:01:49:a6:a9 (try 2)
[   56.005702] eth1: direct probe responded
[   56.005705] eth1: authenticate with AP 02:24:01:49:a6:a9 (try 1)
[   56.205036] eth1: authenticate with AP 02:24:01:49:a6:a9 (try 2)
[   56.207081] eth1: authenticated
[   56.207100] eth1: associate with AP 02:24:01:49:a6:a9 (try 1)
[   56.407106] eth1: associate with AP 02:24:01:49:a6:a9 (try 2)
[   56.409689] eth1: RX AssocResp from 02:24:01:49:a6:a9 (capab=0x401 status=0 aid=2)
[   56.409697] eth1: associated
[   56.699288] eth1: deauthenticating from 02:24:01:49:a6:a9 by local choice (reason=3)
[   56.987398] Registered led device: iwl-phy0::radio
[   56.987418] Registered led device: iwl-phy0::assoc
[   56.987436] Registered led device: iwl-phy0::RX
[   56.987452] Registered led device: iwl-phy0::TX
[   57.016322] eth1: direct probe to AP 02:24:01:49:a6:a9 (try 1)
[   57.216067] eth1: direct probe to AP 02:24:01:49:a6:a9 (try 2)
[   57.417042] eth1: direct probe to AP 02:24:01:49:a6:a9 (try 3)
[   57.419744] eth1: direct probe responded
[   57.419750] eth1: authenticate with AP 02:24:01:49:a6:a9 (try 1)
[   57.619094] eth1: authenticate with AP 02:24:01:49:a6:a9 (try 2)
[   57.620968] eth1: authenticated
[   57.621033] eth1: associate with AP 02:24:01:49:a6:a9 (try 1)
[   57.821088] eth1: associate with AP 02:24:01:49:a6:a9 (try 2)
[   57.826321] eth1: RX AssocResp from 02:24:01:49:a6:a9 (capab=0x401 status=0 aid=2)
[   57.826328] eth1: associated

### EOF
### vim:tw=256:et:sts=2:st=2:sw=2:com+=b\:###:fo+=cqtr:tags=ctags:
