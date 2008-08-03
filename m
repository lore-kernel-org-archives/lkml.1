Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYHCOPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYHCOPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbYHCOOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:14:51 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:45653 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbYHCOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:14:50 -0400
Message-ID: <007901c8f572$c0f3d020$0100a8c0@microsof291b50>
From: "Gavin Shan" <gshan@alcatel-lucent.com>
To: "gshan" <gshan@alcatel-lucent.com>, "Tejun Heo" <tj@kernel.org>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       <linux-kernel@vger.kernel.org>,
       "Linux IDE mailing list" <linux-ide@vger.kernel.org>
References: <488ED837.2060509@alcatel-lucent.com>	<488F1C6C.9000002@garzik.org>	<48902EB5.8070102@alcatel-lucent.com> <20080730114934.5a593cf4@lxorguk.ukuu.org.uk> <48913FFD.5070901@alcatel-lucent.com> <4892BEBA.2000602@kernel.org> <4892CF2B.9030309@alcatel-lucent.com>
Subject: Re: PIIX4: DMA timeout issue
Date: Sun, 3 Aug 2008 22:10:55 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2530
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m73EF4IG026572

> Unfortunately, the timeout issue still happened on ATA driver as IDE.
> 
> Command (m for help): p
> 
> Disk /dev/sda: 60.0 GB, 60011642880 bytes
> 255 heads, 63 sectors/track, 7296 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x4892c004
> 
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1          17      136521   83  Linux
> /dev/sda4              18        7296    58468567+   5  Extended
> /dev/sda5              18        7296    58468536   83  Linux
> 
> Command (m for help): w
> The partition table has been altered!
> 
> Calling ioctl() to re-read partition table.
> SCSI device sda: 117210240 512-byte hdwr sectors (60012 MB)
> sda: Write Protect is off
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sda: sda1 sda4 < sda5 >
> Syncing disks.
> / $ mkfs.ext3 -N 655360 /dev/sda5
> mke2fs 1.40 (29-Jun-2007)
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> 657984 inodes, 14617134 blocks
> 730856 blocks (5.00%) reserved for the super user
> First data block=0
> Maximum filesystem blocks=0
> 447 block groups
> 32768 blocks per group, 32768 fragments per group
> 1472 inodes per group
> Superblock backups stored on blocks:
>        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
> 2654208,
>        4096000, 7962624, 11239424
> 
> Writing inode tables: done                           
> Creating journal (32768 blocks): done
> Writing superblocks and filesystem accounting information: done
> 
> This filesystem will be automatically checked every 25 mounts or
> 180 days, whichever comes first.  Use tune2fs -c or -i to override.
> / $ mkdir /aaa
> / $ ifconfig rep0 192.168.253.27
> mv643xx_eth_if_start: register PHY interrupt rep0 port=1 sw=1 swport=2
> / $ mount -o nolock 192.168.253.26:/home1 /aaa
> / $ cd /disk_root/
> /disk_root $ ls
> /disk_root $ cd /
> / $ mount /dev/sda5 /disk_root/
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda5, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> / $ cd /disk_root/
> /disk_root $ tar -zxf /aaa/target_7xx_cge5.2008-07-10.tgz
> 
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
> 524288 out
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/33
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
> 524288 out
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/33
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
> 524288 out
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/33
> ata2: EH complete
> ata2.00: limiting speed to UDMA/25:PIO4
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
> 524288 out
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/25
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
> 524288 out
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/25
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd 35/00:00:18:ef:28/00:04:01:00:00/e0 tag 0 cdb 0x0 data 
> 524288 out
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/25
> sd 1:0:0:0: SCSI error: return code = 0x08000002
> sda: Current [descriptor]: sense key=0xb
>    ASC=0x0 ASCQ=0x0
> Descriptor sense data with sense descriptors (in hex):
>        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>        00 00 00 00
> end_request: I/O error, dev sda, sector 19459864
> Buffer I/O error on device sda5, logical block 2398337
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398338
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398339
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398340
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398341
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398342
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398343
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398344
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398345
> lost page write due to I/O error on sda5
> Buffer I/O error on device sda5, logical block 2398346
> lost page write due to I/O error on sda5
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd ca/00:f8:18:f3:28/00:00:00:00:00/e1 tag 0 cdb 0x0 data 
> 126976 out
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/25
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd ca/00:f8:18:f3:28/00:00:00:00:00/e1 tag 0 cdb 0x0 data 
> 126976 out
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/25
> ata2: EH complete

Alan and Jeff, I didn't receive your reply till now. I'm not sure you are 
still intrested on this issue. If you would like to get more information,
pls let me know. 

I tested it for almost one day and found same issue on 100GB and 60GB
disk. So I have to think about interrupt lost inside i8259. Then I changed
code of i8259 for several time and tested it and unfortunately same issue
was there. I don't have good ideas now. If you would like, I can show you
the code about i8259 interrupt handling. 

The suspecting point of mine on i8259 is: when multiple interrupts are asserted
on slave controller. Non-specific EOI will clear all pending interrupts or just
clear that one in ISR?

Gavin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
