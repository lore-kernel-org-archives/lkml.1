Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZBVWVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZBVWVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZBVWVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:21:24 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35432 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZBVWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:21:23 -0500
Date: Sun, 22 Feb 2009 22:21:19 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090222222119.GA20224@silver.sucs.org>
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A1CA01.9030501@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 10:56:17PM +0100, Jiri Slaby wrote:
> Could you append lspci -vvnnxxx of your adapter? Better along with 
> ath_info[1] output.

lspci -vvnnxxx
00:00.0 Host bridge [0600]: Intel Corporation Mobile 915GM/PM/GMS/910GML Express Processor to DRAM Controller [8086:2590] (rev 04)
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d9]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: <access denied>
00: 86 80 90 25 06 00 90 20 04 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 d9 82
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller [8086:2592] (rev 04) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d9]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f7f00000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at ec00 [size=8]
	Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at f7ec0000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: <access denied>
00: 86 80 92 25 07 00 90 00 04 00 00 03 00 00 80 00
10: 00 00 f0 f7 01 ec 00 00 08 00 00 d0 00 00 ec f7
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 d9 82
30: 00 00 00 00 d0 00 00 00 00 00 00 00 05 01 00 00

00:02.1 Display controller [0380]: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller [8086:2792] (rev 04)
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d9]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at f7f80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>
00: 86 80 92 27 07 00 90 00 04 00 80 03 00 00 80 00
10: 00 00 f8 f7 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 d9 82
30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00

00:1b.0 Audio device [0403]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) High Definition Audio Controller [8086:2668] (rev 04)
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:8337]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f7eb8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
00: 86 80 68 26 06 00 10 00 04 00 03 04 04 00 00 00
10: 04 80 eb f7 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 37 83
30: 00 00 00 00 50 00 00 00 00 00 00 00 05 01 00 00

00:1c.0 PCI bridge [0604]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 1 [8086:2660] (rev 04) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 60 26 04 05 10 00 04 00 04 06 04 00 81 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 f0 00 00 20
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 06 00

00:1c.1 PCI bridge [0604]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 2 [8086:2662] (rev 04) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: fbf00000-fbffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 62 26 06 05 10 00 04 00 04 06 04 00 81 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 f0 00 00 20
20: f0 fb f0 fb f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 02 06 00

00:1c.2 PCI bridge [0604]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 3 [8086:2664] (rev 04) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Bus: primary=00, secondary=01, subordinate=02, sec-latency=0
	Memory behind bridge: f8000000-fbefffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f6ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 64 26 06 05 10 00 04 00 04 06 04 00 81 00
10: 00 00 00 00 00 00 00 00 00 01 02 00 f0 00 00 20
20: 00 f8 e0 fb 01 f0 f1 f6 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 03 06 00

00:1d.0 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 [8086:2658] (rev 04) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d8]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at e400 [size=32]
00: 86 80 58 26 05 00 80 02 04 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 e4 00 00 00 00 00 00 00 00 00 00 43 10 d8 82
30: 00 00 00 00 00 00 00 00 00 00 00 00 03 01 00 00

00:1d.1 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 [8086:2659] (rev 04) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d8]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at e480 [size=32]
00: 86 80 59 26 05 00 80 02 04 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 e4 00 00 00 00 00 00 00 00 00 00 43 10 d8 82
30: 00 00 00 00 00 00 00 00 00 00 00 00 07 02 00 00

00:1d.2 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 [8086:265a] (rev 04) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d8]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at e800 [size=32]
00: 86 80 5a 26 05 00 80 02 04 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 e8 00 00 00 00 00 00 00 00 00 00 43 10 d8 82
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 03 00 00

00:1d.3 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 [8086:265b] (rev 04) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d8]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at e880 [size=32]
00: 86 80 5b 26 05 00 80 02 04 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 e8 00 00 00 00 00 00 00 00 00 00 43 10 d8 82
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 04 00 00

