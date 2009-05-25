Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZEYOu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZEYOu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZEYOuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:50:20 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:43865 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZEYOuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:50:14 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 10:50:12 EDT
Date: Mon, 25 May 2009 16:42:52 +0200
From: lkml-spam@Think-Future.com
To: Linux Kernel-Liste <linux-kernel@vger.kernel.org>
Subject: PROBLEM: iwlagn RX/TX ERR, thinkpad acpi hotkey oops, drm vblank
	ERR
Message-ID: <20090525144252.GA14305@localhost>
Reply-To: lkml-no-spam@Think-Future.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



  Hi, 

Since 2.6.30-rc6 iwlagn started logging errors and tp acpi hotkey is oopsing..
This drm vblank error is known since 2.6.28 maybe..

BTW, using KMS since two weeks ago, very nice, no more X lock ups, but 2.6.30-rc6 was required, 2.6.29 had trouble setting correct resolution. 
Now KMS is running fine, WELL DONE, everyone! :)

One line summary of the problem:    
After resume, wlan not available. thinkpad acpi hotkey oops. drm vblank err.


Full description of the problem/report:
- iwlagn driver logging TX/RX errors. 
- thinkpad acpi hotkey oops.
- drm vblank error
See appended dmesg.
Keywords (i.e., modules, networking, kernel):
iwlagn, thinkpad, acpi, hotkey, oops, drm, vblank


/proc/version:
--------------
Linux version 2.6.30-rc6 (radtkens@localhost) (gcc version 4.3.3 (Debian 4.3.3-10) ) #1 SMP PREEMPT Mon May 18 12:41:16 CEST 2009


A small shell script or example program which triggers the oops:

/etc/init.d/bootlocal.sh:
  echo enable > /proc/acpi/ibm/hotkey; (*)
  /etc/acpi/scripts/bluetooth.sh disable;
  trackpointSelect="/sys/devices/platform/i8042/serio1/press_to_select";
  test -s "$trackpointSelect" && { \
    echo "Activating Press-To-Select for Thinkpad trackpoint.";
    echo -n 1 > "$trackpointSelect" ;
  }

(*) this cmd reproducibly triggers an oops.


/usr/src/linux/scripts/ver_linux:
---------------------------------
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
Linux localhost 2.6.30-rc6 #1 SMP PREEMPT Mon May 18 12:41:16 CEST 2009 i686 GNU/Linux
Gnu C                  4.3.3
Gnu make               3.81
binutils               2.19.1
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.7-pre9
e2fsprogs              1.41.3
PPP                    2.4.4
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.3
wireless-tools         29
Modules Loaded         iwlagn iptable_nat nf_nat iptable_mangle ipt_LOG xt_tcpudp xt_state xt_multiport iptable_filter ip_tables x_tables tp_smapi thinkpad_ec iwlcore e1000e


/proc/cpuinfo:
--------------
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     L7700  @ 1.80GHz
stepping	: 11
cpu MHz		: 1200.000
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida tpr_shadow vnmi flexpriority
bogomips	: 3590.84
clflush size	: 64
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida tpr_shadow vnmi flexpriority
bogomips	: 3590.79
clflush size	: 64
power management:


/proc/modules:
--------------
iwlagn 72464 0 - Live 0xf932e000
iptable_nat 4684 0 - Live 0xf90f4000
nf_nat 16384 1 iptable_nat, Live 0xf90e7000
iptable_mangle 2252 0 - Live 0xf90d0000
ipt_LOG 5392 5 - Live 0xf90bf000
xt_tcpudp 2572 59 - Live 0xf90b4000
xt_state 1676 68 - Live 0xf90aa000
xt_multiport 2796 2 - Live 0xf9091000
iptable_filter 2188 1 - Live 0xf9084000
ip_tables 11196 3 iptable_nat,iptable_mangle,iptable_filter, Live 0xf9078000
x_tables 14096 6 iptable_nat,ipt_LOG,xt_tcpudp,xt_state,xt_multiport,ip_tables, Live 0xf9069000
tp_smapi 21436 0 - Live 0xf8954000
thinkpad_ec 5928 1 tp_smapi, Live 0xf85bd000
iwlcore 90444 1 iwlagn, Live 0xf85e2000
e1000e 113884 0 - Live 0xf8582000


