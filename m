Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbXLGNPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbXLGNPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 08:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXLGNPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 08:15:46 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:2576 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXLGNPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 08:15:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 07 Dec 2007 13:15:43.0257 (UTC) FILETIME=[4555E090:01C838D3]
Content-class: urn:content-classes:message
Subject: Possible EXT2 race
Date: Fri, 7 Dec 2007 08:15:42 -0500
Message-ID: <Pine.LNX.4.61.0712070808030.4642@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Possible EXT2 race
thread-index: Acg400VfgdMSqmnEQGOkKaCVo7RL7w==
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On linux-2.6.22.1, executing the following script
while the mailer is writing to /var/spool/mail/linux-os.....


#!/bin/bash
while true ;
do
    >/var/spool/mail/linux-os;
    sleep 1;
done

...will cause the following errors to occur.

Dec  7 04:05:55 chaos kernel: sd 0:0:1:0: [sdb] Sense Key : No Sense [deferred] 
Dec  7 04:05:55 chaos kernel: Info fld=0x1980240
Dec  7 04:05:55 chaos kernel: sd 0:0:1:0: [sdb] Add. Sense: Peripheral device write fault
Dec  7 04:08:13 chaos kernel: attempt to access beyond end of device
Dec  7 04:08:13 chaos kernel: sdb1: rw=0, want=29687515944, limit=33736437
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_xattr_delete_inode: inode 656387: block -584027804 read error
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_free_blocks: Freeing blocks not in datazone - block = 3710940964, count = 1
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_free_blocks: Freeing blocks not in datazone - block = 4294967295, count = 1
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_free_blocks: Freeing blocks not in datazone - block = 4294967295, count = 1
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_free_blocks: Freeing blocks not in datazone - block = 3710940980, count = 1
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_free_blocks: Freeing blocks not in datazone - block = 3710940980, count = 1
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_free_blocks: bit already cleared for block 1
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_free_blocks: Freeing blocks not in datazone - block = 3710941012, count = 1
Dec  7 04:08:13 chaos kernel: attempt to access beyond end of device
Dec  7 04:08:13 chaos kernel: sdb1: rw=0, want=29687528104, limit=33736437
Dec  7 04:08:13 chaos kernel: EXT2-fs error (device sdb1): ext2_free_branches: Read failure, inode=656399, block=-584026284
Dec  7 04:08:13 chaos kernel: attempt to access beyond end of device
Dec  7 04:08:13 chaos kernel: sdb1: rw=0, want=29687529288, limit=33736437
Dec  7 04:08:15 chaos kernel: EXT2-fs error (device sdb1): ext2_xattr_delete_inode: inode 656400: block -584026136 read error
Dec  7 04:08:18 chaos kernel: EXT2-fs error (device sdb1): ext2_xattr_delete_inode: inode 656403: bad block 30188


Caution is advised when testing because this destroyed a filesystem,
making it unfixable by `fsck`.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