00:1d.7 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller [8086:265c] (rev 04) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d8]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f7eb7c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
00: 86 80 5c 26 06 00 90 02 04 20 03 0c 00 00 00 00
10: 00 7c eb f7 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 d8 82
30: 00 00 00 00 50 00 00 00 00 00 00 00 03 01 00 00

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev d4) (prog-if 01 [Subtractive decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 48 24 04 01 10 00 d4 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 05 05 20 f0 00 80 22
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 06 00

00:1f.0 ISA bridge [0601]: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge [8086:2641] (rev 04)
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d8]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
00: 86 80 41 26 07 00 00 02 04 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 d8 82
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:1f.2 IDE interface [0101]: Intel Corporation 82801FBM (ICH6M) SATA Controller [8086:2653] (rev 04) (prog-if 80 [Master])
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d8]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ffa0 [size=16]
	Capabilities: <access denied>
00: 86 80 53 26 05 00 b0 02 04 80 01 01 00 00 00 00
10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00
20: a1 ff 00 00 00 00 00 00 00 00 00 00 43 10 d8 82
30: 00 00 00 00 70 00 00 00 00 00 00 00 00 02 00 00

00:1f.3 SMBus [0c05]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus Controller [8086:266a] (rev 04)
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:82d8]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 0
	Region 4: I/O ports at 0400 [size=32]
00: 86 80 6a 26 01 00 80 02 04 00 05 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 04 00 00 00 00 00 00 00 00 00 00 43 10 d8 82
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00

01:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
	Subsystem: Unknown device [1a3b:1026]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fbef0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
00: 8c 16 1c 00 07 00 10 00 01 00 00 02 04 00 00 00
10: 04 00 ef fb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 01 50 00 00 3b 1a 26 10
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00

03:00.0 Ethernet controller [0200]: Attansic Technology Corp. L2 100 Mbit Ethernet Adapter [1969:2048] (rev a0)
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:8233]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 27
	Region 0: Memory at fbfc0000 (64-bit, non-prefetchable) [size=256K]
	Expansion ROM at fbfa0000 [disabled] [size=128K]
	Capabilities: <access denied>
00: 69 19 48 20 06 04 10 00 a0 00 00 02 04 00 00 00
10: 04 00 fc fb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 33 82
30: 00 00 fa fb 40 00 00 00 00 00 00 00 0b 01 00 00

