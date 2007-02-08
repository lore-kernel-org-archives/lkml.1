Return-Path: <linux-kernel-owner+w=401wt.eu-S965592AbXBHXYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965592AbXBHXYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965596AbXBHXYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:24:01 -0500
Received: (root@vger.kernel.org) by vger.kernel.org id S965593AbXBHXYA
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:24:00 -0500
Received: from aybabtu.com ([69.60.117.155]:51959 "EHLO aybabtu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422783AbXBHXK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:10:29 -0500
From: Leopold Palomo Avellaneda <lepalom@wol.es>
Reply-To: lepalom@wol.es
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Sata_via problems in a Vintage2-AE1
Date: Fri, 9 Feb 2007 00:10:06 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Message-Id: <200702090010.06897.lepalom@wol.es>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear people,

I have a barebone Asus Vintage2-AE1 [1]. This box has a mobo Asus A8V-MQ. The 
board has:
- the Socket 939 for AMD Athlon 64FX/Athlon 64.
- North Bridge: VIA K8M800  
- South Bridge: VIA VT8251
- VIA Graphics Integrated
- IDE 2 x UltraDMA 133
- 4 x Serial ATA
...

I'm using the bios version 0206. The 0210 doesn't show me the vga card, so I 
don't have graphics mode. I think that is a buggy bios.

The bios is configured with vt8251 in AHCI mode and bios boot up activated, so 
the hd is recognized in the beginning. I don't have any raid, only one hd. 
The hd is a Maxtor 6V250F0.

I'm using a debian etch but the i386 version. The only way that I can use the 
hd is using a 2.6.16 standard kernel with the modifications explained in this 
page [2]. Basically you have to use their ahci.c and sata_via.c. The 
modifications are small from the original code from Mr Jeff Garzik.

I have tried to use the 2.6.18 and 2.6.20rc6 and the result is the same. The  
kernel boots, but when arrives at the ata3, 

scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: qc timeout (cmd 0xec)
ata3.00: failed to IDENTIFY (I/O error, err_mask=0x104)
.... repeated some times ...
scsi3 : ahci
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
scsi4 : ahci
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
scsi5 : ahci
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Done.
Begin: Mounting root file system... ...
Begin: Running /scripts/local-top
ide0: I/O resource 0x3F6-0x3F6 not free.
ide0: ports already in use, skipping probe.
ide1: I/O resource 0x376-0x376 not free.
ide1: ports already in use, skipping probe.
Done.
Begin: Waiting for root file system ...

.....

but the /dev/sda doesn't exist so I cannot boot.

using the 2.6.16 with lspci -M I obtain the info attached below. Please, could 
you look on it?

Best regards,

thanks in advance,

Leo


[1] http://www.asus.com/products4.aspx?l1=1&l2=1&l3=381&model=1001&modelmenu=1
[2] http://www.geocities.com/rajahuroman/main.html

lspci -M output:
----------------------------------------------------------------------
00:00.0 Host bridge: VIA Technologies, Inc. K8M800 Host Bridge
00:00.1 Host bridge: VIA Technologies, Inc. K8M800 Host Bridge
00:00.2 Host bridge: VIA Technologies, Inc. K8M800 Host Bridge
00:00.3 Host bridge: VIA Technologies, Inc. K8M800 Host Bridge
00:00.4 Host bridge: VIA Technologies, Inc. K8M800 Host Bridge
00:00.7 Host bridge: VIA Technologies, Inc. K8M800 Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 
South]
## 00.01:0 is a bridge from 00 to 01-01
00:0f.0 SATA controller: VIA Technologies, Inc. VT8251 AHCI/SATA 4-Port 
Controller
00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 90)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 90)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 90)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 90)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 90)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8251 PCI to ISA Bridge
00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 
AC97 Audio Controller (rev 70)
00:11.7 Host bridge: VIA Technologies, Inc. VT8251 Ultra VLINK Controller
00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 7c)
00:13.0 PCI bridge: VIA Technologies, Inc. VT8251 Host Bridge
## 00.13:0 is a bridge from 00 to 02-04
00:13.1 PCI bridge: VIA Technologies, Inc. VT8251 PCI to PCI Bridge
## 00.13:1 is a bridge from 00 to 05-05
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation NV43 [GeForce 6200] (rev 
a1)
02:00.0 PCI bridge: VIA Technologies, Inc. VT8251 PCIE Root Port
## 02.00:0 is a bridge from 02 to 03-03
02:00.1 PCI bridge: VIA Technologies, Inc. VT8251 PCIE Root Port
## 02.00:1 is a bridge from 02 to 04-04

Summary of buses:

00: Primary host bus
        13.1 Bridge to 05-05
        13.0 Bridge to 02-04
        01.0 Bridge to 01-01
01: Entered via 00:01.0
02: Entered via 00:13.0
        00.1 Bridge to 04-04
        00.0 Bridge to 03-03
----------------------------------------------------------------------


-- 
--
Linux User 152692
Catalonia
