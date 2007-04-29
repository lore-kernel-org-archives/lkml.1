Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXD2MAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXD2MAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXD2MAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:00:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:6006 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbXD2MAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:mime-version:content-type:message-id:from;
        b=BwlgY6mBuzor+8yvtrQ97NhF/SFVsICFSXNz+DdFRxovqJyYmuLyVqEBC7ZP2fZglG+pxlJZ0c6mauVZKyJpZRE4sMz3UIxkFjuuTVsjgQPlqIKOPYh+kXZ0hWBDMKpq9Xkm+ACHAY7OSFkGshOVq+1eIOMHj45Dqypy1Q89wgE=
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: oops in 2.6.21.1 after bringing up the network
Date: Mon, 30 Apr 2007 00:00:24 +1200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ZjINGycv5zbzl/s"
Message-Id: <200704300000.25594.b.n.ryland@massey.ac.nz>
From: Brett Ryland <nappers@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ZjINGycv5zbzl/s
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I am consistently getting a kernel oops from a vanilla 2.6.21.1 kernel. It 
also occurs in vanilla 2.6.21, but not in 2.6.20.8. The relevant section of 
the kernel is networking, in particular the sis900 module (I think).
The attached file contains the oops and the information asked for on the site 
http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html for reporting 
kernel oopses. The oops fully crashes my computer and leaves the capslock and 
numlock leds flashing, so the oops is transcribed by hand from a photo 
(hopefully I haven't made a mistake, I do still have the photo if it's 
needed).

I'm not subscribed to the mailing list so please CC any questions/solutions to 
me.

Regards,
Nappers.

--Boundary-00=_ZjINGycv5zbzl/s
Content-Type: text/plain;
  charset="us-ascii";
  name="kernel_bug_report"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel_bug_report"

Output of OOPS:

<- snip ->
ifup eth0
Internet Software Consortium DHCP Client 2.0pl5
Copyright 1995, 1996, 1997, 1998, 1999 The Internet Software Consortium.
All rights reserved.

Please contribute if you find this software useful.
For info, please visit http://www.isc.org/dhcp-contrib.html