/proc/ioports:
--------------
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
004f-004f : smapi
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
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
  4400-44FF : PCI CardBus 0000:06


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
00100000-7e6affff : System RAM
  00100000-00796538 : Kernel code
  00796539-00a61197 : Kernel data
  00ad6000-00b7b213 : Kernel bss
7e6b0000-7e6cbfff : ACPI Tables
7e6cc000-7e6fffff : ACPI Non-volatile Storage
7e700000-7effffff : reserved
80000000-83ffffff : PCI CardBus 0000:06
84000000-84000fff : Intel Flush Page
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
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
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
	Kernel driver in use: pcieport-driver
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
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
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
	Memory window 1: 80000000-83fff000
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
root=/dev/sda2 ro selinux=0 quiet thinkpad_acpi.experimental=1 thinkpad_acpi.fan_control=1 fastboot i915.modeset=1 video=intelfb:off



/proc/interrupts:
-----------------
           CPU0       CPU1       
  0:   17199686    2461480   IO-APIC-edge      timer
  1:      29645       7191   IO-APIC-edge      i8042
  9:     112400      25407   IO-APIC-fasteoi   acpi
 12:    1291419     343961   IO-APIC-edge      i8042
 14:          0          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:          0          0   IO-APIC-fasteoi   yenta, uhci_hcd:usb5
 17:     465549      11867   IO-APIC-fasteoi   uhci_hcd:usb6, HDA Intel
 18:          0          0   IO-APIC-fasteoi   mmc0
 19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 20:         82         29   IO-APIC-fasteoi   uhci_hcd:usb3
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 22:          2          2   IO-APIC-fasteoi   ehci_hcd:usb1
 26:     189628     290273   PCI-MSI-edge      i915@pci:0000:00:02.0
 27:     323928     129889   PCI-MSI-edge      ahci
 29:      22009     173979   PCI-MSI-edge      iwlagn
NMI:          0          0   Non-maskable interrupts
LOC:   11333860   19713349   Local timer interrupts
SPU:          0          0   Spurious interrupts
RES:    2048372    2256888   Rescheduling interrupts
CAL:       2124       4277   Function call interrupts
TLB:      43600      48878   TLB shootdowns
TRM:          0          0   Thermal event interrupts
ERR:          0
MIS:          0



cat /proc/config.gz | grep "[y|m]":
-----------------------------------
# Automatically generated make config: don't edit
# Mon May 18 12:29:03 2009
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
CONFIG_FAST_CMPXCHG_LOCAL=y
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
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
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
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# RCU Subsystem
CONFIG_CLASSIC_RCU=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_USER_SCHED=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
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
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
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
CONFIG_X86_CMOV=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=y
CONFIG_HIGHMEM4G=y
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
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
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
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
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_MAC80211=y
# Rate control algorithm selection
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_LEDS=y
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_LEDS=y
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
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_ATA=y
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
# Enable only one of the two stacks, unless you know what you are doing
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_TUN=y
CONFIG_MII=y
CONFIG_NETDEV_1000=y
CONFIG_E1000=m
CONFIG_E1000E=m
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
CONFIG_ADM8211=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_LEDS=y
CONFIG_ATH5K=m
CONFIG_ATH9K=m
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
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
CONFIG_B43_LEDS=y
CONFIG_B43_RFKILL=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_RFKILL=y
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
CONFIG_RT2X00_LIB_RFKILL=y
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
CONFIG_LEGACY_PTYS=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_NVRAM=y
CONFIG_IPWIRELESS=m
CONFIG_HANGCHECK_TIMER=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
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
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# Multimedia devices
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
CONFIG_DRM=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_MODE_HELPERS=y
# Frame buffer hardware drivers
CONFIG_FB_INTEL=y
CONFIG_FB_INTEL_I2C=y
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
CONFIG_SND_PCI=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
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
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
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
CONFIG_HID_TOPSEED=y
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
CONFIG_JBD=y
CONFIG_JBD2=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
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
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
CONFIG_POWER_TRACER=y
CONFIG_HAVE_ARCH_KGDB=y
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
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
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
CONFIG_HAVE_KVM_IRQCHIP=y
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
 16:10:28 up 23:25,  8 users,  load average: 0.57, 0.57, 0.62




