Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbXBMRgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbXBMRgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXBMRgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:36:48 -0500
Received: from guri.is.scarlet.be ([193.74.71.22]:44139 "EHLO
	guri.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbXBMRgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:36:47 -0500
Message-ID: <45D1F6E4.2080102@scarlet.be>
Date: Tue, 13 Feb 2007 17:35:32 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Joel Soete <soete.joel@scarlet.be>
CC: Tejun Heo <htejun@gmail.com>, Luming Yu <luming.yu@gmail.com>,
       Alan Cox <alan@redhat.com>, Ioan Ionita <opslynx@gmail.com>,
       Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>	 <20061116235048.3cd91beb@localhost.localdomain>	 <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com>	 <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com>	 <20061117100559.GA10275@devserv.devel.redhat.com>	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>	 <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com> <45BB64F1.1000105@scarlet.be> <45CFBBD1.5090703@gmail.com> <45D0D133.8070801@scarlet.be>
In-Reply-To: <45D0D133.8070801@scarlet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

A small update:
your patch also works against 2.6.20

but seems that open the door to numerous other pb:
1/ pb to burn cd:
# md5sum cd060213.iso
6a1248783a21722816b972aa9bae9d5e  cd060213.iso

# ll cd060213.iso
-rwxr-xr-x 1 root root 3213312 Feb 13  2006 cd060213.iso

# dd if=/dev/sr0 bs=1 count=3213312 | md5sum
dd: reading `/dev/sr0': Input/output error
0337e9846d17779945c5c252d4f897f0  -
3129344+0 records in
3129344+0 records out
3129344 bytes (3.1 MB) copied, 36.6963 seconds, 85.3 kB/s

eventhought cdrecord seems to be successfull???

2/ (but that should be much more related to scsi api) sdcXX > sdc15 doesn't works ;-(
# sfdisk -l /dev/sdc

Disk /dev/sdc: 1826 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

    Device Boot Start     End   #cyls    #blocks   Id  System
/dev/sdc1   *      0+    195     196-   1574338+   b  W95 FAT32
/dev/sdc2        196    1825    1630   13092975    5  Extended
/dev/sdc3          0       -       0          0    0  Empty
/dev/sdc4          0       -       0          0    0  Empty
/dev/sdc5   *    196+    197       2-     16033+  83  Linux
/dev/sdc6   *    198+    199       2-     16033+  83  Linux
/dev/sdc7        200+    201       2-     16033+  83  Linux
/dev/sdc8        202+    217      16-    128488+  82  Linux swap / Solaris
/dev/sdc9        218+    478     261-   2096451   83  Linux
/dev/sdc10       479+    486       8-     64228+  83  Linux
/dev/sdc11       487+    488       2-     16033+  83  Linux
/dev/sdc12       489+    504      16-    128488+  83  Linux
/dev/sdc13       505+    618     114-    915673+  83  Linux
/dev/sdc14       619+    620       2-     16033+  83  Linux
/dev/sdc15       621+    636      16-    128488+  83  Linux
/dev/sdc16       637+    644       8-     64228+  83  Linux
/dev/sdc17       645+    646       2-     16033+  83  Linux
/dev/sdc18       647+    654       8-     64228+  83  Linux
/dev/sdc19       655+    656       2-     16033+  83  Linux
/dev/sdc20       657+    773     117-    939771   83  Linux
/dev/sdc21       774+    789      16-    128488+  83  Linux
/dev/sdc22       790+    880      91-    730926   83  Linux
/dev/sdc23       881+   1533     653-   5245191   83  Linux
/dev/sdc24      1795    1825      31     249007+  83  Linux

# mount /dev/sdc22 /4free
mount: /dev/sdc22 is not a valid block device

# ll /dev/sdc*
brw-rw---- 1 root disk 8, 32 Dec  1  2001 /dev/sdc
brw-rw---- 1 root disk 8, 33 Dec  1  2001 /dev/sdc1
brw-rw---- 1 root disk 8, 42 Dec  1  2001 /dev/sdc10
brw-rw---- 1 root disk 8, 43 Dec  1  2001 /dev/sdc11
brw-rw---- 1 root disk 8, 44 Dec  1  2001 /dev/sdc12
brw-rw---- 1 root disk 8, 45 Dec  1  2001 /dev/sdc13
brw-rw---- 1 root disk 8, 46 Dec  1  2001 /dev/sdc14
brw-rw---- 1 root disk 8, 47 Dec  1  2001 /dev/sdc15
brw-r--r-- 1 root root 8, 48 Feb 13 16:26 /dev/sdc16
brw-r--r-- 1 root root 8, 49 Feb 13 16:26 /dev/sdc17
brw-r--r-- 1 root root 8, 50 Feb 13 16:26 /dev/sdc18
brw-r--r-- 1 root root 8, 51 Feb 13 16:27 /dev/sdc19
brw-rw---- 1 root disk 8, 34 Dec  1  2001 /dev/sdc2
brw-r--r-- 1 root root 8, 52 Feb 13 16:27 /dev/sdc20
brw-r--r-- 1 root root 8, 53 Feb 13 16:27 /dev/sdc21
brw-r--r-- 1 root root 8, 54 Feb 13 16:27 /dev/sdc22
brw-r--r-- 1 root root 8, 55 Feb 13 16:27 /dev/sdc23
brw-r--r-- 1 root root 8, 56 Feb 13 16:27 /dev/sdc24
brw-rw---- 1 root disk 8, 35 Dec  1  2001 /dev/sdc3
brw-rw---- 1 root disk 8, 36 Dec  1  2001 /dev/sdc4
brw-rw---- 1 root disk 8, 37 Dec  1  2001 /dev/sdc5
brw-rw---- 1 root disk 8, 38 Dec  1  2001 /dev/sdc6
brw-rw---- 1 root disk 8, 39 Dec  1  2001 /dev/sdc7
brw-rw---- 1 root disk 8, 40 Dec  1  2001 /dev/sdc8
brw-rw---- 1 root disk 8, 41 Dec  1  2001 /dev/sdc9

# dmesg
[snip]
scsi3 : ata_piix
ata1.00: ATA-4, max UDMA/66, 29336832 sectors: LBA
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/33
scsi4 : ata_piix
ata2.01: ATAPI, max MWDMA1
ata2.01: configured for MWDMA1
scsi 3:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A03. PQ: 0 ANSI: 5
SCSI device sdc: 29336832 512-byte hdwr sectors (15020 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 29336832 512-byte hdwr sectors (15020 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 sdc11 sdc12 sdc13 sdc14 sdc15 >
sd 3:0:0:0: Attached scsi disk sdc
sd 3:0:0:0: Attached scsi generic sg2 type 0
[snip]

I will try to have a look later.

Cheers,
	Joel

Joel Soete wrote:
> 
> 
> Tejun Heo wrote:
>> Please test the attached patch over 2.6.20.
>>
>> Thanks.
>>
> It's already too late so quick and dirty rebuild of 2.6.20-git6 (failled 
> before your patch) but now your patch fixe the pb:
> [snip]
> ata_piix 0000:00:07.1: version 2.00ac7
> ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 
> irq 14
> ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 
> irq 15
> scsi3 : ata_piix
> ata1.00: ATA-4: QUANTUM FIREBALLlct10 15, A03.0900, max UDMA/66
> ata1.00: 29336832 sectors, multi 16: LBA
> ata1.00: configured for UDMA/33
> scsi4 : ata_piix
> ata2.01: ATAPI, max MWDMA1
> ata2.01: configured for MWDMA1
> scsi 3:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A03. PQ: 0 
> ANSI: 5
> SCSI device sdc: 29336832 512-byte hdwr sectors (15020 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 3a 00 00
> SCSI device sdc: write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> SCSI device sdc: 29336832 512-byte hdwr sectors (15020 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 3a 00 00
> SCSI device sdc: write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
>  sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 sdc11 sdc12 sdc13 sdc14 
> sdc15 >
> sd 3:0:0:0: Attached scsi disk sdc
> sd 3:0:0:0: Attached scsi generic sg2 type 0
> scsi 4:0:1:0: CD-ROM            PHILIPS  CDD3610 CD-R/RW  3.09 PQ: 0 
> ANSI: 5
> sr0: scsi3-mmc drive: 6x/6x writer cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 4:0:1:0: Attached scsi CD-ROM sr0
> sr 4:0:1:0: Attached scsi generic sg3 type 5
> [snip]
> 
> cool ;-)
> 
> Sorry, I will try later against 2.6.20 (i guess it will also fixe the 
> pb) and attempt to burn a cd.
> I will advise you asap.
> 
> Thanks again,
>     Joel
> 
> 
