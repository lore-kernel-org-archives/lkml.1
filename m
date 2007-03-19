Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbXCSMVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbXCSMVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXCSMVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:21:25 -0400
Received: from mail.icabo.tv.br ([200.220.202.3]:50957 "EHLO mail.icabo.tv.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbXCSMVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:21:24 -0400
Message-ID: <45FE8030.9090400@fliagreco.com.ar>
Date: Mon, 19 Mar 2007 09:21:04 -0300
From: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
User-Agent: Thunderbird 3.0a1 (Windows/20070315)
MIME-Version: 1.0
To: Christian <christiand59@web.de>
CC: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <200703161544.59430.christiand59@web.de> <45FCD16D.90806@gmail.com> <200703182131.00476.christiand59@web.de>
In-Reply-To: <200703182131.00476.christiand59@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ICABO-MailScanner-Information: Please contact the ISP for more information
X-ICABO-MailScanner: Sem Virus encontrado
X-MailScanner-From: lkml@fliagreco.com.ar
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
> On Sunday 18 March 2007 06:43:09 you wrote:
>   
>> Christian wrote:
>>     
>>>> This does indeed look like a drive side issue to me (the controller is
>>>> reporting CPBs with response flags 2 which as far as I can tell
>>>> indicates it's still waiting for the drive to complete the request).
>>>>         
>>> I have been using this hw-config (SATA II, NCQ) since the nvidia ADMA
>>> support made it in the -mm kernel (maybe around 2.6.19-mm? or even
>>> earlyer). I'm seeing this problem excessively since I upgraded to
>>> 2.6.21-rc3-mm1. I think something got broken recently...
>>>       
>> Can you post the result of "hdparm -I /dev/sdX"?
>>     
>
> Output generated on 2.6.21-rc3-mm1 #3 SMP PREEMPT
>
> user@ubuntu:~$ sudo hdparm -I /dev/sda
>
> /dev/sda:
>
> ATA device, with non-removable media
>         Model Number:       SAMSUNG HD401LJ
>         Serial Number:      S0HVJ1FL900207
>         Firmware Revision:  ZZ100-15
> Standards:
>         Used: ATA/ATAPI-7 T13 1532D revision 4a
>         Supported: 7 6 5 4
> Configuration:
>         Logical         max     current
>         cylinders       16383   16383
>         heads           16      16
>         sectors/track   63      63
>         --
>         CHS current addressable sectors:   16514064
>         LBA    user addressable sectors:  268435455
>         LBA48  user addressable sectors:  781422768
>         device size with M = 1024*1024:      381554 MBytes
>         device size with M = 1000*1000:      400088 MBytes (400 GB)
> Capabilities:
>         LBA, IORDY(can be disabled)
>         Queue depth: 32
>         Standby timer values: spec'd by Standard, no device specific minimum
>         R/W multiple sector transfer: Max = 16  Current = 16
>         Recommended acoustic management value: 254, current value: 0
>         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
> udma7
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=120ns  IORDY flow control=120ns
> Commands/features:
>         Enabled Supported:
>            *    SMART feature set
>                 Security Mode feature set
>            *    Power Management feature set
>            *    Write cache
>            *    Look-ahead
>            *    Host Protected Area feature set
>            *    WRITE_BUFFER command
>            *    READ_BUFFER command
>            *    NOP cmd
>            *    DOWNLOAD_MICROCODE
>                 SET_MAX security extension
>                 Automatic Acoustic Management feature set
>            *    48-bit Address feature set
>            *    Device Configuration Overlay feature set
>            *    Mandatory FLUSH_CACHE
>            *    FLUSH_CACHE_EXT
>            *    SMART error logging
>            *    SMART self-test
>            *    General Purpose Logging feature set
>            *    SATA-I signaling speed (1.5Gb/s)
>            *    SATA-II signaling speed (3.0Gb/s)
>            *    Native Command Queueing (NCQ)
>            *    Host-initiated interface power management
>            *    Phy event counters
>                 DMA Setup Auto-Activate optimization
>                 Device-initiated interface power management
>            *    Software settings preservation
>            *    SMART Command Transport (SCT) feature set
>            *    SCT Long Sector Access (AC1)
>            *    SCT LBA Segment Access (AC2)
>            *    SCT Error Recovery Control (AC3)
>            *    SCT Features Control (AC4)
>            *    SCT Data Tables (AC5)
> Security:
>         Master password revision code = 65534
>                 supported
>         not     enabled
>         not     locked
>                 frozen
>         not     expired: security count
>                 supported: enhanced erase
>         228min for SECURITY ERASE UNIT. 228min for ENHANCED SECURITY ERASE 
> UNIT.
> Checksum: correct
>
>
> user@ubuntu:~$ sudo hdparm -I /dev/sdb
>
> /dev/sdb:
>
> ATA device, with non-removable media
>         Model Number:       SAMSUNG SP2504C
>         Serial Number:      S09QJ1LYC06381
>         Firmware Revision:  VT100-33
> Standards:
>         Used: ATA/ATAPI-7 T13 1532D revision 4a
>         Supported: 7 6 5 4
> Configuration:
>         Logical         max     current
>         cylinders       16383   16383
>         heads           16      16
>         sectors/track   63      63
>         --
>         CHS current addressable sectors:   16514064
>         LBA    user addressable sectors:  268435455
>         LBA48  user addressable sectors:  488397168
>         device size with M = 1024*1024:      238475 MBytes
>         device size with M = 1000*1000:      250059 MBytes (250 GB)
> Capabilities:
>         LBA, IORDY(can be disabled)
>         Queue depth: 32
>         Standby timer values: spec'd by Standard, no device specific minimum
>         R/W multiple sector transfer: Max = 16  Current = 16
>         Recommended acoustic management value: 254, current value: 254
>         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
> udma7
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=120ns  IORDY flow control=120ns
> Commands/features:
>         Enabled Supported:
>            *    SMART feature set
>                 Security Mode feature set
>            *    Power Management feature set
>            *    Write cache
>            *    Look-ahead
>            *    Host Protected Area feature set
>            *    WRITE_BUFFER command
>            *    READ_BUFFER command
>            *    NOP cmd
>            *    DOWNLOAD_MICROCODE
>                 SET_MAX security extension
>            *    Automatic Acoustic Management feature set
>            *    48-bit Address feature set
>            *    Device Configuration Overlay feature set
>            *    Mandatory FLUSH_CACHE
>            *    FLUSH_CACHE_EXT
>            *    SMART error logging
>            *    SMART self-test
>            *    General Purpose Logging feature set
>            *    SATA-I signaling speed (1.5Gb/s)
>            *    SATA-II signaling speed (3.0Gb/s)
>            *    Native Command Queueing (NCQ)
>            *    Host-initiated interface power management
>            *    Phy event counters
>                 DMA Setup Auto-Activate optimization
>                 Device-initiated interface power management
>            *    Software settings preservation
> Security:
>         Master password revision code = 65534
>                 supported
>         not     enabled
>         not     locked
>                 frozen
>         not     expired: security count
>                 supported: enhanced erase
>         120min for SECURITY ERASE UNIT. 120min for ENHANCED SECURITY ERASE 
> UNIT.
> Checksum: correct
>
> user@ubuntu:~$ sudo hdparm -I /dev/sdc
>
> /dev/sdc:
>
> ATA device, with non-removable media
>         Model Number:       SAMSUNG SP2504C
>         Serial Number:      S09QJ10L420645
>         Firmware Revision:  VT100-41
> Standards:
>         Used: ATA/ATAPI-7 T13 1532D revision 4a
>         Supported: 7 6 5 4
> Configuration:
>         Logical         max     current
>         cylinders       16383   16383
>         heads           16      16
>         sectors/track   63      63
>         --
>         CHS current addressable sectors:   16514064
>         LBA    user addressable sectors:  268435455
>         LBA48  user addressable sectors:  488397168
>         device size with M = 1024*1024:      238475 MBytes
>         device size with M = 1000*1000:      250059 MBytes (250 GB)
> Capabilities:
>         LBA, IORDY(can be disabled)
>         Queue depth: 32
>         Standby timer values: spec'd by Standard, no device specific minimum
>         R/W multiple sector transfer: Max = 16  Current = 16
>         Recommended acoustic management value: 254, current value: 0
>         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
> udma7
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=120ns  IORDY flow control=120ns
> Commands/features:
>         Enabled Supported:
>                 SMART feature set
>                 Security Mode feature set
>            *    Power Management feature set
>            *    Write cache
>            *    Look-ahead
>            *    Host Protected Area feature set
>            *    WRITE_BUFFER command
>            *    READ_BUFFER command
>            *    NOP cmd
>            *    DOWNLOAD_MICROCODE
>                 SET_MAX security extension
>                 Automatic Acoustic Management feature set
>            *    48-bit Address feature set
>            *    Device Configuration Overlay feature set
>            *    Mandatory FLUSH_CACHE
>            *    FLUSH_CACHE_EXT
>            *    SMART error logging
>            *    SMART self-test
>            *    General Purpose Logging feature set
>            *    Segmented DOWNLOAD_MICROCODE
>            *    SATA-I signaling speed (1.5Gb/s)
>            *    SATA-II signaling speed (3.0Gb/s)
>            *    Native Command Queueing (NCQ)
>            *    Host-initiated interface power management
>            *    Phy event counters
>                 DMA Setup Auto-Activate optimization
>                 Device-initiated interface power management
>            *    Software settings preservation
>            *    SMART Command Transport (SCT) feature set
>            *    SCT Long Sector Access (AC1)
>            *    SCT LBA Segment Access (AC2)
>            *    SCT Error Recovery Control (AC3)
>            *    SCT Features Control (AC4)
>            *    SCT Data Tables (AC5)
> Security:
>         Master password revision code = 65534
>                 supported
>         not     enabled
>         not     locked
>                 frozen
>         not     expired: security count
>                 supported: enhanced erase
>         88min for SECURITY ERASE UNIT. 88min for ENHANCED SECURITY ERASE UNIT.
> Checksum: correct
>
> -Christian
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
Tejun: sdb and sdc are exactly the same drives as when I had my problem.
Christian: Can you verify if this firmware upgrade helps?

http://www.samsung.com/Products/HardDiskDrive/support/faqs/faqs_20060414_0000246673.htm

Thanks.
Pablo.
