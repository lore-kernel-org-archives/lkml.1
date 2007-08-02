Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbXHBKV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbXHBKV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbXHBKVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:21:19 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:33081 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXHBKVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:21:19 -0400
From: Herbert Rosmanith <kernel@wildsau.enemy.org>
Message-Id: <200708021020.l72AKvjC008561@wildsau.enemy.org>
Subject: VIA EPIA EK: strange eth dev numbering
To: linux-kernel@vger.kernel.org
Date: Thu, 2 Aug 2007 12:20:56 +0200 (MET DST)
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

I see a strange numbering of ethernet devices with a VIA EPIA EK
board. This board has two ethernet connectors, you can see it
here: http://www.via.com.tw/en/products/mainboards/motherboards.jsp?motherboard_id=420

I configured the system such that via-rhine is loaded as a module.
When doing the module load, the kernel says:

    via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
    via-rhine: Broken BIOS detected, avoid_D3 enabled.
    ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 16 (level, low) -> IRQ 17
    eth0: VIA Rhine III at 0x1d000, 00:40:63:ee:96:56, IRQ 17.
    eth0: MII PHY found at address 1, status 0x7869 advertising 05e1 Link 45e1.
    ACPI: PCI Interrupt Link [ALKD] enabled at IRQ 23
    ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [ALKD] -> GSI 23 (level, low) -> IRQ 18
    eth1: VIA Rhine II at 0x1ec00, 00:40:63:ee:96:55, IRQ 18.
    eth1: MII PHY found at address 1, status 0x7849 advertising 05e1 Link 0000.

but, when continuing, no such eth0 or eth1 device is present (and thus, dhcpcd will
not receive any address).

an "ifconfig eth"0(eth1) will report:

    localhost ~ # ifconfig eth0
    eth0: error fetching interface information: Device not found
    localhost ~ # ifconfig eth1
    eth1: error fetching interface information: Device not found

it took a while until, just out of a feeling in my stomach, I tried "ifconfig -a",
and surprise, surprise, the ethernet devices were in fact there, *but* there
names where eth2 and eth3.

doing an "ifconig eth2 192.168....." in fact "upped" the interface, and I was
able to work with the net. after ifconfig, the kernel would say:

    eth2: link up, 100Mbps, full-duplex, lpa 0x45E1

and ifconfig -a:

    localhost ~ # ifconfig -a
    eth2      Link encap:Ethernet  HWaddr 00:40:63:EE:96:56  
              inet addr:192.168.1.23  Bcast:192.168.1.255  Mask:255.255.255.0
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:16713 errors:0 dropped:0 overruns:0 frame:0
              TX packets:10522 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:18133391 (17.2 Mb)  TX bytes:1176276 (1.1 Mb)
              Interrupt:17 Base address:0xd000 
    
    eth3      Link encap:Ethernet  HWaddr 00:40:63:EE:96:55  
              BROADCAST MULTICAST  MTU:1500  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
              Interrupt:18 Base address:0xec00 
    
    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
    
    localhost ~ # 


pretty strange?! I dont think this is the correct behaviour, is it?

cheers,
herp

