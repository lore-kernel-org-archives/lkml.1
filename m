Return-Path: <linux-kernel-owner+w=401wt.eu-S1031388AbXDZSDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031388AbXDZSDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031392AbXDZSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:03:17 -0400
Received: from tag.witbe.net ([81.88.96.48]:44091 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031388AbXDZSDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:03:15 -0400
X-Greylist: delayed 3034 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 14:03:15 EDT
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'LKML'" <linux-kernel@vger.kernel.org>
Cc: <rol@as2917.net>
Subject: Strange problem with Device Mapper
Date: Thu, 26 Apr 2007 19:12:27 +0200
Organization: AS2917.net
Message-ID: <006001c78826$13f50cf0$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AceIJhDRPpzDOV5cQmm0XhUokMOy4w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've a machine that has been installed with Intel Soft Raid on top
of 2 SATA disks.
I'm trying to have this work as a RAID-1 array. 
Bios configuration has been done, using 128K chunk, and the kernel
(2.6.20.7) sees perfectly /dev/mapper/isw_xxxxxxxx_RAID1

But, I'm facing two problems :
1 - If i try to create partitions on this device, it does fail (the 
    values are not interpreted correctly)

2 - To avoid 1), I stop the RAID array (dmraid -an), then I do create
    exactly the same partition set on /dev/sda, and /dev/sdb, and
    then I reactivate RAID (dmraid -ay).
    This allows me to see all the /dev/mapper/isw_xxxxxxx_RAID1p1, p2, ...
    But, running fsck -t ext2 /dev/mapper/isw_xxxxxxx_RAID1p1
    ends in a lock when the partition is larger than 10Go (well, it is
    Ok on the 10Go one, and it locks on the 100Go).
    Not a real hardlock, I still can switch to a new VC, but it's not
    more possible to start a new command or to stop fsck.

Should I do everything on the physical disks before activating RAID ?
Is it a normal behavior ?

BTW, I also noticed that such a device doesn't support BLKRRPART ioctl...
So it is possible that what I'm doing is wrong...

Any idea ?

Regards,
Paul

