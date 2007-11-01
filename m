Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbXKAXx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbXKAXx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbXKAXxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:53:50 -0400
Received: from zakalwe.fi ([80.83.5.154]:34715 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXKAXxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:53:49 -0400
Date: Fri, 2 Nov 2007 01:53:48 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange freezes (seems like SATA related)
Message-ID: <20071101235348.GC3441@zakalwe.fi>
References: <47261043.5020907@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <47261043.5020907@qualcomm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 09:54:27AM -0700, Max Krasnyansky wrote:
> A couple of HP xw9300 machines (dual Opterons) started freezing up.
> We're running on 2.6.22.1 on them. Freezes a somewhere weird. 
> VGA console is alive
> (I can switch vts, etc) but everything else is dead (network, etc).

I'm thinking this is not a coincidence. I was running 2.6.22.5, and 
looking at your problems, I just had a similar experience on tuesday.. 
The network was still fine after kernel errors so that I was able to 
login with SSH. See:

	http://lkml.org/lkml/2007/10/30/193

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

With ata_piix Intel SATA I got these errors:

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd ca/00:68:6f:3a:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 53248 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: device not ready (errno=-16), forcing hardreset
ata1: soft resetting port
ata1.00: revalidation failed (errno=-2)
ata1: failed to recover some devices, retrying in 5 secs
ata1: soft resetting port
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

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

Mine is a Pentium 4 on Intel chips..

00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub Interface (rev 02)
00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02)
00:1f.2 RAID bus controller: Intel Corporation 82801ER (ICH5R) SATA Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 02)
01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G400/G450 (rev 04)
02:04.0 RAID bus controller: VIA Technologies, Inc. VT6410 ATA133 RAID controller (rev 06)
02:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 12)

If this is the same error, then the problem is not ata_piix/nvidia 
specific since you seem to have an nvidia SATA controller.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
