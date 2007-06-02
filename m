Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXFBCOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXFBCOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 22:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759776AbXFBCOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 22:14:04 -0400
Received: from pan.gwi.net ([207.5.128.165]:1383 "EHLO pan.gwi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759709AbXFBCOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 22:14:03 -0400
X-Greylist: delayed 5424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2007 22:14:03 EDT
Subject: first one disk drops our of raid, then the other - I/O error on
	same sector. raid bug?
From: Brad Langhorst <brad@langhorst.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 01 Jun 2007 20:43:08 -0400
Message-Id: <1180744988.6830.183.camel@upup>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a debian stable system in production. Kernel 2.6.18.
I upgraded the kernel from 2.6.8 to 2.6.18 about 2 weeks ago and saw no
problems until today.


May 30 12:58:00 bitc kernel: (scsi0:A:1:0): Unexpected busfree in
Command phase
May 30 12:58:00 bitc kernel: SEQADDR == 0x16c
May 30 12:58:00 bitc kernel: sd 0:0:1:0: SCSI error: return code =
0x00010000
May 30 12:58:00 bitc kernel: end_request: I/O error, dev sdb, sector
287322317
May 30 12:58:00 bitc kernel: raid1: Disk failure on sdb2, disabling
device. 
May 30 12:58:00 bitc kernel: ^IOperation continuing on 1 devices
May 30 12:58:01 bitc kernel: sd 0:0:1:0: SCSI error: return code =
0x00010000
May 30 12:58:01 bitc kernel: end_request: I/O error, dev sdb, sector
284758725
May 30 12:58:01 bitc kernel: RAID1 conf printout:
May 30 12:58:01 bitc kernel:  --- wd:1 rd:2
May 30 12:58:01 bitc kernel:  disk 0, wo:0, o:1, dev:sda2
May 30 12:58:01 bitc kernel:  disk 1, wo:1, o:0, dev:sdb2
May 30 12:58:01 bitc kernel: RAID1 conf printout:
May 30 12:58:01 bitc kernel:  --- wd:1 rd:2
May 30 12:58:01 bitc kernel:  disk 0, wo:0, o:1, dev:sda2

I can add /dev/sdb back

May 30 17:14:17 bitc kernel: md: md1: sync done.
May 30 17:14:17 bitc kernel: RAID1 conf printout:
May 30 17:14:17 bitc kernel:  --- wd:2 rd:2
May 30 17:14:17 bitc kernel:  disk 0, wo:0, o:1, dev:sda2
May 30 17:14:17 bitc kernel:  disk 1, wo:0, o:1, dev:sdb2

thenk /dev/sda fell out!

May 31 02:37:06 bitc kernel: (scsi0:A:0:0): Unexpected busfree in
Command phase
May 31 02:37:06 bitc kernel: SEQADDR == 0x16c
May 31 02:37:06 bitc kernel: sd 0:0:0:0: SCSI error: return code =
0x00010000
May 31 02:37:06 bitc kernel: end_request: I/O error, dev sda, sector
287322317
May 31 02:37:06 bitc kernel: raid1: Disk failure on sda2, disabling
device. 
May 31 02:37:06 bitc kernel: ^IOperation continuing on 1 devices
May 31 02:37:06 bitc kernel: sd 0:0:0:0: SCSI error: return code =
0x00010000
May 31 02:37:06 bitc kernel: end_request: I/O error, dev sda, sector
276325445
May 31 02:37:06 bitc kernel: RAID1 conf printout:
May 31 02:37:06 bitc kernel:  --- wd:1 rd:2
May 31 02:37:06 bitc kernel:  disk 0, wo:1, o:0, dev:sda2
May 31 02:37:06 bitc kernel:  disk 1, wo:0, o:1, dev:sdb2
May 31 02:37:06 bitc kernel: RAID1 conf printout:
May 31 02:37:06 bitc kernel:  --- wd:1 rd:2
May 31 02:37:06 bitc kernel:  disk 1, wo:0, o:1, dev:sdb2

Note that the first error is at the same sector for both disks
287322317(sda) = 287322317(sdb)
but the second one is at a different spot 
276325445(sda) != 284758725(sbd)

it seems unlikely that both disks have exactly the same bad sector 

Maybe a disk is failing, but smart doesn't show a big difference in ECC
errors between the two disks.  Seems wrong that the kernel raid should
first drop one disk, then the other if one disk is really failing.

Is this a bug?

Brad