sit0: unknown hardware address type 776
sit0: unknown hardware address type 776
Listening on LPF/eth0/00:50:eb:37:2f:26
Sending on   LPF/eth0/00:50:eb:37:2f:26
Sending on   Socket/fallback/fallback-net
DHCPREQUEST on eth0 to 255.255.255.255 port 67
eth0: Media Link On 100mbps full-duplex
DHCPACK from 10.1.1.1
bound to 10.1.1.3 -- renewal in 147600 seconds.
Starting NTP server: ntpd.
skb_over_panic: text:e1894a5e len:1084 put:132 head:d699a000 data:d699a024 tail:d699a460 end:d699a400 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:93
invalid opcode:0000 [#1]
PREEMPT
Modules linked in: xt_multiport dazuko fan button ac battery autofs4 nf_conntrack_ftp nf_conntrack_irc xt_tcpudp ipt_ULOG xt_limit xt_state iptable_filter nf_conntrack_ipv4 nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative commoncap pcmcia irtty_sir ehci_hcd ohci_hcd sir_dev usbcore ohci1394 ieee1394 sis900 yenta_socket rorc_nonstatic pcmcia_core snd_intel8q0 snd_ac97_codec ac97_bus joydev
CPU:    0
EIP:    0060:[<c02f5643>]    Not tainted VLI
EFLAGS: 00010296   (2.6.21.1 #4)
EUP is at skb_over_panic+0x59/0x5d
eax: 00000074   ebx: d699a000   ecx: c0468f80   edx: c0468f80
esi: 00000000   edi: 98800088   ebp: 00000000   esp: c0497edc
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c0496000 task=c0464420 task.ti=c0496000)
Stack: c043d180 e1894a5e 0000043c 00000084 d699a000 d699a024 d699a460 d699a400
       c041eed2 d6c31680 df2cab40 e1894a69 ffffffff c0497f38 c011778c 00000000
       00000000 df2ca800 df2cab40 00000028 00000049 00000084 00000088 0000000f
Call Trace:
 [<e1894a5e>] sis900_interrupt+0x628/0x6a0 [sis900]
 [<e1894a69>] sis900_interrupt+0x633/0x6a0 [sis900]
 [<c011778c>] try_to_wake_up+0x122/0x160
 [<c013f8e9>] handle_IRQ_event+0x25/0x4a
 [<c0140d21>] handle_level_irp+0x79/0x102
 [<c01064b5>] do_IRQ+0x3b/0x76
 [<c0104803>] common_interrupt+0x23/0x28
 [<c0102a14>] default_idle+0x2a/0x39
 [<c010233b>] cpu_idle+0x3e/0x6e
 [<c0498b68>] start_kernel+0x324/0x3ec
 [<c049844d>] unxnown_bootoption+0x0/0x259
 =======================
Code: 00 00 89 5c 24 14 8b 98 94 00 00 00 89 5c 24 10 89 54 24 0c 8b 40 60 89 44 24 08 89 4c 24 04 c7 04 24 80 d1 43 c0 e8 be 5b e2 ff <0f> 0b eb fe 55 57 56 53 83 ec 34 89 44 24 24 89 54 24 20 89 4c
EIP: [<c02f5643>] skb_over_panic+0x59/0x5d SS:ESP 0068:c0497edc
Kernel panic - not syncing: Fatal exception in interrupt
_
<- snip ->

A very similar OOPS occurs if ntpd is not started, but a ping is sent out instead. After 5 pings the OOPS occurs with:
<- snip ->
EIP:    0060[<c02fa5c3>]    Not tainted VLI
EFLAGS: 00010046   (2.6.21.1 #4)
EIP si at netif_rx+0x45/0xb7
<- snip ->
the call trace is the same but with the first two lines replaced by the single line:
 [<e18b8630>] sis900_interrupt+0x1fa/0x6a0 [sis900]

----
Output of "scripts/ver_linux":
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux xp000690 2.6.21.1 #4 PREEMPT Sun Apr 29 16:38:15 NZST 2007 i686 GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
reiser4progs           1.0.5
pcmciautils            014
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
wireless-tools         28
Modules Loaded         xt_multiport dazuko fan button ac battery autofs4 nf_conntrack_ftp nf_conntrack_irc xt_tcpudp ipt_ULOG xt_limit xt_state iptable_filter nf_conntrack_ipv4 nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative commoncap pcmcia irtty_sir ehci_hcd ohci_hcd sir_dev usbcore ohci1394 ieee1394 sis900 yenta_socket rsrc_nonstatic pcmcia_core snd_intel8x0 snd_ac97_codec ac97_bus joydev
----
Output of "cat /proc/version":

Linux version 2.6.21.1 (root@xp000690) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #4 PREEMPT Sun Apr 29 16:38:15 NZST 2007
----
Output of "cat /proc/cpuinfo":

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 2.66GHz
stepping	: 7
cpu MHz		: 2666.600
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
bogomips	: 5313.48
clflush size	: 64
----
Output of "cat /proc/modules":

xt_multiport 3328 1 - Live 0xe19e7000
dazuko 51784 6 - Live 0xe1a3c000
fan 4996 0 - Live 0xe1a28000
button 8080 0 - Live 0xe1a16000
ac 5380 0 - Live 0xe1a19000
battery 10244 0 - Live 0xe1a0e000
autofs4 22020 1 - Live 0xe1a1e000
nf_conntrack_ftp 9600 0 - Live 0xe1a12000
nf_conntrack_irc 7320 0 - Live 0xe19dc000
xt_tcpudp 3456 74 - Live 0xe19e5000
ipt_ULOG 8196 31 - Live 0xe19e9000
xt_limit 2816 36 - Live 0xe19e3000
xt_state 2688 71 - Live 0xe19e1000
iptable_filter 3200 1 - Live 0xe19df000
nf_conntrack_ipv4 16140 71 - Live 0xe19d1000
nf_conntrack 55368 4 nf_conntrack_ftp,nf_conntrack_irc,xt_state,nf_conntrack_ipv4, Live 0xe19ee000
ip_tables 12104 1 iptable_filter, Live 0xe19c4000
x_tables 15236 6 xt_multiport,xt_tcpudp,ipt_ULOG,xt_limit,xt_state,ip_tables, Live 0xe19d7000
cpufreq_ondemand 7804 0 - Live 0xe19ce000
cpufreq_conservative 6688 0 - Live 0xe19cb000
commoncap 7168 1 dazuko, Live 0xe19c8000
pcmcia 28704 0 - Live 0xe1920000
irtty_sir 8448 0 - Live 0xe18d4000
ehci_hcd 33932 0 - Live 0xe18ea000
ohci_hcd 21508 0 - Live 0xe18d8000
sir_dev 15876 1 irtty_sir, Live 0xe18a4000
usbcore 125592 3 ehci_hcd,ohci_hcd, Live 0xe18f6000
ohci1394 35248 0 - Live 0xe18aa000
ieee1394 94648 1 ohci1394, Live 0xe18b7000
sis900 22528 0 - Live 0xe1893000
yenta_socket 25996 1 - Live 0xe188b000
rsrc_nonstatic 12672 1 yenta_socket, Live 0xe0839000
pcmcia_core 38416 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xe081e000
snd_intel8x0 33052 0 - Live 0xe082a000
snd_ac97_codec 95268 1 snd_intel8x0, Live 0xe0861000
ac97_bus 2432 1 snd_ac97_codec, Live 0xe0817000
joydev 9920 0 - Live 0xe081a000
----
Output of "cat /proc/ioports":

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
0170-0177 : 0000:00:02.5
  0170-0177 : ide1
01f0-01f7 : 0000:00:02.5
  01f0-01f7 : ide0
02f8-02ff : serial
0376-0376 : 0000:00:02.5
  0376-0376 : ide1
03f6-03f6 : 0000:00:02.5
  03f6-03f6 : ide0
04d0-04d1 : pnp 00:06
0cf8-0cff : PCI conf1
1080-10ff : 0000:00:02.7
  1080-10ff : SiS SI7012
1400-14ff : 0000:00:02.7
  1400-14ff : SiS SI7012
1800-18ff : 0000:00:02.6
1c00-1c7f : 0000:00:02.6
2000-200f : 0000:00:02.5
  2000-2007 : ide0
  2008-200f : ide1
2400-24ff : PCI CardBus #02
2800-28ff : PCI CardBus #02
8000-808f : pnp 00:06
  8000-807f : pnp 00:06
    8000-8003 : ACPI PM1a_EVT_BLK
    8004-8005 : ACPI PM1a_CNT_BLK
    8008-800b : ACPI PM_TMR
    8020-8023 : ACPI GPE0_BLK
    8030-8033 : ACPI GPE1_BLK
8090-80ff : pnp 00:06
8100-811f : 0000:00:02.1
  8100-811f : sis96x_smbus
9000-9fff : PCI Bus #01
  9000-90ff : 0000:01:00.0
f800-f8ff : 0000:00:04.0
  f800-f8ff : sis900
fe00-fe00 : pnp 00:06
----
Output of "cat /proc/iomem":

00000000-0009f3ff : System RAM
  00000000-00000000 : Crash kernel
0009f400-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000d0000-000d7fff : reserved
000f0000-000fffff : System ROM
00100000-1fdeffff : System RAM
  00100000-003b31a2 : Kernel code
  003b31a3-00495c2f : Kernel data
1fdf0000-1fdfafff : ACPI Tables
1fdfb000-1fdfffff : ACPI Non-volatile Storage
1fe00000-1fffffff : reserved
30000000-33ffffff : PCI CardBus #02
34000000-37ffffff : PCI CardBus #02
38000000-3801ffff : 0000:00:02.3
38020000-3803ffff : 0000:00:04.0
38040000-38040fff : 0000:00:0a.0
  38040000-38040fff : yenta_socket
e0000000-e7ffffff : 0000:00:00.0
e8000000-e8000fff : 0000:00:02.3
  e8000000-e80007ff : ohci1394
e8001000-e8001fff : 0000:00:03.0
  e8001000-e8001fff : ohci_hcd
e8002000-e8002fff : 0000:00:03.1
  e8002000-e8002fff : ohci_hcd
e8003000-e8003fff : 0000:00:03.2
  e8003000-e8003fff : ohci_hcd
e8004000-e8004fff : 0000:00:03.3
  e8004000-e8004fff : ehci_hcd
e8005000-e8005fff : 0000:00:04.0
  e8005000-e8005fff : sis900
e8100000-e81fffff : PCI Bus #01
  e8100000-e810ffff : 0000:01:00.0
    e8100000-e810ffff : radeonfb mmio
  e8120000-e813ffff : 0000:01:00.0
f0000000-f7ffffff : PCI Bus #01
  f0000000-f7ffffff : 0000:01:00.0
    f0000000-f7ffffff : radeonfb framebuffer
fec00000-fec0ffff : reserved
fee00000-fee00fff : reserved
ffc00000-ffc00fff : pnp 00:06
ffe00000-ffe00fff : pnp 00:06
fff80000-ffffffff : reserved
----
Output of "lspci -vvv":

00:00.0 Host bridge: Silicon Integrated Systems [SiS] SiS645DX Host & Memory & AGP Controller (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 64
	Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=128M]
	Capabilities: [c0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual PCI-to-PCI bridge (AGP) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 99
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: e8100000-e81fffff
	Prefetchable memory behind bridge: f0000000-f7ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS962 [MuTIOL Media IO] (rev 14)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 0
	Region 4: I/O ports at 8100 [size=32]

00:02.3 FireWire (IEEE 1394): Silicon Integrated Systems [SiS] FireWire Controller (prog-if 10 [OHCI])
	Subsystem: Silicon Integrated Systems [SiS] Unknown device 1394
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (1000ns min, 3000ns max)
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at e8000000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 38000000 [disabled] [size=128K]
	Capabilities: [64] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (prog-if 80 [Master])
	Subsystem: Silicon Integrated Systems [SiS] SiS5513 EIDE Controller (A,B step)
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128
	Interrupt: pin ? routed to IRQ 10
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at 2000 [size=16]

00:02.6 Modem: Silicon Integrated Systems [SiS] AC'97 Modem Controller (rev a0) (prog-if 00 [Generic])
	Subsystem: Elitegroup Computer Systems Unknown device b732
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin C routed to IRQ 9
	Region 0: I/O ports at 1800 [size=256]
	Region 1: I/O ports at 1c00 [size=128]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS] AC'97 Sound Controller (rev a0)
	Subsystem: Elitegroup Computer Systems Unknown device b732
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 173 (13000ns min, 2750ns max)
	Interrupt: pin C routed to IRQ 9
	Region 0: I/O ports at 1400 [size=256]
	Region 1: I/O ports at 1080 [size=128]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: Silicon Integrated Systems [SiS] USB 1.0 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (20000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at e8001000 (32-bit, non-prefetchable) [size=4K]

00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: Silicon Integrated Systems [SiS] USB 1.0 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (20000ns max)
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at e8002000 (32-bit, non-prefetchable) [size=4K]

00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: Silicon Integrated Systems [SiS] USB 1.0 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (20000ns max)
	Interrupt: pin C routed to IRQ 10
	Region 0: Memory at e8003000 (32-bit, non-prefetchable) [size=4K]

00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller (prog-if 20 [EHCI])
	Subsystem: Elitegroup Computer Systems Unknown device b732
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (20000ns max)
	Interrupt: pin D routed to IRQ 5
	Region 0: Memory at e8004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI Fast Ethernet (rev 91)
	Subsystem: Elitegroup Computer Systems Unknown device b732
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 173 (13000ns min, 2750ns max)
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at f800 [size=256]
	Region 1: Memory at e8005000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 38020000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller
	Subsystem: Elitegroup Computer Systems Unknown device b732
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 38040000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 30000000-33fff000 (prefetchable)
	Memory window 1: 34000000-37fff000
	I/O window 0: 00002400-000024ff
	I/O window 1: 00002800-000028ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250 [Mobility FireGL 9000] (rev 01) (prog-if 00 [VGA])
	Subsystem: Elitegroup Computer Systems Unknown device b732
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at 9000 [size=256]
	Region 2: Memory at e8100000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at e8120000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
		Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

----
Output of "cat /proc/scsi/scsi":

Attached devices:
----
Appropriate section of /etc/network/interfaces:

iface eth0 inet dhcp
	post-up /etc/init.d/ntp start
	down /etc/init.d/ntp stop
----

--Boundary-00=_ZjINGycv5zbzl/s--
