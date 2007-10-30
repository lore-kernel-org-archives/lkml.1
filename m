Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXJ3ABd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXJ3ABd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXJ3ABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:01:25 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59892 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbXJ3ABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:01:24 -0400
Date: Mon, 29 Oct 2007 18:03:23 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Strange freezes (seems like SATA related)
In-reply-to: <fa.geuG6UTKiSgc409K9/yA9HzMTUs@ifi.uio.no>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <472674CB.10807@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.geuG6UTKiSgc409K9/yA9HzMTUs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrote:
> A couple of HP xw9300 machines (dual Opterons) started freezing up.
> We're running on 2.6.22.1 on them. Freezes a somewhere weird. VGA console is alive
> (I can switch vts, etc) but everything else is dead (network, etc).
> Unfortunately SYSRQ was not enabled and I could not get backtraces and stuff.
> 
> Hooked up serial console and the only error that shows up is this.
> 
> ata1: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1581000 status 0x1540 next cpb count 0x0 next cpb idx 0x0
> ata1: CPB 0: ctl_flags 0xd, resp_flags 0x1
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd ca/00:08:57:00:80/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Descriptor sense data with sense descriptors (in hex):
> end_request: I/O error, dev sda, sector 8388695
> Buffer I/O error on device sda1, logical block 1048579
> lost page write due to I/O error on sda1
> sd 0:0:0:0: [sda] Write Protect is off
> 
> I see a bunch of those and then the box just sits there spewing this periodically
> 
> ata1: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1581000 status 0x1540 next cpb count 0x0 next cpb idx 0x0
> ata1: CPB 0: ctl_flags 0xd, resp_flags 0x1
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd ca/00:08:4f:00:f8/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> 
> SMART selftest on the drive passed without errors.
> 
> Here is how this machine looks like
> 
> 00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
> 00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
> 00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
> 00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
> 00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
> 00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2)
> 00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
> 00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
> 00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
> 00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
> 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
> 00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 05:04.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]
> 05:05.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link)
> 0a:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) (rev 06)
> 40:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
> 40:01.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
> 40:02.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
> 40:02.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
> 61:04.0 PCI bridge: Intel Corporation Unknown device 537c (rev 07)
> 61:06.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
> 61:06.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
> 61:09.0 PCI bridge: Intel Corporation Unknown device 537c (rev 07)
> 62:09.0 Multimedia controller: BittWare, Inc. Unknown device 0035 (rev 01)
> 63:09.0 Multimedia controller: BittWare, Inc. Unknown device 0035 (rev 01)
> 80:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
> 80:01.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
> 80:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 81:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) (rev 06)
> 
> As I mentioned dual Opteron, NUMA. Nothing fancy in the kernel config. 
> 
> Any ideas what might the problem be ?

Can you post the full dmesg output? What kind of drive is this?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

