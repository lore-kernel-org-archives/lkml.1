Return-Path: <linux-kernel-owner+w=401wt.eu-S948405AbXHMRD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948405AbXHMRD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973120AbXHMQhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:37:47 -0400
Received: from hailstorm.thirdlight.com ([217.147.81.102]:55667 "EHLO
	hailstorm.thirdlight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S973086AbXHMQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:37:39 -0400
Mime-Version: 1.0 (Apple Message framework v752.3)
References: <BA9BE39C-C80E-4425-806F-9615BCDCBC52@wells.org.uk>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <99CCAC05-8065-428B-8B01-5D23E620968F@wells.org.uk>
Content-Transfer-Encoding: 7bit
From: Michael Wells <michael@wells.org.uk>
Subject: PROBLEM: 'soft lockup detected on CPU#1!'
Date: Mon, 13 Aug 2007 17:37:35 +0100
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a report on a hard crash on a Linux 2.6.18.3 kernel. I'm not  
sure if you need everything (don't regularly report or work on  
kernels) but I've gone to http://www.kernel.org/pub/linux/docs/lkml/ 
reporting-bugs.html in the hope that this will be of some use.

The symptom is a hard crash, with no network services available  
spontaneously. The kernel dumps reports of a soft lockup to the  
serial console and says "BUG: soft lockup detected on CPU#1!".

This has not been seen before and could well be a hardware fault.

Kind regards
Michael Wells

[root@tsunami scripts]# cat /proc/version
Linux version 2.6.18.3 (root@tsunami) (gcc version 3.4.4 20050721  
(Red Hat 3.4.4-2)) #1 SMP Thu Nov 23 13:16:08 GMT 2006

[root@tsunami scripts]# cat /proc/modules
ip_conntrack_ftp 8432 0 - Live 0xf8871000
ip_conntrack_irc 7664 0 - Live 0xf886e000
ipt_REJECT 6016 6 - Live 0xf883b000
xt_tcpudp 4096 16 - Live 0xf883e000
xt_state 2944 28 - Live 0xf8839000
ip_conntrack 47680 3 ip_conntrack_ftp,ip_conntrack_irc,xt_state, Live  
0xf8861000
iptable_filter 3840 1 - Live 0xf8837000
ip_tables 14948 1 iptable_filter, Live 0xf8832000
x_tables 14980 4 ipt_REJECT,xt_tcpudp,xt_state,ip_tables, Live  
0xf882d000
sg 36636 0 - Live 0xf881b000
aic79xx 205140 2 - Live 0xf8904000
scsi_transport_spi 24448 1 aic79xx, Live 0xf880c000
sd_mod 21504 4 - Live 0xf8814000
scsi_mod 134696 4 sg,aic79xx,scsi_transport_spi,sd_mod, Live 0xf88a1000

[root@tsunami scripts]# cat /proc/iomem
00000000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000d1dff : Adapter ROM
000d2000-000d37ff : Adapter ROM
000d3800-000d4fff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
   00100000-002e8612 : Kernel code
   002e8613-0038ba1b : Kernel data
7fff0000-7fffefff : ACPI Tables
7ffff000-7fffffff : ACPI Non-volatile Storage
88000000-880003ff : 0000:00:1f.1
fc000000-fc0fffff : PCI Bus #01
   fc000000-fc01ffff : 0000:01:0c.0
fc100000-fc3fffff : PCI Bus #02
   fc100000-fc1fffff : PCI Bus #03
   fc200000-fc2fffff : PCI Bus #04
fc500000-fe5fffff : PCI Bus #01
   fd000000-fdffffff : 0000:01:0c.0
   fe3f0000-fe3f0fff : 0000:01:0c.0
fe600000-feafffff : PCI Bus #02
   fe600000-fe6fffff : PCI Bus #03
     fe6c0000-fe6dffff : 0000:03:07.0
       fe6c0000-fe6dffff : e1000
     fe6e0000-fe6fffff : 0000:03:07.1
       fe6e0000-fe6fffff : e1000
   fe700000-fe9fffff : PCI Bus #04
     fe880000-fe8fffff : 0000:04:07.0
     fe900000-fe97ffff : 0000:04:07.1
     fe9e0000-fe9e1fff : 0000:04:07.0
     fe9f0000-fe9f1fff : 0000:04:07.1
   feae0000-feae0fff : 0000:02:1c.0
   feaf0000-feaf0fff : 0000:02:1e.0
fec00000-fed003ff : reserved
fee00000-fee00fff : reserved
fff00000-ffffffff : reserved


[root@tsunami scripts]# cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
02f8-02ff : serial
03a0-03af : 0000:00:1f.1
03c0-03df : vga+
03f8-03ff : serial
0400-047f : 0000:00:1f.0
0480-04bf : 0000:00:1f.0
0580-059f : 0000:00:1f.3
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus #01
   1000-10ff : 0000:01:0c.0
2000-4fff : PCI Bus #02
   2000-2fff : PCI Bus #03
     2000-203f : 0000:03:07.1
       2000-203f : e1000
     2040-207f : 0000:03:07.0
       2040-207f : e1000
   3000-4fff : PCI Bus #04
     3000-30ff : 0000:04:07.1
       3000-30ff : aic79xx
     3400-34ff : 0000:04:07.1
       3400-34ff : aic79xx
     3800-38ff : 0000:04:07.0
       3800-38ff : aic79xx
     4000-40ff : 0000:04:07.0
       4000-40ff : aic79xx


[root@tsunami scripts]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.80GHz
stepping        : 5
cpu MHz         : 2791.124
cache size      : 512 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr  
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm  
pbe cid xtpr
bogomips        : 5586.37

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.80GHz
stepping        : 5
cpu MHz         : 2791.124
cache size      : 512 KB
physical id     : 3
siblings        : 1
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr  
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm  
pbe cid xtpr
bogomips        : 5582.47

[root@tsunami scripts]# cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: MAXTOR   Model: ATLAS10K4_36SCA  Rev: DFV0
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 01 Lun: 00
   Vendor: MAXTOR   Model: ATLASU320_18_SCA Rev: B120
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 06 Lun: 00
   Vendor: ESG-SHV  Model: SCA HSBP M18     Rev: 0.07
   Type:   Processor                        ANSI SCSI revision: 02

[root@tsunami scripts]# ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
Linux tsunami 2.6.18.3 #1 SMP Thu Nov 23 13:16:08 GMT 2006 i686 i686  
i386 GNU/Linux
Gnu C                  3.4.4
Gnu make               3.80
binutils               2.15.92.0.2
util-linux             2.12a
mount                  2.12a
module-init-tools      3.1-pre5
e2fsprogs              1.35
pcmcia-cs              3.2.7
quota-tools            3.12.
PPP                    2.4.2
isdn4k-utils           3.3
nfs-utils              1.0.6
Linux C Library        2.3.4
Dynamic linker (ldd)   2.3.4
Procps                 3.2.3
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
udev                   039
Modules Loaded         ip_conntrack_ftp ip_conntrack_irc ipt_REJECT  
xt_tcpudp xt_state ip_conntrack iptable_filter ip_tables x_tables sg  
aic79xx scsi_transport_spi sd_mod scsi_mod

[root@tsunami scripts]# lspci -vvv
00:00.0 Host bridge: Intel Corporation E7501 Memory Controller Hub  
(rev 01)
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Capabilities: [40] Vendor Specific Information

00:00.1 Class ff00: Intel Corporation E7500/E7501 Host RASUM  
Controller (rev 01)
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:03.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface C PCI- 
to-PCI Bridge (rev 01) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64
         Bus: primary=00, secondary=02, subordinate=04, sec-latency=0
         I/O behind bridge: 00002000-00004fff
         Memory behind bridge: fe600000-feafffff
         Prefetchable memory behind bridge: fc100000-fc3fffff
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:03.1 Class ff00: Intel Corporation E7500/E7501 Hub Interface C  
RASUM Controller (rev 01)
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 42) (prog- 
if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr+ Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
         I/O behind bridge: 00001000-00001fff
         Memory behind bridge: fc500000-fe5fffff
         Prefetchable memory behind bridge: fc000000-fc0fffff
         Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801CA LPC Interface  
Controller (rev 02)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-  
ParErr+ Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801CA Ultra ATA Storage  
Controller (rev 02) (prog-if 8a [Master SecP PriP])
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 169
         Region 0: I/O ports at <unassigned>
         Region 1: I/O ports at <unassigned>
         Region 2: I/O ports at <unassigned>
         Region 3: I/O ports at <unassigned>
         Region 4: I/O ports at 03a0 [size=16]
         Region 5: Memory at 88000000 (32-bit, non-prefetchable)  
[disabled] [size=1K]

00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (rev 02)
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin B routed to IRQ 169
         Region 4: I/O ports at 0580 [size=32]

01:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev  
27) (prog-if 00 [VGA])
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (2000ns min), Cache Line Size 10
         Interrupt: pin A routed to IRQ 169
         Region 0: Memory at fd000000 (32-bit, non-prefetchable)  
