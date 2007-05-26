Return-Path: <linux-kernel-owner+w=401wt.eu-S1761958AbXEZPp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958AbXEZPp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXEZPpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:45:49 -0400
Received: from v6.netlin.pl ([62.121.136.6]:42559 "EHLO pointblue.com.pl"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbXEZPps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:45:48 -0400
From: Tommy Vercetti <vercetti@zlew.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Date: Sat, 26 May 2007 17:46:01 +0200
User-Agent: KMail/1.9.3
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200705261505.38109@gj-laptop> <2c0942db0705260813g6aeedbfepc0afa94ba3550e5b@mail.gmail.com>
In-Reply-To: <2c0942db0705260813g6aeedbfepc0afa94ba3550e5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261746.01568@gj-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in terms of driver, what do you mean ?
this is my lspci:
00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller 
(rev 21)
00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 
21)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #2 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI 
Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge 
(rev 03)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 
03)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 
Modem Controller (rev 03)
01:00.0 VGA compatible controller: nVidia Corporation NV34M [GeForce FX 
Go5200] (rev a1)
02:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 
Controller (PHY/Link)
02:08.0 Ethernet controller: Intel Corporation 82801DB PRO/100 VE (MOB) 
Ethernet Controller (rev 83)
02:0a.0 Network controller: Intel Corporation PRO/Wireless LAN 2100 3B Mini 
PCI Adapter (rev 04)
02:0b.0 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbus 
Bridge with ZV Support (rev 33)
02:0d.0 System peripheral: Toshiba America Info Systems SD TypA Controller 
(rev 05)
03:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC 
(rev 01)


modules list, and config on request (don't want to pollute devs mailboxes).

/dev/hda:
 Timing cached reads:   732 MB in  2.00 seconds = 365.74 MB/sec
 Timing buffered disk reads:   76 MB in  3.00 seconds =  25.31 MB/sec
root@puppet:~# htparm -i -v /dev/hda
-su: htparm: command not found
root@puppet:~# hdparm -i -v /dev/hda

/dev/hda:
 multcount    = 16 (on)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 65535/16/63, sectors = 156301488, start = 0

 Model=TOSHIBA MK8025GAS, FwRev=KA023A, SerialNo=95NX6153S
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=48
 BuffType=unknown, BuffSize=0kB, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=156301488
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  sdma0 sdma1 sdma2 mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5 udma3 udma4 *udma5
 AdvancedPM=yes: unknown setting WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-1 ATA/ATAPI-2 ATA/ATAPI-3 
ATA/ATAPI-4 ATA/ATAPI-5 ATA/ATAPI-6

 * signifies the current active mode




-- 
Vercetti