(I'm currently not on the problem network)
./ath_info fbef0000
sleep_ctl reg 00000000   reset_ctl reg 00000000
 -==Device Information==-
MAC Revision: 2425  (0xe2)
Warning: Invalid EEPROM Magic number!
Device type:  3

/============== EEPROM Information =============\
| EEPROM Version:   5.3 | EEPROM Size:   4 kbit |
| EEMAP:              2 | Reg. Domain:     0x60 |
|================= Capabilities ================|
| 802.11a Support:  no  | Turbo-A disabled: yes |
| 802.11b Support:  no  | Turbo-G disabled: yes |
| 802.11g Support:  yes | 2GHz XR disabled: yes |
| RFKill  Support:  yes | 5GHz XR disabled: yes |
| 32kHz   Crystal:  no  |                       |
\===============================================/

/=========================================================\
|          Calibration data common for all modes          |
|=========================================================|
|          CCK/OFDM gain delta:             1             |
|          CCK/OFDM power delta:            5             |
|          Scaled CCK delta:                5             |
|          2GHz Antenna gain:               1             |
|          5GHz Antenna gain:               4             |
|          Turbo 2W maximum dBm:           38             |
|          Target power start:          0x16e             |
|          EAR Start:                   0x1b8             |
\=========================================================/

/=========================================================\
|          Calibration data for 802.11g operation         |
|=========================================================|
| I power:              0x00 | Q power:              0x13 |
| Use fixed bias:       0x01 | Max turbo power:      0x26 |
| Max XR power:         0x20 | Switch Settling Time: 0x28 |
| Tx/Rx attenuation:    0x19 | TX end to XLNA On:    0x00 |
| TX end to XPA Off:    0x00 | TX end to XPA On:     0x0e |
| 62db Threshold:       0x1c | XLNA gain:            0x00 |
| XPD:                  0x01 | XPD gain:             0x0a |
| I gain:               0x00 | Tx/Rx margin:         0x01 |
| False detect backoff: 0x00 | Noise Floor Threshold:  -1 |
| ADC desired size:      -38 | PGA desired size:      -80 |
|=========================================================|
| Antenna control   0:  0x00 | Antenna control   1:  0x01 |
| Antenna control   2:  0x22 | Antenna control   3:  0x22 |
| Antenna control   4:  0x00 | Antenna control   5:  0x00 |
| Antenna control   6:  0x02 | Antenna control   7:  0x21 |
| Antenna control   8:  0x21 | Antenna control   9:  0x00 |
| Antenna control  10:  0x00 | Antenna control  11:  0x02 |
|=========================================================|
| Octave Band 0:           3 | db 0:                    3 |
| Octave Band 1:           4 | db 1:                    4 |
| Octave Band 2:           0 | db 2:                    0 |
| Octave Band 3:           0 | db 3:                    0 |
\=========================================================/
/==================== Turbo mode infos ===================\
| Switch Settling time: 0x28 | Tx/Rx margin:         0x01 |
| Tx/Rx attenuation:    0x19 | ADC desired size:      -32 |
| PGA desired size:      -80 |                            |
\=========================================================/
/============== Per rate power calibration ===========\
| Freq | 6-24Mbit/s | 36Mbit/s |  48Mbit/s | 54Mbit/s |
|======|============|==========|===========|==========|
| 2412 |    16.00   |  15.00   |   14.00   |  13.00   |
|======|============|==========|===========|==========|
| 2437 |    16.00   |  15.00   |   14.00   |  13.00   |
|======|============|==========|===========|==========|
| 2472 |    16.00   |  15.00   |   14.00   |  13.00   |
\=====================================================/
/====================== Per channel power calibration ===================\
| Freq |  pwr_i  |    pwr_0    |    pwr_1    |    pwr_2    |    pwr_3    |
|      | pddac_i |   pddac_0   |   pddac_1   |   pddac_2   |   pddac_3   |
|======|=========|=============|=============|=============|=============|
| 2412 |         |             |             |             |             |
|------|---------|-------------|-------------|-------------|-------------|
|      |     0   |     4.00    |     8.50    |    12.50    |     0.00    |
|      |    10   |       15    |       47    |       83    |        0    |
|------|---------|-------------|-------------|-------------|-------------|
|      |    10   |    13.00    |    16.00    |    18.00    |    20.50    |
|      |    12   |       23    |       38    |       52    |       67    |
|======|=========|=============|=============|=============|=============|
| 2472 |         |             |             |             |             |
|------|---------|-------------|-------------|-------------|-------------|
|      |     0   |     4.00    |     8.50    |    13.00    |     0.00    |
|      |    10   |       15    |       25    |       61    |        0    |
|------|---------|-------------|-------------|-------------|-------------|
|      |    10   |    13.00    |    16.00    |    19.00    |    20.50    |
|      |     9   |       18    |       33    |       45    |       46    |
|======|=========|=============|=============|=============|=============|
| 2484 |         |             |             |             |             |
|------|---------|-------------|-------------|-------------|-------------|
|      |     0   |     4.00    |     8.50    |    13.00    |     0.00    |
|      |    10   |       15    |       20    |       55    |        0    |
|------|---------|-------------|-------------|-------------|-------------|
|      |    10   |    12.50    |    16.00    |    19.00    |    20.00    |
|      |     9   |       16    |       31    |       40    |        0    |
\========================================================================/

GPIO registers: CR 0x00000000, DO 0x00000000, DI 0x00000003
STA_ID0: 00:15:af:b6:12:07
STA_ID1: 0x10000712, AP: 0, IBSS: 0, KeyCache Disable: 0
TIMER0: 0x00000528, TBTT:  1320, TU: 0x109d0528
TIMER1: 0x000000e2, DMAb:    28, TU: 0x109d001c (-1292)
TIMER2: 0x000c00d0, SWBA: 32794, TU: 0x10c1801a (+2390770)
TIMER3: 0x000000e2, ATIM:   226, TU: 0x109d00e2 (-1094)
TSF: 0x0000004273c1c15f, TSFTU: 61552, TU: 0x109cf070
BEACON: 0x00108000
LAST_TSTP: 0x73c16196

-- 
Sitsofe | http://sucs.org/~sits/
