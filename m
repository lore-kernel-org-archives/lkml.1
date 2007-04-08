Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbXDHUPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbXDHUPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 16:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXDHUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 16:15:31 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:64359 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXDHUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 16:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RqfNUbvQVTSBb/6gG/WQwp+S+7utmRp7p8794xc+Z3uEZstNdKgNKXnPhDz/6KLgAojwqVT99lm2jPjBECMFbCrk5svvD8bcVj7gl4ZdQBCLKiqDoqZmcp367axoI3j+O/Tzh4kI9TDTHvM0zvqP5LjN2IYRL2mWZwtEwIux+vE=
Message-ID: <19061b0b0704081315g3593d652s70e9b5b0dcfcf966@mail.gmail.com>
Date: Sun, 8 Apr 2007 22:15:28 +0200
From: Bartek <poemann@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070407.234708.93384523.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19061b0b0704071111m65c70d1ei736de86ad2f09a82@mail.gmail.com>
	 <20070407.234708.93384523.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Please reproduce and provide a new crash dump without the nvidia
> binary-only module loaded.

Hi again,

Here is a new crash dump (I also removed vmnet and vmmon properitary
modules), this time I also included a lspci output:

Apr  8 21:47:21 localhost pppd[2114]: rcvd [proto=0xfc3b] bc d4 80 eb
43 62 d0 7e 6d 27 0a e0 22 e4 8d e6 3e f1 a3 10 39 c8 fd cb e7 23 db
f1 cf a8 e0 4d ...
Apr  8 21:47:21 localhost pppd[2114]: Unsupported protocol 0xfc3b received
Apr  8 21:47:21 localhost pppd[2114]: sent [LCP ProtRej id=0x75 fc 3b
bc d4 80 eb 43 62 d0 7e 6d 27 0a e0 22 e4 8d e6 3e f1 a3 10 39 c8 fd
cb e7 23 db f1 cf a8 ...]
Apr  8 21:47:22 localhost pppd[2114]: rcvd [proto=0xcd] f7 4e 69 54 c1
d2 82 d3 bf 1c 33 46 a1 ee 90 97 14 7c a7 23 9d 84 c3 d4 ff 6c ec 25
a7 65 a3 bd ...
Apr  8 21:47:22 localhost pppd[2114]: Unsupported protocol 0xcd received
Apr  8 21:47:22 localhost pppd[2114]: sent [LCP ProtRej id=0x76 00 cd
f7 4e 69 54 c1 d2 82 d3 bf 1c 33 46 a1 ee 90 97 14 7c a7 23 9d 84 c3
d4 ff 6c ec 25 a7 65 ...]
Apr  8 21:47:22 localhost kernel: skb_under_panic: text:f8c3cc0e
len:1268 put:1 head:c399f800 data:c399f7ff tail:c399fcf3 end:c399fe00
dev:<NULL>
Apr  8 21:47:22 localhost kernel: ------------[ cut here ]------------
Apr  8 21:47:22 localhost kernel: kernel BUG at net/core/skbuff.c:111!
Apr  8 21:47:22 localhost kernel: invalid opcode: 0000 [#1]
Apr  8 21:47:22 localhost kernel: Modules linked in: nfs nfsd exportfs
lockd nfs_acl sunrpc button xt_TCPMSS xt_limit xt_tcpudp nf_nat_irc
nf_nat_ftp iptable_nat iptable_mangle ipt_LOG ipt_MASQUERADE nf_nat
ipt_TOS ipt_REJECT nf_conntrack_irc nf_conntrack_ftp nf_conntrack_ipv4
xt_state nf_conntrack nfnetlink iptable_filter ip_tables x_tables
ppp_async ipv6 ppp_generic slhc xfs eeprom w83781d w83627hf hwmon_vid
i2c_isa ide_generic snd_via82xx snd_ac97_codec ac97_bus snd_pcm
snd_timer snd_page_alloc i2c_viapro snd_mpu401_uart i2c_core via_ircc
snd_rawmidi snd_seq_device floppy snd serio_raw soundcore irda rtc
psmouse via_agp agpgart crc_ccitt pcspkr evdev ext3 jbd mbcache usbhid
ide_cd cdrom ide_disk generic uhci_hcd usbcore via82cxxx ide_core e100
mii thermal processor fan
Apr  8 21:47:22 localhost kernel: CPU:    0
Apr  8 21:47:22 localhost kernel: EIP:    0060:[<c021b4d7>]
Tainted: P       VLI
Apr  8 21:47:22 localhost kernel: EFLAGS: 00010096   (2.6.21-rc6 #3)
Apr  8 21:47:22 localhost kernel: EIP is at skb_under_panic+0x59/0x5d
Apr  8 21:47:22 localhost kernel: eax: 00000073   ebx: c399f800   ecx:
00000000   edx: 00000000
Apr  8 21:47:22 localhost kernel: esi: 00000000   edi: c399fcf5   ebp:
c399fcf1   esp: c1ce5ed8
Apr  8 21:47:22 localhost kernel: ds: 007b   es: 007b   fs: 00d8  gs:
0000  ss: 0068
Apr  8 21:47:22 localhost kernel: Process events/0 (pid: 3,
ti=c1ce4000 task=dfd02030 task.ti=c1ce4000)
Apr  8 21:47:22 localhost kernel: Stack: c02c47d0 f8c3cc0e 000004f4
00000001 c399f800 c399f7ff c399fcf3 c399fe00
Apr  8 21:47:22 localhost kernel:        c02b7ed8 f7ef5600 000000ff
f8c3cc13 ffffffff dfff5c20 c1fee800 00000208
Apr  8 21:47:22 localhost kernel:        c1fee5ad c1fee4ad c1fee800
00000202 dfd7ce00 00000004 c1fee400 c1fee80c
Apr  8 21:47:22 localhost kernel: Call Trace:
Apr  8 21:47:22 localhost kernel:  [<f8c3cc0e>]
ppp_asynctty_receive+0x3b0/0x584 [ppp_async]
Apr  8 21:47:22 localhost kernel:  [<f8c3cc13>]
ppp_asynctty_receive+0x3b5/0x584 [ppp_async]
Apr  8 21:47:22 localhost kernel:  [<c01eacd2>] flush_to_ldisc+0xe6/0x124
Apr  8 21:47:22 localhost kernel:  [<c01eabec>] flush_to_ldisc+0x0/0x124
Apr  8 21:47:22 localhost kernel:  [<c0122b7f>] run_workqueue+0x70/0x101
Apr  8 21:47:22 localhost kernel:  [<c01230c8>] worker_thread+0x105/0x12e
Apr  8 21:47:22 localhost kernel:  [<c0114c86>] default_wake_function+0x0/0xc
Apr  8 21:47:22 localhost kernel:  [<c0122fc3>] worker_thread+0x0/0x12e
Apr  8 21:47:23 localhost kernel:  [<c012528c>] kthread+0xa0/0xc8
Apr  8 21:47:23 localhost kernel:  [<c01251ec>] kthread+0x0/0xc8
Apr  8 21:47:23 localhost kernel:  [<c0104657>] kernel_thread_helper+0x7/0x10
Apr  8 21:47:23 localhost kernel:  =======================
Apr  8 21:47:23 localhost kernel: Code: 00 00 89 5c 24 14 8b 98 a0 00
00 00 89 54 24 0c 89 5c 24 10 8b 40 60 89 4c 24 04 c7 04 24 d0 47 2c
c0 89 44 24 08 e8 af c5 ef ff <0f> 0b eb fe 56 53 bb d8 7e 2b c0 83 ec
24 8b 70 14 85 f6 0f 45
Apr  8 21:47:23 localhost kernel: EIP: [<c021b4d7>]
skb_under_panic+0x59/0x5d SS:ESP 0068:c1ce5ed8
Apr  8 21:48:01 localhost /USR/SBIN/CRON[6287]: (root) CMD
(/usr/local/bin/pppd_test.sh)
Apr  8 21:48:09 localhost pppd[2114]: No response to 5 echo-requests
Apr  8 21:48:09 localhost pppd[2114]: Serial link appears to be disconnected.
Apr  8 21:48:09 localhost pppd[2114]: Connect time 522.7 minutes.
Apr  8 21:48:09 localhost pppd[2114]: Sent 57811374 bytes, received
186299345 bytes.
Apr  8 21:48:09 localhost pppd[2114]: Script /etc/ppp/ip-down started (pid 6289)
Apr  8 21:48:09 localhost pppd[2114]: sent [LCP TermReq id=0x77 "Peer
not responding"]
Apr  8 21:48:09 localhost pppd[2114]: Script /etc/ppp/ip-down finished
(pid 6289), status = 0x0
Apr  8 21:48:12 localhost pppd[2114]: sent [LCP TermReq id=0x78 "Peer
not responding"]
Apr  8 21:48:15 localhost pppd[2114]: Connection terminated.
Apr  8 21:49:04 localhost /usr/sbin/gpm[3303]: oops() invoked from gpm.c(159)
Apr  8 21:49:04 localhost /usr/sbin/gpm[3303]: /dev/tty0: Input/output error
Apr  8 21:49:17 localhost init: open(/dev/console): Input/output error
Apr  8 21:49:17 localhost shutdown[6328]: shutting down for system reboot
Apr  8 21:49:18 localhost init: Switching to runlevel: 6
Apr  8 21:49:27 localhost kernel: SysRq : Emergency Remount R/O

The output of lspci -vvv

00:00.0 Host bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo
KT266/A/333 AGP] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: dda00000-dfafffff
	Prefetchable memory behind bridge: cd800000-dd8fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:06.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro
100] (rev 08)
	Subsystem: Compaq Computer Corporation NC3123 Fast Ethernet NIC (WOL)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 12
	Region 0: Memory at dffbf000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at d800 [size=64]
	Region 2: Memory at dfe00000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at dfd00000 [disabled] [size=1M]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:11.0 ISA bridge: VIA Technologies, Inc. VT8233 PCI to ISA Bridge
	Subsystem: VIA Technologies, Inc. VT8233 PCI to ISA Bridge
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
	Subsystem: VIA Technologies, Inc.
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at ff00 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 18) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 5
	Region 4: I/O ports at c800 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 18) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 5
	Region 4: I/O ports at cc00 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.4 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 18) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 5
	Region 4: I/O ports at d000 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 10)
	Subsystem: Micro-Star International Co., Ltd. KT266 onboard audio
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin C routed to IRQ 10
	Region 0: I/O ports at d400 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: nVidia Corporation NV11DDR
[GeForce2 MX 100 DDR/200 DDR] (rev b2) (prog-if 00 [VGA])
	Subsystem: LeadTek Research Inc. Unknown device 2838
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (1250ns min, 250ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Expansion ROM at dfaf0000 [disabled] [size=64K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [44] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh- GART64- HTrans- 64bit-
FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

Bartek
