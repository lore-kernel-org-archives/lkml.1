Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbYEPPK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbYEPPK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763083AbYEPOzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:55:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:37411 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYEPOzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:55:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iOwZee2hBlFm2ldnISM8k2ERZkoQXBawRMoKoe1XHpYhn97UpM27lGSlPXiF2S2QQ2KNyoNwQIwCzo3cFSddY9v5MRGJyqmCgkda3TqInAhbyrlv4+I+mvDETf++iRpHXUra/trvk6bZucJVzbc5Eggvm/sA2tIoK6cVBz6ha6s=
Message-ID: <8db1092f0805160755u54914884ibe1ed8a23b8e1015@mail.gmail.com>
Date: Fri, 16 May 2008 16:55:36 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [Re: Linux 2.6.26-rc2] Write protect on on
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4GFB3EB004572

I have external drive connected via USB to computer. In 2.6.25.4 whenI plug into computer works fine, and have this messages in dmesg:usb 5-1: new high speed USB device using ehci_hcd and address 4usb 5-1: configuration #1 chosen from 1 choiceInitializing USB Mass Storage driver...scsi2 : SCSI emulation for USB Mass Storage devicesusbcore: registered new interface driver usb-storageUSB Mass Storage support registered.usb-storage: device found at 4usb-storage: waiting for device to settle before scanningscsi 2:0:0:0: Direct-Access     Initio   MHV2080BH PL     3.01 PQ: 0 ANSI: 0usb-storage: device scan completeDriver 'sd' needs updating - please use bus_type methodssd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)sd 2:0:0:0: [sda] Write Protect is offsd 2:0:0:0: [sda] Mode Sense: 00 00 00 00sd 2:0:0:0: [sda] Assuming drive cache: write throughsd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)sd 2:0:0:0: [sda] Write Protect is offsd 2:0:0:0: [sda] Mode Sense: 00 00 00 00sd 2:0:0:0: [sda] Assuming drive cache: write through sda: sda1sd 2:0:0:0: [sda] Attached SCSI disk
Works fine:maciek@zlom:~/kernel.org/2.6.25.4$ ntfsmount /dev/sda1 ~/mnt/ntfs/maciek@zlom:~/kernel.org/2.6.25.4$ mount | grep fusefusectl on /sys/fs/fuse/connections type fusectl (rw)/dev/sda1 on /home/maciek/mnt/ntfs type fuseblk(rw,nosuid,nodev,default_permissions,allow_other,blksize=4096,user=maciek)
But on 2.6.26-rc* sometimes I have messages "Write protect is on", e.g.:sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)sd 2:0:0:0: [sda] Write Protect is onsd 2:0:0:0: [sda] Mode Sense: 09 50 f8 afsd 2:0:0:0: [sda] Assuming drive cache: write throughsd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)sd 2:0:0:0: [sda] Write Protect is offsd 2:0:0:0: [sda] Mode Sense: 00 00 00 00sd 2:0:0:0: [sda] Assuming drive cache: write through sda: sda1sd 2:0:0:0: [sda] Attached SCSI disk
or:sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)sd 2:0:0:0: [sda] Write Protect is onsd 2:0:0:0: [sda] Mode Sense: 09 50 f8 afsd 2:0:0:0: [sda] Assuming drive cache: write throughsd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)sd 2:0:0:0: [sda] Write Protect is onsd 2:0:0:0: [sda] Mode Sense: 09 50 f8 afsd 2:0:0:0: [sda] Assuming drive cache: write through sda: sda1sd 2:0:0:0: [sda] Attached SCSI disk
Then mount fails:maciek@zlom:~/kernel.org/2.6.26-rc2$ ntfsmount /dev/sda1 ~/mnt/ntfs/Error opening partition device: System plikÃ³w wyÅ‚Ä…cznie do odczytu.Failed to startup volume: System plikÃ³w wyÅ‚Ä…cznie do odczytu.Failed to mount '/dev/sda1': System plikÃ³w wyÅ‚Ä…cznie do odczytu.Mount failed.
"System plikÃ³w wyÅ‚Ä…cznie do odczytu." means "filesystem readonly"
Tested on two computers PC and laptop.
Dmesg and config:2.6.25.4: http://unixy.pl/maciek/download/kernel/2.6.25.4/2.6.26-rc1: http://unixy.pl/maciek/download/kernel/2.6.26-rc1/2.6.26-rc2: http://unixy.pl/maciek/download/kernel/2.6.26-rc2/
-- Maciej Ruteckihttp://www.maciek.unixy.plÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
