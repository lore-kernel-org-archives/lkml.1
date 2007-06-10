Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbXFJNo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbXFJNo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXFJNoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:44:21 -0400
Received: from web54502.mail.re2.yahoo.com ([206.190.49.152]:23755 "HELO
	web54502.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753407AbXFJNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:44:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=FLrRaIfLOqiYCOTLPxWgkVY0qnBJlAHUV/viYEfLaRQAXnDFTSRiL/MvXzVPguuMFjaDENiailhGVkPYoQCC4BfWi7ZMZ6+EeFuu7lat8K7DkNdML2a/cuf/0dxP+u9dXJv2P8QTdkXDEFdDx1mzKe5d45BIPMYzSBOEBGKJ5to=;
X-YMail-OSG: mSRxypcVM1lrycdS7ivIHwDb7RbrRRRaawjkvsz9SL453X_tehSFvmI3BlhW0Qb.qg--
Date: Sun, 10 Jun 2007 20:35:01 +0900 (KST)
From: yong Jung <yong_jk@yahoo.com>
Subject: SETMAX.C seems not support SATA
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Message-ID: <228420.83693.qm@web54502.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
.
I tried this SETMAX.C program in order to delete HPA
area. 
But some commands failed cause of "No such file or
directory" or "Input/output error" even though kernel
detect HPA and the whole disk information.
I am using SATA drive, 250GB with Fedora 7.
Could you please give me more information ?
I need setmax.c to disable hpa area.
I do appreicate your kind help.
Here is my testings.
...............
[root@localhost temp]# uname -a
Linux localhost.localdomain 2.6.21-1.3194.fc7 #1 SMP
Wed May 23 22:35:01 EDT 2007 i686 i686 i386 GNU/Linux
.................
ata3.00: ata_hpa_resize 1: sectors = 467348955,
hpa_sectors = 488397168
ata3.00: Host Protected Area detected:
        current size: 467348955 sectors
        native size: 488397168 sectors
ata3.00: ATA-7: SAMSUNG SP2504C, VT100-50, max UDMA7
ata3.00: 467348955 sectors, multi 16: LBA48 NCQ (depth
0/32)
ata3.00: ata_hpa_resize 1: sectors = 467348955,
hpa_sectors = 488397168
ata3.00: Host Protected Area detected:
        current size: 467348955 sectors
        native size: 488397168 sectors
................
[root@localhost temp]# df
Filesystem           1K-blocks      Used Available
Use% Mounted on
/dev/sda3             21521440   3568596  16841952 
18% /
/dev/sda2               101105     11560     84324 
13% /boot
tmpfs                   451808         0    451808  
0% /dev/shm
...........................
[root@localhost temp]# ./setmax -d 0 /dev/sda
Using device /dev/sda
setting delta=0
nativemax=251658240 (0xf000000)
HDIO_DRIVE_CMD_AEB failed SET_MAX: Input/output error
81 = 0x51
0 = 0x0
0 = 0x0
0 = 0x0
0 = 0x0
0 = 0x0
79 = 0x4f
[root@localhost temp]#
..................................................
[root@localhost temp]# ./setmax -delta 488397168
/dev/sda
Using device 488397168
open: No such file or directory
...................
[root@localhost temp]# ./setmax /dev/sda
Using device /dev/sda
native max address: 251658240
that is 128849019392 bytes, 128.8 GB
lba capacity: 268435455 sectors (137438952960 bytes)
[root@localhost temp]# df
Filesystem           1K-blocks      Used Available
Use% Mounted on
/dev/sda3             21521440   3568800  16841748 
18% /
/dev/sda2               101105     11560     84324 
13% /boot
tmpfs                   451808         0    451808  
0% /dev/shm
.....................
[root@localhost temp]# fdisk -l
Disk /dev/sda: 239.2 GB, 239282664960 bytes
255 heads, 63 sectors/track, 29091 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id
 System
/dev/sda1   *           1       26181   210298851    7
 HPFS/NTFS
/dev/sda2           26182       26194      104422+  83
 Linux
/dev/sda3           26195       28960    22217895   83
 Linux
/dev/sda4           28961       29091     1052257+   5
 Extended
/dev/sda5           28961       29091     1052226   82
 Linux swap / Solaris
[root@localhost temp]#
.................
Friendly,
Nobel





      ________________________________________________________ 
180도 달라진 야후! 메일 - 여러 개의 메시지를 동시에 확인? 새로운 야후! 메일의 탭으로 가능해집니다.
http://kr.content.mail.yahoo.com/cgland
