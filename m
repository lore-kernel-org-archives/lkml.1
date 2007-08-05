Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXHEQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXHEQdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXHEQd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:33:27 -0400
Received: from bram.avontuur.org ([84.244.182.76]:34076 "EHLO
	bram.avontuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXHEQd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:33:26 -0400
X-Greylist: delayed 2049 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2007 12:33:26 EDT
Date: Sun, 5 Aug 2007 17:59:16 +0200
From: Bram <bram@linux.kernel.as.avontuur.org>
To: linux-kernel@vger.kernel.org
Subject: Possible bug in realtek 8169 ethernet driver
Message-ID: <20070805155915.GM2761@avontuur.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Verification-Tag: brama@localhost
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On my system running linux kernel 2.6.21.5, I can't get my ethernet card
to work. When loading the r8169 module, it will claim to be detected as
eth0, but it will show up as eth2 in ifconfig. There are no eth0 or eth1
devices though. It doesn't work as eth2 either. 

The router attached to it indicates a 100mbit link. But that's about it.
I cannot get any data over it. I can manually configure it to have an IP
address and netmask, but it won't see anything on the local net. DHCP
doesn't work either. Nothing out of the ordinary is logged in dmesg or
anywhere else. An usb ethernet dongle on the system works just fine,
ruling out (absent anyway) firewall or similar trouble.  The device works
well in windows XP.

Relevant system specs:
-Gigabyte GA-G33m-DS2R motherboard, with the integrated realtec nic
-intel c2d CPU

I've included output of several programs below, hope this helps.

Please CC: to my email address, as I have not subscribed myself to the kernel list.

dmesg output:

r8169 Gigabit Ethernet driver 2.2LK loaded
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:04:00.0 to 64
eth0: RTL8168b/8111b at 0xf8854000, 00:1a:4d:44:a1:1f, IRQ 18
...
r8169: eth2: link up
r8169: eth2: link up

ifconfig output:

eth2      Link encap:Ethernet  HWaddr 00:1A:4D:44:A1:1F  
          inet addr:192.168.3.10  Bcast:192.168.3.255  Mask:255.255.255.0
          inet6 addr: 2001:610:1108:5203::2/64 Scope:Global
          inet6 addr: 2001:610:1108:5203:21a:4dff:fe44:a11f/64 Scope:Global
          inet6 addr: fe80::21a:4dff:fe44:a11f/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:296529 errors:0 dropped:0 overruns:0 frame:0
          TX packets:221678 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:438053177 (417.7 MiB)  TX bytes:14156999 (13.5 MiB)
          Interrupt:18 Base address:0x4000 

lspci output:

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: Giga-byte Technology Unknown device e000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at c000 [size=256]
        Region 2: Memory at ec000000 (64-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at ed200000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s unlimited, L1 unlimited
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [84] Vendor Specific Information
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [12c] Virtual Channel
        Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-25
        Capabilities: [154] Power Budgeting


Best regards,
Bram
