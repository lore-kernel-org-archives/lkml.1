Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbYHEDmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbYHEDmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbYHEDmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:42:25 -0400
Received: from 215.47.dsnet ([211.144.215.47]:58993 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760013AbYHEDmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:42:21 -0400
X-AuditID: ac189297-a8819bb000000f94-6c-4897d8ef2174
Message-ID: <4897CBFE.8070107@alcatel-lucent.com>
Date: Tue, 05 Aug 2008 11:41:50 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Gavin Shan <gshan@alcatel-lucent.com>
CC: Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: PIIX4: DMA timeout issue
References: <488ED837.2060509@alcatel-lucent.com>	<488F1C6C.9000002@garzik.org>	<48902EB5.8070102@alcatel-lucent.com> <20080730114934.5a593cf4@lxorguk.ukuu.org.uk> <48913FFD.5070901@alcatel-lucent.com> <4892BEBA.2000602@kernel.org> <4892CF2B.9030309@alcatel-lucent.com> <007901c8f572$c0f3d020$0100a8c0@microsof291b50>
In-Reply-To: <007901c8f572$c0f3d020$0100a8c0@microsof291b50>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Aug 2008 03:41:38.0446 (UTC) FILETIME=[2A9852E0:01C8F6AD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gavin Shan wrote:
>> Unfortunately, the timeout issue still happened on ATA driver as IDE.
>>
>> Command (m for help): p
>>
>> Disk /dev/sda: 60.0 GB, 60011642880 bytes
>> 255 heads, 63 sectors/track, 7296 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0x4892c004
>>
>>   Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1               1          17      136521   83  Linux
>> /dev/sda4              18        7296    58468567+   5  Extended
>> /dev/sda5              18        7296    58468536   83  Linux
>>
>> Command (m for help): w
>> The partition table has been altered!
>>
>> Calling ioctl() to re-read partition table.
>> SCSI device sda: 117210240 512-byte hdwr sectors (60012 MB)
>> sda: Write Protect is off
>> SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
>> support DPO or FUA
>> sda: sda1 sda4 < sda5 >
>> Syncing disks.
>> / $ mkfs.ext3 -N 655360 /dev/sda5
>> mke2fs 1.40 (29-Jun-2007)
>> Filesystem label=
>> OS type: Linux
>> Block size=4096 (log=2)
>> Fragment size=4096 (log=2)
>> 657984 inodes, 14617134 blocks
>> 730856 blocks (5.00%) reserved for the super user
>> First data block=0
>> Maximum filesystem blocks=0
>> 447 block groups
>> 32768 blocks per group, 32768 fragments per group
>> 1472 inodes per group
>> Superblock backups stored on blocks:
>>        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
>> 2654208,
>>        4096000, 7962624, 11239424
>>
>> Writing inode tables: done                           
>> Creating journal (32768 blocks): done
>> Writing superblocks and filesystem accounting information: done
>>
>> This filesystem will be automatically checked every 25 mounts or
>> 180 days, whichever comes first.  Use tune2fs -c or -i to override.
>> / $ mkdir /aaa
>> / $ ifconfig rep0 192.168.253.27
>> mv643xx_eth_if_start: register PHY interrupt rep0 port=1 sw=1 swport=2
>> / $ mount -o nolock 192.168.253.26:/home1 /aaa
>> / $ cd /disk_root/
>> /disk_root $ ls
>> /disk_root $ cd /
>> / $ mount /dev/sda5 /disk_root/
>> kjournald starting.  Commit interval 5 seconds
>> EXT3 FS on sda5, internal journal
>> EXT3-fs: mounted filesystem with ordered data mode.
>> / $ cd /disk_root/
>> /disk_root $ tar -zxf /aaa/target_7xx_cge5.2008-07-10.tgz
>>
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
>> 524288 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata2: soft resetting port
>> ata2.00: configured for UDMA/33
>> ata2: EH complete
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
>> 524288 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata2: soft resetting port
>> ata2.00: configured for UDMA/33
>> ata2: EH complete
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
>> 524288 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata2: soft resetting port
>> ata2.00: configured for UDMA/33
>> ata2: EH complete
>> ata2.00: limiting speed to UDMA/25:PIO4
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
>> 524288 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata2: soft resetting port
>> ata2.00: configured for UDMA/25
>> ata2: EH complete
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
>> 524288 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata2: soft resetting port
>> ata2.00: configured for UDMA/25
>> ata2: EH complete
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
>> 524288 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata2: soft resetting port
>> ata2.00: configured for UDMA/25
>> sd 1:0:0:0: SCSI error: return code = 0x08000002
>> sda: Current [descriptor]: sense key=0xb
>>    ASC=0x0 ASCQ=0x0
>> Descriptor sense data with sense descriptors (in hex):
>>        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>>        00 00 00 00
>> end_request: I/O error, dev sda, sector 19459864
>> Buffer I/O error on device sda5, logical block 2398337
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398338
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398339
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398340
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398341
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398342
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398343
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398344
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398345
>> lost page write due to I/O error on sda5
>> Buffer I/O error on device sda5, logical block 2398346
>> lost page write due to I/O error on sda5
>> ata2: EH complete
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata2.00: cmd ca/00:f8:18:f3:28/00:00:00:00:00/e1 tag 0 cdb 0x0 data 
>> 126976 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata2: soft resetting port
>> ata2.00: configured for UDMA/25
>> ata2: EH complete
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata2.00: cmd ca/00:f8:18:f3:28/00:00:00:00:00/e1 tag 0 cdb 0x0 data 
>> 126976 out
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata2: soft resetting port
>> ata2.00: configured for UDMA/25
>> ata2: EH complete
>>     
>
> Alan and Jeff, I didn't receive your reply till now. I'm not sure you are 
> still intrested on this issue. If you would like to get more information,
> pls let me know. 
>
> I tested it for almost one day and found same issue on 100GB and 60GB
> disk. So I have to think about interrupt lost inside i8259. Then I changed
> code of i8259 for several time and tested it and unfortunately same issue
> was there. I don't have good ideas now. If you would like, I can show you
> the code about i8259 interrupt handling. 
>
> The suspecting point of mine on i8259 is: when multiple interrupts are asserted
> on slave controller. Non-specific EOI will clear all pending interrupts or just
> clear that one in ISR?
>
> Gavin
>   
I also turned on the debugging options and got following output when 
timeout happened.

ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata2
ata_sg_setup: 101 sg elements mapped
ata_fill_sg: PRD[0] = (0x1BF7E000, 0x1000)
ata_fill_sg: PRD[1] = (0x1BDFB000, 0x1000)
ata_fill_sg: PRD[2] = (0x1BB05000, 0x1000)
ata_fill_sg: PRD[3] = (0x1B80C000, 0x1000)
ata_fill_sg: PRD[4] = (0x1C251000, 0x1000)
ata_fill_sg: PRD[5] = (0x1BB04000, 0x1000)
ata_fill_sg: PRD[6] = (0x1C289000, 0x1000)
ata_fill_sg: PRD[7] = (0x1C288000, 0x1000)
ata_fill_sg: PRD[8] = (0x1BE95000, 0x1000)
ata_fill_sg: PRD[9] = (0x1BE94000, 0x1000)
ata_fill_sg: PRD[10] = (0x1BE97000, 0x1000)
ata_fill_sg: PRD[11] = (0x1BE96000, 0x1000)
ata_fill_sg: PRD[12] = (0x1BF31000, 0x1000)
ata_fill_sg: PRD[13] = (0x1BF30000, 0x1000)
ata_fill_sg: PRD[14] = (0x1BF33000, 0x1000)
ata_fill_sg: PRD[15] = (0x1B80D000, 0x1000)
ata_fill_sg: PRD[16] = (0x1B803000, 0x1000)
ata_fill_sg: PRD[17] = (0x1B914000, 0x1000)
ata_fill_sg: PRD[18] = (0x1BF7D000, 0x1000)
ata_fill_sg: PRD[19] = (0x1B915000, 0x1000)
ata_fill_sg: PRD[20] = (0x1B80E000, 0x1000)
ata_fill_sg: PRD[21] = (0x1BF7C000, 0x1000)
ata_fill_sg: PRD[22] = (0x1B844000, 0x1000)
ata_fill_sg: PRD[23] = (0x1B80F000, 0x1000)
ata_fill_sg: PRD[24] = (0x1B846000, 0x1000)
ata_fill_sg: PRD[25] = (0x1B845000, 0x1000)
ata_fill_sg: PRD[26] = (0x1B874000, 0x1000)
ata_fill_sg: PRD[27] = (0x1B847000, 0x1000)
ata_fill_sg: PRD[28] = (0x1B876000, 0x1000)
ata_fill_sg: PRD[29] = (0x1B875000, 0x1000)
ata_fill_sg: PRD[30] = (0x1B800000, 0x1000)
ata_fill_sg: PRD[31] = (0x1B877000, 0x1000)
ata_fill_sg: PRD[32] = (0x1BAD2000, 0x2000)
ata_fill_sg: PRD[33] = (0x1B802000, 0x1000)
ata_fill_sg: PRD[34] = (0x1BAC4000, 0x1000)
ata_fill_sg: PRD[35] = (0x1B916000, 0x1000)
ata_fill_sg: PRD[36] = (0x1B801000, 0x1000)
ata_fill_sg: PRD[37] = (0x1B8F0000, 0x1000)
ata_fill_sg: PRD[38] = (0x1B917000, 0x1000)
ata_fill_sg: PRD[39] = (0x1B8F2000, 0x1000)
ata_fill_sg: PRD[40] = (0x1B8F1000, 0x1000)
ata_fill_sg: PRD[41] = (0x1B92C000, 0x1000)
ata_fill_sg: PRD[42] = (0x1B8F3000, 0x1000)
ata_fill_sg: PRD[43] = (0x1B92E000, 0x1000)
ata_fill_sg: PRD[44] = (0x1B92D000, 0x1000)
ata_fill_sg: PRD[45] = (0x1BA70000, 0x1000)
ata_fill_sg: PRD[46] = (0x1B92F000, 0x1000)
ata_fill_sg: PRD[47] = (0x1BAD1000, 0x1000)
ata_fill_sg: PRD[48] = (0x1BAD0000, 0x1000)
ata_fill_sg: PRD[49] = (0x1BAC5000, 0x1000)
ata_fill_sg: PRD[50] = (0x1C714000, 0x1000)
ata_fill_sg: PRD[51] = (0x1BAC7000, 0x1000)
ata_fill_sg: PRD[52] = (0x1BAC6000, 0x1000)
ata_fill_sg: PRD[53] = (0x1BAF1000, 0x1000)
ata_fill_sg: PRD[54] = (0x1BAF0000, 0x1000)
ata_fill_sg: PRD[55] = (0x1BAF3000, 0x1000)
ata_fill_sg: PRD[56] = (0x1BAF2000, 0x1000)
ata_fill_sg: PRD[57] = (0x1C765000, 0x1000)
ata_fill_sg: PRD[58] = (0x1C764000, 0x1000)
ata_fill_sg: PRD[59] = (0x1C767000, 0x1000)
ata_fill_sg: PRD[60] = (0x1C766000, 0x1000)
ata_fill_sg: PRD[61] = (0x1C719000, 0x1000)
ata_fill_sg: PRD[62] = (0x1C718000, 0x1000)
ata_fill_sg: PRD[63] = (0x1C6D2000, 0x1000)
ata_fill_sg: PRD[64] = (0x1BDF5000, 0x1000)
ata_fill_sg: PRD[65] = (0x1C6E9000, 0x2000)
ata_fill_sg: PRD[66] = (0x1BE70000, 0x1000)
ata_fill_sg: PRD[67] = (0x1BDF7000, 0x1000)
ata_fill_sg: PRD[68] = (0x1BE72000, 0x1000)
ata_fill_sg: PRD[69] = (0x1BE71000, 0x1000)
ata_fill_sg: PRD[70] = (0x1BE74000, 0x1000)
ata_fill_sg: PRD[71] = (0x1BE73000, 0x1000)
ata_fill_sg: PRD[72] = (0x1AF3C000, 0x1000)
ata_fill_sg: PRD[73] = (0x1AF43000, 0x1000)
ata_fill_sg: PRD[74] = (0x1B6E4000, 0x1000)
ata_fill_sg: PRD[75] = (0x1B6E3000, 0x1000)
ata_fill_sg: PRD[76] = (0x1B6E6000, 0x1000)
ata_fill_sg: PRD[77] = (0x1B7A2000, 0x1000)
ata_fill_sg: PRD[78] = (0x1B7A4000, 0x1000)
ata_fill_sg: PRD[79] = (0x1B678000, 0x1000)
ata_fill_sg: PRD[80] = (0x1B4C6000, 0x2000)
ata_fill_sg: PRD[81] = (0x1AEE4000, 0x1000)
ata_fill_sg: PRD[82] = (0x1B4F5000, 0x1000)
ata_fill_sg: PRD[83] = (0x1AF03000, 0x1000)
ata_fill_sg: PRD[84] = (0x1AEFC000, 0x1000)
ata_fill_sg: PRD[85] = (0x1B7A6000, 0x1000)
ata_fill_sg: PRD[86] = (0x1B0D5000, 0x1000)
ata_fill_sg: PRD[87] = (0x1B0D1000, 0x1000)
ata_fill_sg: PRD[88] = (0x1B118000, 0x1000)
ata_fill_sg: PRD[89] = (0x1B0D6000, 0x1000)
ata_fill_sg: PRD[90] = (0x1B11C000, 0x1000)
ata_fill_sg: PRD[91] = (0x1B11A000, 0x1000)
ata_fill_sg: PRD[92] = (0x1B11E000, 0x1000)
ata_fill_sg: PRD[93] = (0x1B0D2000, 0x1000)
ata_fill_sg: PRD[94] = (0x1AF21000, 0x1000)
ata_fill_sg: PRD[95] = (0x1AF4F000, 0x1000)
ata_fill_sg: PRD[96] = (0x1AF4D000, 0x1000)
ata_fill_sg: PRD[97] = (0x1AFE8000, 0x1000)
ata_fill_sg: PRD[98] = (0x1AFEA000, 0x1000)
ata_fill_sg: PRD[99] = (0x1AA8C000, 0x1000)
ata_fill_sg: PRD[100] = (0x1A840000, 0x1000)
ata2: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: hob: feat 0x0 nsect 0x3, lba 0x0 0x0 0x0
ata_tf_load: feat 0x0 nsect 0x40 lba 0xAD 0x75 0xEC
ata_tf_load: device 0xE0
ata_exec_command: ata2: cmd 0x35
ata_scsi_translate: EXIT

ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
ata_port_flush_task: flush #1
__ata_port_freeze: ata2 port frozen
ata_eh_autopsy: ENTER
ata_eh_autopsy: EXIT
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd 35/00:40:ad:75:ec/00:03:00:00:00/e0 tag 0 cdb 0x0 data 
425984 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata_eh_recover: ENTER
__ata_port_freeze: ata2 port frozen
ata2: soft resetting port