[size=16M]
         Region 1: I/O ports at 1000 [size=256]
         Region 2: Memory at fe3f0000 (32-bit, non-prefetchable)  
[size=4K]
         Expansion ROM at fc000000 [disabled] [size=128K]
         Capabilities: [5c] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME 
(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog- 
if 20 [IO(X)-APIC])
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at feae0000 (32-bit, non-prefetchable)  
[size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=2 Dev=28 Func=0 64bit+ 133MHz+ SCD-  
USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

02:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge  
(rev 04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr+ Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=02, secondary=04, subordinate=04, sec-latency=64
         I/O behind bridge: 00003000-00004fff
         Memory behind bridge: fe700000-fe9fffff
         Prefetchable memory behind bridge:  
00000000fc200000-00000000fc200000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-,  
SRD- Freq=2
                 Status: Bus=2 Dev=29 Func=0 64bit+ 133MHz+ SCD-  
USC-, SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

02:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog- 
if 20 [IO(X)-APIC])
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at feaf0000 (32-bit, non-prefetchable)  
[size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=2 Dev=30 Func=0 64bit+ 133MHz+ SCD-  
USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

02:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge  
(rev 04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr+ Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=02, secondary=03, subordinate=03, sec-latency=64
         I/O behind bridge: 00002000-00002fff
         Memory behind bridge: fe600000-fe6fffff
         Prefetchable memory behind bridge:  
00000000fc100000-00000000fc100000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-,  
SRD- Freq=2
                 Status: Bus=2 Dev=31 Func=0 64bit+ 133MHz+ SCD-  
USC-, SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

03:07.0 Ethernet controller: Intel Corporation 82546EB Gigabit  
Ethernet Controller (Copper) (rev 01)
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (63750ns min), Cache Line Size 10
         Interrupt: pin A routed to IRQ 177
         Region 0: Memory at fe6c0000 (64-bit, non-prefetchable)  
[size=128K]
         Region 4: I/O ports at 2040 [size=64]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk+ DSI+ D1- D2- AuxCurrent=0mA PME(D0 
+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [e4] PCI-X non-bridge device.
                 Command: DPERE- ERO+ RBC=0 OST=0
                 Status: Bus=3 Dev=7 Func=0 64bit+ 133MHz+ SCD- USC-,  
DC=simple, DMMRBC=2, DMOST=0, DMCRS=1, RSCEM-
         Capabilities: [f0] Message Signalled Interrupts: 64bit+  
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000

03:07.1 Ethernet controller: Intel Corporation 82546EB Gigabit  
Ethernet Controller (Copper) (rev 01)
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (63750ns min), Cache Line Size 10
         Interrupt: pin B routed to IRQ 185
         Region 0: Memory at fe6e0000 (64-bit, non-prefetchable)  
[size=128K]
         Region 4: I/O ports at 2000 [size=64]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk+ DSI+ D1- D2- AuxCurrent=0mA PME(D0 
+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [e4] PCI-X non-bridge device.
                 Command: DPERE- ERO+ RBC=0 OST=0
                 Status: Bus=3 Dev=7 Func=1 64bit+ 133MHz+ SCD- USC-,  
DC=simple, DMMRBC=2, DMOST=0, DMCRS=1, RSCEM-
         Capabilities: [f0] Message Signalled Interrupts: 64bit+  
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000

04:07.0 SCSI storage controller: Adaptec AIC-7902 U320 (rev 03)
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (10000ns min, 6250ns max), Cache Line Size 10
         Interrupt: pin A routed to IRQ 201
         Region 0: I/O ports at 3800 [size=256]
         Region 1: Memory at fe9e0000 (64-bit, non-prefetchable)  
[disabled] [size=8K]
         Region 3: I/O ports at 4000 [size=256]
         Expansion ROM at fe880000 [disabled] [size=512K]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME 
(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [a0] Message Signalled Interrupts: 64bit+  
Queue=0/1 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [94] PCI-X non-bridge device.
                 Command: DPERE- ERO+ RBC=0 OST=4
                 Status: Bus=4 Dev=7 Func=0 64bit+ 133MHz+ SCD- USC-,  
DC=simple, DMMRBC=0, DMOST=4, DMCRS=1, RSCEM-

04:07.1 SCSI storage controller: Adaptec AIC-7902 U320 (rev 03)
         Subsystem: Intel Corporation: Unknown device 341a
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium  
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (10000ns min, 6250ns max), Cache Line Size 10
         Interrupt: pin B routed to IRQ 193
         Region 0: I/O ports at 3000 [size=256]
         Region 1: Memory at fe9f0000 (64-bit, non-prefetchable)  
[disabled] [size=8K]
         Region 3: I/O ports at 3400 [size=256]
         Expansion ROM at fe900000 [disabled] [size=512K]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME 
(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [a0] Message Signalled Interrupts: 64bit+  
Queue=0/1 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [94] PCI-X non-bridge device.
                 Command: DPERE- ERO+ RBC=0 OST=4
                 Status: Bus=4 Dev=7 Func=1 64bit+ 133MHz+ SCD- USC-,  
DC=simple, DMMRBC=0, DMOST=4, DMCRS=1, RSCEM-


Kernel note in /var/log/messages:

Aug 13 16:05:52 tsunami kernel: BUG: unable to handle kernel paging  
request at virtual address 00100104
Aug 13 16:05:52 tsunami kernel:  printing eip:
Aug 13 16:05:52 tsunami kernel: c01f6269
Aug 13 16:05:52 tsunami kernel: *pde = 00000000
Aug 13 16:05:52 tsunami kernel: Oops: 0002 [#1]
Aug 13 16:05:52 tsunami kernel: SMP
Aug 13 16:05:52 tsunami kernel: Modules linked in: ip_conntrack_ftp  
ip_conntrack_irc ipt_REJECT xt_tcpudp xt_state ip_conntrack iptable_fi
lter ip_tables x_tables sg aic79xx scsi_transport_spi sd_mod scsi_mod
Aug 13 16:05:52 tsunami kernel: CPU:    1
Aug 13 16:05:52 tsunami kernel: EIP:    0060:[<c01f6269>]    Not  
tainted VLI
Aug 13 16:05:52 tsunami kernel: EFLAGS: 00010217   (2.6.18.3 #1)
Aug 13 16:05:52 tsunami kernel: EIP is at keyring_destroy+0x4c/0x73
Aug 13 16:05:52 tsunami kernel: eax: 00200200   ebx: f6d169c0   ecx:  
f6d16a18   edx: 00100100
Aug 13 16:05:52 tsunami kernel: esi: f6d169c0   edi: f7f60440   ebp:  
00000000   esp: f7feef2c
Aug 13 16:05:52 tsunami kernel: ds: 007b   es: 007b   ss: 0068
Aug 13 16:05:52 tsunami kernel: Process events/1 (pid: 9, ti=f7fee000  
task=f7f02070 task.ti=f7fee000)
Aug 13 16:05:52 tsunami kernel: Stack: f6d169c8 f6d169c0 c01f5c84  
c0341d00 c0341d04 c012b9ac f7f02180 00000001

Output copied from serial console (after file system no longer writes):

BUG: soft lockup detected on CPU#1!
  [<c0140977>] softlockup_tick+0x9a/0xbc
  [<c012575a>] update_process_times+0x56/0x79
  [<c010f97e>] smp_apic_timer_interrupt+0x5c/0x62
  [<c0104277>] apic_timer_interrupt+0x1f/0x24
  [<c022005d>] delay_tsc+0x9/0x13
  [<c0220092>] __delay+0x6/0x7
  [<c0221156>] __spin_lock_debug+0x3d/0xb8
  [<c022122a>] _raw_spin_lock+0x59/0x7d
  [<c01f579e>] key_alloc+0x192/0x34a
  [<c01f63b8>] keyring_alloc+0x30/0x72
  [<c01f7c48>] alloc_uid_keyring+0x48/0xab
  [<c0150daf>] __handle_mm_fault+0x1d6/0x255
  [<c0125eac>] alloc_uid+0xc6/0x150
  [<c0129874>] set_user+0xb/0x90
  [<c0129c65>] sys_setresuid+0x9e/0x1ed
  [<c0103741>] sysenter_past_esp+0x56/0x79
BUG: soft lockup detected on CPU#0!
  [<c0140977>] softlockup_tick+0x9a/0xbc
  [<c012575a>] update_process_times+0x56/0x79
  [<c010f97e>] smp_apic_timer_interrupt+0x5c/0x62
  [<c0104277>] apic_timer_interrupt+0x1f/0x24
  [<c022005f>] delay_tsc+0xb/0x13
  [<c0220092>] __delay+0x6/0x7
  [<c0221156>] __spin_lock_debug+0x3d/0xb8
  [<c022122a>] _raw_spin_lock+0x59/0x7d
  [<c01f579e>] key_alloc+0x192/0x34a
  [<c01f63b8>] keyring_alloc+0x30/0x72
  [<c01f7c48>] alloc_uid_keyring+0x48/0xab
  [<c0150daf>] __handle_mm_fault+0x1d6/0x255
  [<c0125eac>] alloc_uid+0xc6/0x150
  [<c0129874>] set_user+0xb/0x90
  [<c0129c65>] sys_setresuid+0x9e/0x1ed
  [<c0103741>] sysenter_past_esp+0x56/0x79

