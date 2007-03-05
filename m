Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbXCEV2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbXCEV2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbXCEV1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:27:35 -0500
Received: from smtp1-g19.free.fr ([212.27.42.27]:38643 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933601AbXCEV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:27:30 -0500
X-Greylist: delayed 74171 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 16:27:30 EST
Message-ID: <45EC8B3E.7040706@crans.org>
Date: Mon, 05 Mar 2007 22:27:26 +0100
From: =?ISO-8859-1?Q?Mathieu_B=E9rard?= <Mathieu.Berard@crans.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Regression between 2.6.20 and 2.6.21-rc1: NCQ problem with ahci
 and Hitachi drive
References: <45EB6980.90600@crans.org> <45EB79C1.3070107@gmail.com>
In-Reply-To: <45EB79C1.3070107@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo a écrit :

Hi,
> No, your drive isn't blacklisted yet.  NCQ is still being enabled.
>
>   
Sorry, I wasn't very clear: The NCQ blacklist patch is not in
the 2.6.21-rc tree, just in -mm. I tried a 2.6.21-rc2-mm1 and
the drive is blacklisted. The logs I pasted were from 2.6.20 and
2.6.21-rc1.
>> [   16.091804] ata1.00: configured for UDMA/100
>> [   18.151756] SCSI device sda: write cache: enabled, read cache:
>> enabled, doesn't support DPO or FUA
>>     
> [--snip--]
>   
>> [   18.151856] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
>> [   18.151911] sda: Write Protect is off
>> [   18.151977] SCSI device sda: write cache: enabled, read cache:
>> enabled, doesn't support DPO or FUA
>> [....]
>> [   48.143940] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
>> frozen
>> [   48.143999] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
>> cdb 0x0 data 4096 in
>> [   48.144000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
>> 0x4 (timeout)
>>     
>
> It looks like IRQ isn't getting through.  Does giving "acpi=off" kernel
> parameter make any difference?
>
>   

Yes It works with acpi=off (2.6.21-rc1):
Please notice that IRQ is changed from 19 with ACPI to 11 without.

[   24.226291] SCSI subsystem initialized
[   24.230178] libata version 2.10 loaded.
[   24.231315] ahci 0000:00:1f.2: version 2.0
[   25.231137] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   25.231144] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5
Gbps 0x5 impl SATA mode
[   25.231202] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
[   25.231341] ata1: SATA max UDMA/133 cmd 0xf880ed00 ctl 0x00000000
bmdma 0x00000000 irq 11
[   25.231468] ata2: SATA max UDMA/133 cmd 0xf880ed80 ctl 0x00000000
bmdma 0x00000000 irq 11
[   25.231596] ata3: SATA max UDMA/133 cmd 0xf880ee00 ctl 0x00000000
bmdma 0x00000000 irq 11
[   25.231722] ata4: SATA max UDMA/133 cmd 0xf880ee80 ctl 0x00000000
bmdma 0x00000000 irq 11
[   25.231783] scsi0 : ahci
[   25.688849] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   25.689915] ata1.00: ATA-7: HTS541010G9SA00, MBZOC60D, max UDMA/100
[   25.689964] ata1.00: 195371568 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   25.691271] ata1.00: configured for UDMA/100
[   25.691321] scsi1 : ahci
[   25.993653] ata2: SATA link down (SStatus 0 SControl 0)
[   25.993706] scsi2 : ahci
[   26.296471] ata3: SATA link down (SStatus 0 SControl 300)
[   26.296524] scsi3 : ahci
[   26.599288] ata4: SATA link down (SStatus 0 SControl 0)
[   26.599423] scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00 
MBZO PQ: 0 ANSI: 5
[....]
[   27.741608] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   27.741706] sda: Write Protect is off
[   27.741753] sda: Mode Sense: 00 3a 00 00
[   27.741921] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   27.742037] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   27.742091] sda: Write Protect is off
[   27.742171] sda: Mode Sense: 00 3a 00 00
[   27.742182] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   27.742238]  sda: sda1 sda2 < sda5 sda6 > sda3
[   28.204850] sd 0:0:0:0: Attached scsi disk sda
[   28.207809] sd 0:0:0:0: Attached scsi generic sg0 type 0


-- 
Mathieu
