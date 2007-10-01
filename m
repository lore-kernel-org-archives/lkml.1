Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXJAUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXJAUl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXJAUlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:41:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:47573 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752261AbXJAUlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:41:18 -0400
From: Simon Roscic <simon.roscic@chello.at>
To: linux-kernel@vger.kernel.org
Subject: western digital WD800ADFS ncq problems
Date: Mon, 1 Oct 2007 22:41:14 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710012241.14512.simon.roscic@chello.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(please cc me, as i´m not subscribed to linux-kernel/ide - thanks)

hi,

we have some Fujitsu Siemens Celsius M450 workstations (Intel 975X Express chipset)
running Linux Kernel 2.6.22 (Debian, Ubuntu) on an md raid 1 using two Western Digital
Raptor drives, it´s the WD800ADFS which is an oem version (you will find them in
workstations from HP, IBM, Dell, Fujitsu-Siemens,... and they have different model
numbers) using ahci and ncq we are experiencing low performace, and many
hsm violations, sometimes also timeouts, so i think this drive should be added
to the libata ncq blacklist, as the WD740ADFD is already blacklisted and the
Raptor series generally seems to have some ncq issues...

kind regards,
simon.

drive information:

/dev/sda:

ATA device, with non-removable media
        Model Number:       WDC WD800ADFS-07SLR4
        Serial Number:      WD-WMANS1******
        Firmware Revision:  21.07QR4
Standards:
        Used: ATA/ATAPI-7 published, ANSI INCITS 397-2005
        Supported: 7 6 5 4
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  156301488
        LBA48  user addressable sectors:  156301488
        device size with M = 1024*1024:       76319 MBytes
        device size with M = 1000*1000:       80026 MBytes (80 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, with device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 16
        Recommended acoustic management value: 128, current value: 254
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY flow control=120ns
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
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                SET_MAX security extension
           *    Automatic Acoustic Management feature set
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    64-bit World wide name
           *    SATA-I signaling speed (1.5Gb/s)
           *    SATA-II signaling speed (3.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Host-initiated interface power management
           *    Phy event counters
                DMA Setup Auto-Activate optimization
                Device-initiated interface power management
           *    Software settings preservation
           *    SMART Command Transport (SCT) feature set
           *    SCT Long Sector Access (AC1)
           *    SCT LBA Segment Access (AC2)
           *    SCT Error Recovery Control (AC3)
           *    SCT Features Control (AC4)
           *    SCT Data Tables (AC5)
                unknown 206[12]
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
        not     supported: enhanced erase
Checksum: correct

some of the kernel messages:

[70747.193717] ata3.00: exception Emask 0x2 SAct 0xfe00 SErr 0x0 action 0x2 frozen
[70747.193725] ata3.00: (spurious completions during NCQ issue=0x0 SAct=0xfe00 FIS=004040a1:00000100)
[70747.193734] ata3.00: cmd 61/20:48:d2:9d:24/00:00:08:00:00/40 tag 9 cdb 0x0 data 16384 out
[70747.193736]          res 40/00:78:42:ae:24/00:00:08:00:00/40 Emask 0x2 (HSM violation)
...
[70747.193789] ata3.00: cmd 61/08:78:42:ae:24/00:00:08:00:00/40 tag 15 cdb 0x0 data 4096 out
[70747.193791]          res 40/00:78:42:ae:24/00:00:08:00:00/40 Emask 0x2 (HSM violation)
[70747.502219] ata3: soft resetting port
[70747.673864] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[70747.678834] ata3.00: configured for UDMA/133
[70747.678853] ata3: EH complete

[143055.609784] ata4.00: exception Emask 0x2 SAct 0xe811 SErr 0x0 action 0x2 frozen
[143055.609800] ata4.00: (spurious completions during NCQ issue=0x0 SAct=0xe811 FIS=004040a1:00000080)
[143055.609809] ata4.00: cmd 61/10:00:02:68:56/00:00:00:00:00/40 tag 0 cdb 0x0 data 8192 out
[143055.609811]          res 40/00:78:6a:d7:59/00:00:02:00:00/40 Emask 0x2 (HSM violation)
...
[143055.609870] ata4.00: cmd 61/08:78:6a:d7:59/00:00:02:00:00/40 tag 15 cdb 0x0 data 4096 out
[143055.609872]          res 40/00:78:6a:d7:59/00:00:02:00:00/40 Emask 0x2 (HSM violation)
[143055.920558] ata4: soft resetting port
[143056.092224] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[143056.097130] ata4.00: configured for UDMA/133
[143056.097146] ata4: EH complete

[234300.421373] ata4.00: exception Emask 0x0 SAct 0x7fff SErr 0x0 action 0x2 frozen
[234300.421386] ata4.00: cmd 60/08:00:f2:fc:71/00:00:00:00:00/40 tag 0 cdb 0x0 data 4096 in
[234300.421388]          res 40/00:48:92:e9:9d/00:00:04:00:00/40 Emask 0x4 (timeout)
...
[234300.421511] ata4.00: cmd 60/08:70:5a:b0:16/00:00:08:00:00/40 tag 14 cdb 0x0 data 4096 in
[234300.421513]          res 40/00:88:7a:68:56/00:00:00:00:00/40 Emask 0x4 (timeout)
[234300.732730] ata4: soft resetting port
[234300.904388] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[234300.909120] ata4.00: configured for UDMA/133
[234300.909149] ata4: EH complete
