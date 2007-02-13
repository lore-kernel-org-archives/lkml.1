Return-Path: <linux-kernel-owner+w=401wt.eu-S1751099AbXBMVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbXBMVvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXBMVvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:51:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:51423 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXBMVvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Bng8n9R6U2/7+nBSB0Ul5oCEW9tRvZTho4Z6Itpfb/9yadaOAfEdIoXwdNFd/hNpKYQSUDv8sZODy9GKwG9QVLc1BNjFAw3U72aU9NXYLAHqOeiUz28zMJps/+gCJuj8Q97+WcvYFaVUY4ZBIvDKPAiwjcSn/Hfu5r0goOY2Z0Q=
Message-ID: <8d158e1f0702131351l3e3e1ae2u71a13de655391fce@mail.gmail.com>
Date: Tue, 13 Feb 2007 22:51:32 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PROBLEM] Can't start MD devices by using /dev/disk/by-id
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi chaps,

I just came home, rebooted my box to git8 and *gasp* a problem :)

I can't start my MD devices anymore by defining /dev/disk/by-id/*
devices in /etc/mdadm.conf.

When I do a: mdadm --assemble /dev/md/1 it tells me "No devices found
for /dev/md/1"
When I edit the file /etc/mdadm.conf and change the /dev/disk/by-id/*
to whatever the symbolic links points to in the /dev directory, it
does work.

An example:

-- mdadm.conf
ARRAY /dev/md/1
devices=/dev/disk/by-id/scsi-SATA_WDC_WD1200JB-00WD-WMAEL2258179-part1,/dev/disk/by-id/scsi-SATA_WDC_WD1200JB-00WD-WMACM1329740-part1
#ARRAY /dev/md/1 devices=/dev/sdb1,/dev/sdf1
ARRAY /dev/md/2 devices=/dev/disk/by-id/scsi-SATA_Maxtor_6L250R0_L609D78H-part1
ARRAY /dev/md/3
devices=/dev/disk/by-id/scsi-SATA_WDCD1600JB-00WD-WMAEK2977810-part1,/dev/disk/by-id/scsi-SATA_Maxtor_6Y160P0_Y48BCM3E-part1
-- end mdadm.conf --

localhost by-id # pwd
/dev/disk/by-id

localhost by-id # mdadm --assemble /dev/md/1
mdadm: no devices found for /dev/md/1


Let's change the config file now

-- mdadm.conf --
#ARRAY /dev/md/1
devices=/dev/disk/by-id/scsi-SATA_WDC_WD1200JB-00WD-WMAEL2258179-part1,/dev/disk/by-id/scsi-SATA_WDC_WD1200JB-00WD-WMACM1329740-part1
ARRAY /dev/md/1 devices=/dev/sdb1,/dev/sdf1
ARRAY /dev/md/2 devices=/dev/disk/by-id/scsi-SATA_Maxtor_6L250R0_L609D78H-part1
ARRAY /dev/md/3
devices=/dev/disk/by-id/scsi-SATA_WDCD1600JB-00WD-WMAEK2977810-part1,/dev/disk/by-id/scsi-SATA_Maxtor_6Y160P0_Y48BCM3E-part1

And
localhost by-id # mdadm --assemble /dev/md/1
mdadm: /dev/md/1 has been started with 2 drives.


Now, granted, it's 22:49 and i had a sucky day at work but... this
doesnt make any sense to me.

So, I tried to use the vanilla 2.6.20 kernel, same problem.

Here is a listing of symbolic links in /dev/disk/by-id , as you can
see the initial mdadm.conf (which worked prior to 2.6.20) should work,
since the links to the actual device nodes seem to be correct and
taking in account the MD devices do start when using the /dev/ nodes.

lrwxrwxrwx 1 root root   9 Feb 12 05:40
scsi-SATA_Maxtor_6L250R0_L609D78H -> ../../sdc
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_Maxtor_6L250R0_L609D78H-part1 -> ../../sdc1
lrwxrwxrwx 1 root root   9 Feb 12 05:40
scsi-SATA_Maxtor_6Y160P0_Y48BCM3E -> ../../sde
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_Maxtor_6Y160P0_Y48BCM3E-part1 -> ../../sde1
lrwxrwxrwx 1 root root   9 Feb 12 05:40
scsi-SATA_WDC_WD1200JB-00WD-WMACM1329740 -> ../../sdf
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD1200JB-00WD-WMACM1329740-part1 -> ../../sdf1
lrwxrwxrwx 1 root root   9 Feb 12 05:40
scsi-SATA_WDC_WD1200JB-00WD-WMAEL2258179 -> ../../sdb
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD1200JB-00WD-WMAEL2258179-part1 -> ../../sdb1
lrwxrwxrwx 1 root root   9 Feb 12 05:40
scsi-SATA_WDC_WD1600JB-00WD-WMAEK2977810 -> ../../sdd
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD1600JB-00WD-WMAEK2977810-part1 -> ../../sdd1
lrwxrwxrwx 1 root root   9 Feb 12 05:40
scsi-SATA_WDC_WD2000JB-00_WD-WCAL81971867 -> ../../sda
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD2000JB-00_WD-WCAL81971867-part1 -> ../../sda1
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD2000JB-00_WD-WCAL81971867-part2 -> ../../sda2
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD2000JB-00_WD-WCAL81971867-part3 -> ../../sda3
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD2000JB-00_WD-WCAL81971867-part4 -> ../../sda4
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD2000JB-00_WD-WCAL81971867-part5 -> ../../sda5
lrwxrwxrwx 1 root root  10 Feb 12 05:40
scsi-SATA_WDC_WD2000JB-00_WD-WCAL81971867-part6 -> ../../sda6
lrwxrwxrwx 1 root root   9 Feb 12 05:40
usb-USB2.0_CardReader_CF_RW_586148026074 -> ../../sdg


Cheers,

Patrick