free:
-----
             total       used       free     shared    buffers     cached
Mem:       2043268    1933636     109632          0      10040     773380
-/+ buffers/cache:    1150216     893052
Swap:      1951856     296784    1655072




dmesg:
------
[29777.825358] Freezing user space processes ... (elapsed 0.05 seconds) done.
[29777.879438] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[29777.879562] Suspending console(s) (use no_console_suspend to debug)
[29778.604431] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[29778.604780] sd 0:0:0:0: [sda] Stopping disk
[29780.653288] ACPI handle has no context!
[29780.653306] sdhci-pci 0000:05:00.2: PME# disabled
[29780.653325] sdhci-pci 0000:05:00.2: PCI INT C disabled
[29780.653343] ACPI handle has no context!
[29780.708252] ata5: port disabled. ignoring.
[29780.708380] ata_piix 0000:00:1f.1: PCI INT C disabled
[29780.708403] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[29780.708548] ehci_hcd 0000:00:1d.7: PME# disabled
[29780.720145] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[29780.720173] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[29780.720288] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[29780.720407] HDA Intel 0000:00:1b.0: PCI INT B disabled
[29780.731131] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[29780.731256] ehci_hcd 0000:00:1a.7: PME# disabled
[29780.743316] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[29780.743343] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[29780.743450] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[29780.746110] e1000e 0000:00:19.0: PCI INT A disabled
[29780.746125] e1000e 0000:00:19.0: PME# disabled
[29781.001957] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
[29781.012293] i915 0000:00:02.0: power state changed by ACPI to D3
[29781.050184] ACPI: Preparing to enter system sleep state S3
[29781.189526] Disabling non-boot CPUs ...
[29781.191940] CPU 1 is now offline
[29781.191944] SMP alternatives: switching to UP code
[29781.206879] CPU0 attaching NULL sched-domain.
[29781.206886] CPU1 attaching NULL sched-domain.
[29781.206898] CPU0 attaching NULL sched-domain.
[29781.207405] CPU1 is down
[29781.207503] Extended CMOS year: 2000
[29781.207503] Intel machine check architecture supported.
[29781.207503] Intel machine check reporting enabled on CPU#0.
[29781.207503] Back to C!
[29781.207503] Extended CMOS year: 2000
[29781.207503] Enabling non-boot CPUs ...
[29781.207503] SMP alternatives: switching to SMP code
[29781.213533] Booting processor 1 APIC 0x1 ip 0x6000
[29781.206415] Initializing CPU#1
[29781.206415] Calibrating delay using timer specific routine.. 3590.79 BogoMIPS (lpj=1795399)
[29781.206415] CPU: L1 I cache: 32K, L1 D cache: 32K
[29781.206415] CPU: L2 cache: 4096K
[29781.206415] CPU: Physical Processor ID: 0
[29781.206415] CPU: Processor Core ID: 1
[29781.206415] Intel machine check architecture supported.
[29781.206415] Intel machine check reporting enabled on CPU#1.
[29781.284621] CPU1: Intel(R) Core(TM)2 Duo CPU     L7700  @ 1.80GHz stepping 0b
[29781.284668] CPU0 attaching NULL sched-domain.
[29781.285274] Switched to high resolution mode on CPU 1
[29781.287022] CPU0 attaching sched-domain:
[29781.287025]  domain 0: span 0-1 level MC
[29781.287028]   groups: 0 1
[29781.287032] CPU1 attaching sched-domain:
[29781.287034]  domain 0: span 0-1 level MC
[29781.287036]   groups: 1 0
[29781.287370] microcode: failed to init CPU1
[29781.288308] CPU1 is up
[29781.288313] ACPI: Waking up from system sleep state S3
[29781.734409] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[29781.734476] pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
[29781.734701] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[29781.784202] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[29781.784282] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[29781.784396] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[29781.784546] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[29781.784708] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[29781.784944] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[29781.793194] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[29781.793274] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[29781.793369] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[29781.793491] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[29781.793621] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
[29781.793973] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[29781.805143] sdhci-pci 0000:05:00.2: restoring config space at offset 0x4 (was 0x0, writing 0xd7efe400)
[29781.805159] sdhci-pci 0000:05:00.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
[29781.805180] sdhci-pci 0000:05:00.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
[29781.920361] i915 0000:00:02.0: setting latency timer to 64
[29781.921703] pci 0000:00:02.1: PME# disabled
[29781.921882] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[29781.921888] e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
[29781.921903] e1000e 0000:00:19.0: setting latency timer to 64
[29781.921924] e1000e 0000:00:19.0: PME# disabled
[29781.921937] e1000e 0000:00:19.0: PME# disabled
[29781.922106] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[29782.194542] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[29782.194561] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[29782.194615] usb usb3: root hub lost power or was reset
[29782.194738] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[29782.194757] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[29782.194810] usb usb4: root hub lost power or was reset
[29782.194957] ehci_hcd 0000:00:1a.7: PME# disabled
[29782.194968] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[29782.194986] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[29782.195027] ehci_hcd 0000:00:1a.7: PME# disabled
[29782.195198] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[29782.195216] HDA Intel 0000:00:1b.0: setting latency timer to 64
[29782.195374] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[29782.195393] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[29782.195446] usb usb5: root hub lost power or was reset
[29782.195562] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[29782.195581] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[29782.195634] usb usb6: root hub lost power or was reset
[29782.195798] ehci_hcd 0000:00:1d.7: PME# disabled
[29782.195809] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[29782.195827] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[29782.195845] ehci_hcd 0000:00:1d.7: PME# disabled
[29782.195871] pci 0000:00:1e.0: setting latency timer to 64
[29782.195975] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[29782.195989] ata_piix 0000:00:1f.1: setting latency timer to 64
[29782.197089] ata5: port disabled. ignoring.
[29782.197493] ahci 0000:00:1f.2: setting latency timer to 64
[29782.200452] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100506, writing 0x100106)
[29782.332360] pci 0000:05:00.1: PME# disabled
[29782.332506] sdhci-pci 0000:05:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[29782.332512] sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[29782.334088] sd 0:0:0:0: [sda] Starting disk
[29782.504359] ata3: SATA link down (SStatus 0 SControl 300)
[29782.518318] eth1: no probe response from AP 00:23:08:19:54:da - disassociating
[29783.473353] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[29783.475108] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[29783.475117] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[29783.475124] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[29783.477801] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[29783.477809] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[29783.477816] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[29783.478815] ata1.00: configured for UDMA/133
[29783.481744] ata1.00: configured for UDMA/133
[29783.484698] ata1: EH complete
[29783.905335] usb 3-2: reset full speed USB device using uhci_hcd and address 2
[29784.246916] Registered led device: iwl-phy1::radio
[29784.246963] Registered led device: iwl-phy1::assoc
[29784.247048] Registered led device: iwl-phy1::RX
[29784.247096] Registered led device: iwl-phy1::TX
[29784.285459] Restarting tasks ... done.
[29787.604929] eth1: authenticate with AP 00:23:08:19:54:da
[29787.624332] eth1: authenticate with AP 00:23:08:19:54:da
[29787.624342] eth1: authenticated
[29787.624345] eth1: associate with AP 00:23:08:19:54:da
[29787.628756] eth1: RX ReassocResp from 00:23:08:19:54:da (capab=0x431 status=0 aid=2)
[29787.628759] eth1: associated
[29792.524302] smapi smapi: set_real_thresh: set start to 88 for bat=0
[29792.731539] smapi smapi: set_real_thresh: set stop to 94 for bat=0
[29793.481136] thinkpad_acpi: procfs hotkey enable/disable: access by process with PID 20507
[29793.481152] ------------[ cut here ]------------
[29793.481158] WARNING: at drivers/platform/x86/thinkpad_acpi.c:2962 hotkey_enabledisable_warn+0x74/0x80()
[29793.481164] Hardware name: 7666B4G
[29793.481168] thinkpad_acpi: hotkey enable/disable functionality has been removed from the driver.  Hotkeys are always enabled
[29793.481173] Modules linked in: iwlagn iptable_nat nf_nat iptable_mangle ipt_LOG xt_tcpudp xt_state xt_multiport iptable_filter ip_tables x_tables tp_smapi thinkpad_ec iwlcore e1000e [last unloaded: iwlagn]
[29793.481212] Pid: 20507, comm: bootlocal.sh Tainted: G        W  2.6.30-rc6 #1
[29793.481217] Call Trace:
[29793.481230]  [<c01381c7>] ? warn_slowpath_fmt+0x87/0xe0
[29793.481242]  [<c07952c9>] ? _spin_lock_irqsave+0x19/0x40
[29793.481250]  [<c0151ba1>] ? up+0x11/0x40
[29793.481258]  [<c07954be>] ? _spin_unlock_irqrestore+0xe/0x30
[29793.481267]  [<c0138849>] ? release_console_sem+0x189/0x1d0
[29793.481276]  [<c0138d8b>] ? vprintk+0x2ab/0x390
[29793.481286]  [<c01a9ac3>] ? __dentry_open+0x1d3/0x2b0
[29793.481294]  [<c079510d>] ? _spin_lock+0xd/0x30
[29793.481301]  [<c079554c>] ? _spin_unlock+0xc/0x20
[29793.481311]  [<c01c3571>] ? mnt_drop_write+0x61/0x130
[29793.481318]  [<c01a9c93>] ? nameidata_to_filp+0x53/0x70
[29793.481326]  [<c079262c>] ? printk+0x17/0x1b
[29793.481334]  [<c05bec94>] ? hotkey_enabledisable_warn+0x74/0x80
[29793.481342]  [<c05bed38>] ? hotkey_write+0x98/0x1d0
[29793.481351]  [<c05bf11a>] ? dispatch_procfs_write+0x8a/0xb0
[29793.481361]  [<c01f430d>] ? proc_file_write+0x5d/0x90
[29793.481370]  [<c01f42b0>] ? proc_file_write+0x0/0x90
[29793.481378]  [<c01ef7a4>] ? proc_reg_write+0x64/0xa0
[29793.481385]  [<c01ef740>] ? proc_reg_write+0x0/0xa0
[29793.481394]  [<c01ac0b0>] ? vfs_write+0xa0/0x140
[29793.481402]  [<c01ac221>] ? sys_write+0x41/0x80
[29793.481410]  [<c0102fb1>] ? syscall_call+0x7/0xb
[29793.481416] ---[ end trace 718827299b2b4014 ]---
[29880.379017] Hangcheck: hangcheck value past margin!


### EOF
### vim:tw=256:et:sts=2:st=2:sw=2:com+=b\:###:fo+=cqtr:tags=ctags:
