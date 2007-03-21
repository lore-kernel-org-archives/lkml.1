Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbXCUMxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbXCUMxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXCUMxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:53:23 -0400
Received: from mx-a.polytechnique.fr ([129.104.30.14]:50664 "EHLO
	mx-a.polytechnique.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbXCUMxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:53:22 -0400
Message-ID: <46012A93.7000302@crans.org>
Date: Wed, 21 Mar 2007 13:52:35 +0100
From: =?ISO-8859-1?Q?Mathieu_B=E9rard?= <Mathieu.Berard@crans.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jens Axboe <jens.axboe@oracle.com>,
       "Eric D. Mudama" <edmudama@gmail.com>
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image
 Windows driver
References: <45DD2EC9.4050403@shaw.ca> <45DF67C4.8090802@garzik.org> <4600DF90.3030902@gmail.com>
In-Reply-To: <4600DF90.3030902@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo a écrit :
> Jeff Garzik wrote:
>
> Mathieu, just to be sure, can you post the result of 'hdparm -I
> /dev/sdX' and 'lspci -nn'?
>
Hi,
no problem :

lspci -nn:
00:00.0 Host bridge [0600]: Intel Corporation Mobile 915GM/PM/GMS/910GML
Express Processor to DRAM Controller [8086:2590] (rev 03)
00:01.0 PCI bridge [0604]: Intel Corporation Mobile 915GM/PM Express PCI
Express Root Port [8086:2591] (rev 03)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 1 [8086:2660] (rev 03)
00:1c.1 PCI bridge [0604]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 2 [8086:2662] (rev 03)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW
(ICH6 Family) USB UHCI #1 [8086:2658] (rev 03)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW
(ICH6 Family) USB UHCI #2 [8086:2659] (rev 03)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW
(ICH6 Family) USB UHCI #3 [8086:265a] (rev 03)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW
(ICH6 Family) USB UHCI #4 [8086:265b] (rev 03)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801FB/FBM/FR/FW/FRW
(ICH6 Family) USB2 EHCI Controller [8086:265c] (rev 03)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge
[8086:2448] (rev d3)
00:1e.2 Multimedia audio controller [0401]: Intel Corporation
82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller [8086:266e]
(rev 03)
00:1e.3 Modem [0703]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) AC'97 Modem Controller [8086:266d] (rev 03)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801FBM (ICH6M) LPC
Interface Bridge [8086:2641] (rev 03)
00:1f.1 IDE interface [0101]: Intel Corporation 82801FB/FBM/FR/FW/FRW
(ICH6 Family) IDE Controller [8086:266f] (rev 03)
00:1f.2 IDE interface [0101]: Intel Corporation 82801FBM (ICH6M) SATA
Controller [8086:2653] (rev 03)
00:1f.3 SMBus [0c05]: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) SMBus Controller [8086:266a] (rev 03)
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc M24
[Radeon Mobility X600] [1002:5462]
06:01.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
06:02.0 Network controller [0280]: Intel Corporation PRO/Wireless 2200BG
Network Connection [8086:4220] (rev 05)
06:04.0 CardBus bridge [0607]: Texas Instruments PCIxx21/x515 Cardbus
Controller [104c:8031]
06:04.2 FireWire (IEEE 1394) [0c00]: Texas Instruments OHCI Compliant
IEEE 1394 Host Controller [104c:8032]
06:04.3 Mass storage controller [0180]: Texas Instruments PCIxx21
Integrated FlashMedia Controller [104c:8033]
06:04.4 Generic system peripheral [0805]: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
[104c:8034]

hdparm -I /dev/sda:

/dev/sda:

ATA device, with non-removable media
        Model Number:       HTS541010G9SA00                        
        Serial Number:      MP2ZM4X0GSWJKR
        Firmware Revision:  MBZOC60D
Standards:
        Used: ATA/ATAPI-7 T13 1532D revision 1
        Supported: 7 6 5 4
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  195371568
        LBA48  user addressable sectors:  195371568
        device size with M = 1024*1024:       95396 MBytes
        device size with M = 1000*1000:      100030 MBytes (100 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Vendor, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 0
        Advanced power management level: 128 (0x80)
        Recommended acoustic management value: 128, current value: 254
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    NOP cmd
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                SET_MAX security extension
                Automatic Acoustic Management feature set
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    IDLE_IMMEDIATE with UNLOAD
           *    SATA-I signaling speed (1.5Gb/s)
           *    Native Command Queueing (NCQ)
           *    Host-initiated interface power management
                Non-Zero buffer offsets in DMA Setup FIS
                DMA Setup Auto-Activate optimization
                Device-initiated interface power management
                In-order data delivery
           *    Software settings preservation
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
        not     frozen
        not     expired: security count
        not     supported: enhanced erase
        64min for SECURITY ERASE UNIT.
Checksum: correct

-- 
Mathieu

