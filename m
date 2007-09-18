Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbXIREHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbXIREHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbXIREHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:07:45 -0400
Received: from smtp1.Vir.com ([199.202.113.40]:55687 "EHLO smtp1.vir.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbXIREHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:07:43 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 00:07:42 EDT
Message-ID: <46EF4DE1.4000707@soo.com>
Date: Tue, 18 Sep 2007 00:02:41 -0400
From: ben soo <lnx-kern@soo.com>
Reply-To: lnx-kern@soo.com
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Network sky2 Module
References: <46E2BC6A.4070800@gmx.de>
In-Reply-To: <46E2BC6A.4070800@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i'm experiencing this problem myself.  i have 2 servers, one using 
X86_64 kernel version 2.6.23-rc5 on a 100Mbit network and one with 
i386 kernel version 2.6.23-rc6 on a 1Gbit network.

They both have this issue with the sky2 network device driver 
whereby the device would stop working and need to be brought down 
and back up.

On the X86_64 kernel on a 100Mbit network, this is a very 
occasional thing, while on the i386 kernel on a 1Gbit network the 
device only works for a few minutes at a time.  If i set the MTU to 
7200 then the device seems to stay functional, but then i see long 
delays when it's talking to 100Mbit devices with standard 1500 MTU 
that are outside of its LAN segment.

This last might be an artifact caused by the firewall, i dunno.

b

Werner Meurer wrote:
> [1.] One line summary of the problem:   
> hw csum failure appears in syslog
> 
> [2.] Full description of the problem/report:
> 
> hw csum failure appears in syslog and sometimes, under heavy network 
> utilization, with NFS-Daemon the Network Device totally fails. Then no 
> Network Access is possible. Reboot is not required but i must restart 
> the Network with the following commands: "ifdown eth0" and "rmmod sky2", 
> then "insmod sky2" and "ifup eth0".
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> 
> sky2 (Marvell Yukon Onboard Ethernet), networking, checksum
> 
> [4.] Kernel version (from /proc/version):
> 
> Linux version 2.6.18.8 (root@endeavour) (gcc version 4.1.2 20061115 
> (prerelease) (SUSE Linux)) #6 SMP Sun Aug 5 15:09:57 CEST 2007
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information 
>     resolved (see Documentation/oops-tracing.txt)
> 
> endeavour:~ # dmesg -c
> <unknown>: hw csum failure.
> 
> Call Trace:
> [<ffffffff80248cbc>] __skb_checksum_complete+0x4a/0x62
> [<ffffffff803bc9c4>] udp_poll+0x67/0xf3
> [<ffffffff8020f3f4>] do_select+0x285/0x46d
> [<ffffffff8021c589>] __pollwait+0x0/0xe0
> [<ffffffff8027ee8f>] default_wake_function+0x0/0xe
> [<ffffffff8025e0a0>] _spin_lock_bh+0x9/0x14
> [<ffffffff8022ec61>] release_sock+0x13/0xaa
> [<ffffffff8024da32>] udp_sendmsg+0x480/0x563
> [<ffffffff80250300>] sock_sendmsg+0xf3/0x110
> [<ffffffff8022e430>] sock_recvmsg+0x101/0x120
> [<ffffffff80292267>] autoremove_wake_function+0x0/0x2e
> [<ffffffff8024362b>] sock_aio_write+0x51/0x60
> [<ffffffff80242efe>] try_to_wake_up+0x3e2/0x3f3
> [<ffffffff80214323>] sys_select+0x26f/0x3d6
> [<ffffffff80388aa0>] sys_sendto+0x119/0x14c
> [<ffffffff80257b16>] system_call+0x7e/0x83
> 
> 
> [6.] A small shell script or example program which triggers the
>     problem (if possible)
> 
> -
> 
> [7.] Environment
> 
> Homebrew Server (Asus P5WDG2-WS Motherboard).
> 
> [7.1.] Software (add the output of the ver_linux script here)
> 
> Linux endeavour 2.6.18.8 #6 SMP Sun Aug 5 15:09:57 CEST 2007 x86_64 
> x86_64 x86_6                                              4 GNU/Linux
> 
> Gnu C                  4.1.2
> Gnu make               3.81
> binutils               2.17.50.0.5
> util-linux             2.12r
> mount                  2.12r
> module-init-tools      3.2.2
> e2fsprogs              1.39
> jfsutils               1.1.11
> reiserfsprogs          3.6.19
> xfsprogs               2.8.11
> PPP                    2.4.4
> Linux C Library        > libc.2.5
> Dynamic linker (ldd)   2.5
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> Sh-utils               6.4
> udev                   103
> Modules Loaded         capability commoncap sky2 nfs lockd nfs_acl 
> sunrpc iptabl                                              e_filter 
> ip_tables x_tables nls_utf8 af_packet w83627ehf hwmon i2c_isa eeprom 
> i2                                              c_dev joydev st sd_mod 
> ide_cd truecrypt nls_iso8859_1 nls_cp437 vfat fat vmnet 
> v                                              mmon ipv6 button battery 
> ac sg sr_mod cdrom loop usb_storage scsi_mod dm_mod 
> i2c                                              _i801 shpchp 
> pci_hotplug ehci_hcd uhci_hcd i2c_core usbcore floppy parport_pc 
> lp                                               parport ext3 mbcache 
> jbd edd fan piix thermal processor ide_disk ide_core
> 
> 
> [7.2.] Processor information (from /proc/cpuinfo):
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 6
> model name      :               Intel(R) Pentium(R) D CPU 3.60GHz
> stepping        : 4
> cpu MHz         : 3612.869
> cache size      : 2048 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 6
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall 
> lm constant_tsc pni monitor ds_cpl vmx est cid cx16 xtpr lahf_lm
> bogomips        : 7231.81
> clflush size    : 64
> cache_alignment : 128
> address sizes   : 36 bits physical, 48 bits virtual
> 
> [7.3.] Module information (from /proc/modules):
> 
> capability 22536 0 - Live 0xffffffff88435000
> commoncap 25472 1 capability, Live 0xffffffff8842d000
> sky2 61444 0 - Live 0xffffffff8811b000
> nfs 275768 0 - Live 0xffffffff883e8000
> lockd 86800 1 nfs, Live 0xffffffff883d1000
> nfs_acl 20608 1 nfs, Live 0xffffffff883ca000
> sunrpc 193224 3 nfs,lockd,nfs_acl, Live 0xffffffff88399000
> iptable_filter 20096 0 - Live 0xffffffff88393000
> ip_tables 39656 1 iptable_filter, Live 0xffffffff88388000
> x_tables 35336 1 ip_tables, Live 0xffffffff8837e000
> nls_utf8 19072 0 - Live 0xffffffff88378000
> af_packet 57356 0 - Live 0xffffffff88368000
> w83627ehf 33548 0 - Live 0xffffffff8835e000
> hwmon 20488 1 w83627ehf, Live 0xffffffff88357000
> i2c_isa 23040 1 w83627ehf, Live 0xffffffff88350000
> eeprom 24976 0 - Live 0xffffffff88348000
> i2c_dev 28168 0 - Live 0xffffffff88340000
> joydev 28160 0 - Live 0xffffffff88338000
> st 57764 0 - Live 0xffffffff88328000
> sd_mod 39296 0 - Live 0xffffffff8831d000
> ide_cd 59552 0 - Live 0xffffffff8830d000
> truecrypt 173088 1 - Live 0xffffffff882c0000
> nls_iso8859_1 22144 1 - Live 0xffffffff88306000
> nls_cp437 23808 1 - Live 0xffffffff882ff000
> vfat 31104 1 - Live 0xffffffff88220000
> fat 73008 1 vfat, Live 0xffffffff882ec000
> vmnet 76976 21 - Live 0xffffffff882ac000
> vmmon 166252 28 - Live 0xffffffff88282000
> ipv6 358496 77 - Live 0xffffffff88229000
> button 24736 0 - Live 0xffffffff88218000
> battery 28168 0 - Live 0xffffffff88210000
> ac 22792 0 - Live 0xffffffff88209000
> sg 54952 0 - Live 0xffffffff881fa000
> sr_mod 34724 0 - Live 0xffffffff881f0000
> cdrom 54056 2 ide_cd,sr_mod, Live 0xffffffff881e1000
> loop 33296 0 - Live 0xffffffff881d7000
> usb_storage 105664 0 - Live 0xffffffff881bc000
> scsi_mod 174128 5 st,sd_mod,sg,sr_mod,usb_storage, Live 0xffffffff88190000
> dm_mod 81872 3 truecrypt, Live 0xffffffff8817b000
> i2c_i801 25364 0 - Live 0xffffffff88173000
> shpchp 56748 0 - Live 0xffffffff88162000
> pci_hotplug 52356 1 shpchp, Live 0xffffffff88154000
> ehci_hcd 51080 0 - Live 0xffffffff88144000
> uhci_hcd 42520 0 - Live 0xffffffff88138000
> i2c_core 41472 5 w83627ehf,i2c_isa,eeprom,i2c_dev,i2c_i801, Live 
> 0xffffffff8812c000
> usbcore 163240 4 usb_storage,ehci_hcd,uhci_hcd, Live 0xffffffff880f2000
> floppy 82344 0 - Live 0xffffffff880dc000
> parport_pc 58984 1 - Live 0xffffffff880cc000
> lp 30664 0 - Live 0xffffffff880c1000
> parport 59788 2 parport_pc,lp, Live 0xffffffff880b1000
> ext3 163856 1 - Live 0xffffffff88087000
> mbcache 27016 1 ext3, Live 0xffffffff8807f000
> jbd 91000 1 ext3, Live 0xffffffff88067000
> edd 27912 0 - Live 0xffffffff8805f000
> fan 22408 0 - Live 0xffffffff88058000
> piix 28164 0 [permanent], Live 0xffffffff88050000
> thermal 33552 0 - Live 0xffffffff88046000
> processor 54120 1 thermal, Live 0xffffffff88037000
> ide_disk 34304 4 - Live 0xffffffff8802d000
> ide_core 171136 4 ide_cd,usb_storage,piix,ide_disk, Live 0xffffffff88002000
> 
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> 
> 0000-001f : dma1
> 0020-0021 : pic1
> 0040-0043 : timer0
> 0050-0053 : timer1
> 0060-006f : keyboard
> 0070-0077 : rtc
> 0080-008f : dma page reg
> 00a0-00a1 : pic2
> 00c0-00df : dma2
> 00f0-00ff : fpu
> 01f0-01f7 : ide0
> 0295-0296 : w83627ehf
> 0378-037a : parport0
> 037b-037f : parport0
> 03c0-03df : vga+
> 03f2-03f5 : floppy
> 03f6-03f6 : ide0
> 03f7-03f7 : floppy DIR
> 03f8-03ff : serial
> 0400-041f : 0000:00:1f.3
>  0400-041f : i801_smbus
> 0800-0803 : ACPI PM1a_EVT_BLK
> 0804-0805 : ACPI PM1a_CNT_BLK
> 0808-080b : ACPI PM_TMR
> 0810-0815 : ACPI CPU throttle
> 0820-0820 : ACPI PM2_CNT_BLK
> 0828-082f : ACPI GPE0_BLK
> 0cf8-0cff : PCI conf1
> b000-bfff : PCI Bus #01
>  b800-b8ff : 0000:01:00.0
> c000-cfff : PCI Bus #02
>  c800-c8ff : 0000:02:00.0
>    c800-c8ff : sky2
> d880-d88f : 0000:00:1f.2
> dc00-dc03 : 0000:00:1f.2
> e000-e007 : 0000:00:1f.2
> e080-e083 : 0000:00:1f.2
> e400-e407 : 0000:00:1f.2
> e480-e49f : 0000:00:1d.0
>  e480-e49f : uhci_hcd
> e800-e81f : 0000:00:1d.1
>  e800-e81f : uhci_hcd
> e880-e89f : 0000:00:1d.2
>  e880-e89f : uhci_hcd
> ec00-ec1f : 0000:00:1d.3
>  ec00-ec1f : uhci_hcd
> ffa0-ffaf : 0000:00:1f.1
>  ffa0-ffa7 : ide0
>  ffa8-ffaf : ide1
> 
> 00000000-0009fbff : System RAM
>  00000000-00000000 : Crash kernel
> 0009fc00-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000c7fff : Video ROM
> 000f0000-000fffff : System ROM
> 00100000-7ff7ffff : System RAM
>  00200000-003d71c7 : Kernel code
>  003d71c8-00513607 : Kernel data
> 7ff80000-7ff8dfff : ACPI Tables
> 7ff8e000-7ffdffff : ACPI Non-volatile Storage
> 7ffe0000-7fffffff : reserved
> 88000000-880fffff : PCI Bus #01
>  88000000-8800ffff : 0000:01:00.0
> fc900000-fe9fffff : PCI Bus #01
>  fd000000-fdffffff : 0000:01:00.0
> fea00000-feafffff : PCI Bus #02
>  feac0000-feadffff : 0000:02:00.0
>  feafc000-feafffff : 0000:02:00.0
>    feafc000-feafffff : sky2
> febff800-febffbff : 0000:00:1f.2
> febffc00-febfffff : 0000:00:1d.7
>  febffc00-febfffff : ehci_hcd
> ff800000-ff8fffff : PCI Bus #03
> ff900000-ff9fffff : PCI Bus #05
> ffb00000-ffffffff : reserved
> 
> [7.5.] PCI information ('lspci -vvv' as root)
> 
> 00:00.0 Host bridge: Intel Corporation 82975X Memory Controller Hub (rev 
> c0)
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8178
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort+ >SERR- <PERR-
>     Latency: 0
>     Capabilities: [e0] Vendor Specific Information
> 
> 00:01.0 PCI bridge: Intel Corporation 82975X PCI Express Root Port (rev 
> c0) (prog-if 00 [Normal decode])
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size: 16 bytes
>     Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>     I/O behind bridge: 0000f000-00000fff
>     Memory behind bridge: fff00000-000fffff
>     Prefetchable memory behind bridge: 00000000ff900000-00000000ff9fffff
>     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [88] Subsystem: Intel Corporation Unknown device 0000
>     Capabilities: [80] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0 Enable+
>         Address: fee00000  Data: 40b9
>     Capabilities: [a0] Express Root Port (Slot+) IRQ 0
>         Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>         Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>         Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 2
>         Link: Latency L0s <1us, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x0
>         Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
>         Slot: Number 0, PowerLimit 0.000000
>         Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>         Slot: AttnInd Off, PwrInd On, Power-
>         Root: Correctable- Non-Fatal- Fatal- PME-
> 
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
> Port 1 (rev 01) (prog-if 00 [Normal decode])
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size: 16 bytes
>     Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
>     I/O behind bridge: 0000f000-00000fff
>     Memory behind bridge: fff00000-000fffff
>     Prefetchable memory behind bridge: 00000000ff800000-00000000ff8fffff
>     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] Express Root Port (Slot-) IRQ 0
>         Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s unlimited, L1 unlimited
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>         Device: MaxPayload 256 bytes, MaxReadReq 128 bytes
>         Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 1
>         Link: Latency L0s <1us, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x4
>         Root: Correctable- Non-Fatal- Fatal- PME-
>     Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0 Enable+
>         Address: fee00000  Data: 40c1
>     Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Capabilities: [a0] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI 
> Express Port 5 (rev 01) (prog-if 00 [Normal decode])
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size: 16 bytes
>     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>     I/O behind bridge: 0000c000-0000cfff
>     Memory behind bridge: fea00000-feafffff
>     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] Express Root Port (Slot-) IRQ 0
>         Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s unlimited, L1 unlimited
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>         Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>         Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 5
>         Link: Latency L0s <256ns, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
>         Link: Speed 2.5Gb/s, Width x1
>         Root: Correctable- Non-Fatal- Fatal- PME-
>     Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0 Enable+
>         Address: fee00000  Data: 40c9
>     Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Capabilities: [a0] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> #1 (rev 01) (prog-if 00 [UHCI])
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Interrupt: pin A routed to IRQ 225
>     Region 4: I/O ports at e480 [size=32]
> 
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> #2 (rev 01) (prog-if 00 [UHCI])
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Interrupt: pin B routed to IRQ 233
>     Region 4: I/O ports at e800 [size=32]
> 
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> #3 (rev 01) (prog-if 00 [UHCI])
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Interrupt: pin C routed to IRQ 50
>     Region 4: I/O ports at e880 [size=32]
> 
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> #4 (rev 01) (prog-if 00 [UHCI])
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Interrupt: pin D routed to IRQ 58
>     Region 4: I/O ports at ec00 [size=32]
> 
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
> Controller (rev 01) (prog-if 20 [EHCI])
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Interrupt: pin A routed to IRQ 225
>     Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [50] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [58] Debug port
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 
> 01 [Subtractive decode])
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
>     I/O behind bridge: 0000b000-0000bfff
>     Memory behind bridge: fc900000-fe9fffff
>     Prefetchable memory behind bridge: 0000000088000000-00000000880fffff
>     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>     Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Unknown device 8179
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC 
> Interface Bridge (rev 01)
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Capabilities: [e0] Vendor Specific Information
> 
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE 
> Controller (rev 01) (prog-if 8a [Master SecP PriP])
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Interrupt: pin A routed to IRQ 209
>     Region 0: I/O ports at <unassigned>
>     Region 1: I/O ports at <unassigned>
>     Region 2: I/O ports at <unassigned>
>     Region 3: I/O ports at <unassigned>
>     Region 4: I/O ports at ffa0 [size=16]
> 
> 00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) 
> Serial ATA Storage Controller AHCI (rev 01) (prog-if 01 [AHCI 1.0])
>     Subsystem: ASUSTeK Computer Inc. Unknown device 2606
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Interrupt: pin B routed to IRQ 11
>     Region 0: I/O ports at e400 [size=8]
>     Region 1: I/O ports at e080 [size=4]
>     Region 2: I/O ports at e000 [size=8]
>     Region 3: I/O ports at dc00 [size=4]
>     Region 4: I/O ports at d880 [size=16]
>     Region 5: Memory at febff800 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0 Enable-
>         Address: 00000000  Data: 0000
>     Capabilities: [70] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot+,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
> (rev 01)
>     Subsystem: ASUSTeK Computer Inc. Unknown device 8179
>     Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Interrupt: pin B routed to IRQ 66
>     Region 4: I/O ports at 0400 [size=32]
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc 264VT [Mach64 
> VT] (rev 40) (prog-if 00 [VGA])
>     Subsystem: ATI Technologies Inc Mach64VT Reference
>     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop+ ParErr- 
> Stepping+ SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
>     Region 1: I/O ports at b800 [size=256]
>     Expansion ROM at 88000000 [disabled] [size=64K]
> 
> 02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8062 PCI-E 
> IPMI Gigabit Ethernet Controller (rev 14)
>     Subsystem: ASUSTeK Computer Inc. Unknown device 81da
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size: 16 bytes
>     Interrupt: pin A routed to IRQ 217
>     Region 0: Memory at feafc000 (64-bit, non-prefetchable) [size=16K]
>     Region 2: I/O ports at c800 [size=256]
>     Expansion ROM at feac0000 [disabled] [size=128K]
>     Capabilities: [48] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>     Capabilities: [50] Vital Product Data
>     Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ 
> Queue=0/1 Enable+
>         Address: 00000000fee00000  Data: 40d9
>     Capabilities: [e0] Express Legacy Endpoint IRQ 0
>         Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s unlimited, L1 unlimited
>         Device: AtnBtn- AtnInd- PwrInd-
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
>         Link: Latency L0s <256ns, L1 unlimited
>         Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
>         Link: Speed 2.5Gb/s, Width x1
> 
> 03:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI Bridge 
> A (rev 09) (prog-if 00 [Normal decode])
>     Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size: 16 bytes
>     Bus: primary=03, secondary=04, subordinate=04, sec-latency=64
>     I/O behind bridge: 0000f000-00000fff
>     Memory behind bridge: fff00000-000fffff
>     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>     Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: AtnBtn- AtnInd- PwrInd-
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
>         Link: Latency L0s unlimited, L1 unlimited
>         Link: ASPM Disabled CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x4
>     Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ 
> Queue=0/0 Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [6c] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [d8] PCI-X bridge device
>         Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
>         Status: Dev=03:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
>         Upstream: Capacity=65535 CommitmentLimit=65535
>         Downstream: Capacity=65535 CommitmentLimit=65535
> 
> [7.6.] SCSI information (from /proc/scsi/scsi)
> 
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>  Vendor: PLEXTOR  Model: DVDR   PX-716A   Rev: 1.09
>  Type:   CD-ROM                           ANSI SCSI revision: 02
> 
> [7.7.] Other information that might be relevant to the problem
>       (please look in /proc and include all information that you
>       think to be relevant):
> 
> filename:       /lib/modules/2.6.18.8/kernel/drivers/net/sky2.ko
> description:    Marvell Yukon 2 Gigabit Ethernet driver
> author:         Stephen Hemminger <shemminger@osdl.org>
> license:        GPL
> version:        1.5
> vermagic:       2.6.18.8 SMP mod_unload gcc-4.1
> depends:
> alias:          pci:v00001148d00009000sv*sd*bc*sc*i*
> alias:          pci:v00001148d00009E00sv*sd*bc*sc*i*
> alias:          pci:v00001186d00004B00sv*sd*bc*sc*i*
> alias:          pci:v00001186d00004001sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004340sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004341sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004342sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004343sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004344sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004345sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004346sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004347sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004350sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004351sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004352sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004353sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004360sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004361sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004362sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004363sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004364sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004365sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004366sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004367sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004368sv*sd*bc*sc*i*
> alias:          pci:v000011ABd00004369sv*sd*bc*sc*i*
> srcversion:     B7CB0B95067486ED1B6EEEB
> parm:           idle_timeout:Idle timeout workaround for lost interrupts 
> (ms) (int)
> parm:           disable_msi:Disable Message Signaled Interrupt (MSI) (int)
> parm:           copybreak:Receive copy threshold (int)
> parm:           debug:Debug level (0=none,...,16=all) (int)
> 
> 
> [X.] Other notes, patches, fixes, workarounds:
