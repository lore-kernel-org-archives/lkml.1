Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXFBBi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXFBBi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXFBBiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:38:50 -0400
Received: from mail0.lsil.com ([147.145.40.20]:50719 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbXFBBit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:38:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: LSI MegaRAID problems
Date: Fri, 1 Jun 2007 19:38:24 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229B1389F@NAMAIL2.ad.lsil.com>
In-Reply-To: <1180522777.6308.14.camel@omc-2.omesc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: LSI MegaRAID problems
Thread-Index: Aceiqt3FfsdjI3jFTVO0+DY8DmkFwQCC18CA
From: "Patro, Sumant" <Sumant.Patro@lsi.com>
To: "Jules Colding" <colding@omesc.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Jun 2007 01:38:25.0760 (UTC) FILETIME=[B6957600:01C7A4B6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I suspect the errors are coming because of bad disk(s).  
Driver message indicates "reset" completed successfully.

--Sumant

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jules Colding
Sent: Wednesday, May 30, 2007 4:00 AM
To: linux-kernel
Subject: LSI MegaRAID problems

Hi,

I have a "LSI Logic MegaRAID SCSI 320-4x" adapter with an external raid5
array of 5 Seagate ST336754LW and XFS as fs on it. The device in
question is /dev/sdb and the box is a dual Opteron 252.

I've recently started to see this in the log almost whenever I touch the
filesystem:

May 30 12:22:56 omc-2 [ 1120.991356] megaraid: aborting-109150 cmd=28
<c=4 t=1 l=0> May 30 12:22:56 omc-2 [ 1120.991366] megaraid abort:
109150:68[255:129], fw owner May 30 12:22:56 omc-2 [ 1120.991371]
megaraid: aborting-109151 cmd=28 <c=4 t=1 l=0> May 30 12:22:56 omc-2 [
1120.991374] megaraid abort: 109151:64[255:129], fw owner May 30
12:22:56 omc-2 [ 1120.991379] megaraid: 2 outstanding commands. Max wait
300 sec May 30 12:22:56 omc-2 [ 1120.991382] megaraid mbox: Wait for 2
commands to complete:300 May 30 12:23:01 omc-2 [ 1126.006002] megaraid
mbox: Wait for 2 commands to complete:295 May 30 12:23:06 omc-2 [
1131.020774] megaraid mbox: Wait for 2 commands to complete:290 May 30
12:23:11 omc-2 [ 1136.035548] megaraid mbox: Wait for 2 commands to
complete:285 May 30 12:23:16 omc-2 [ 1141.050325] megaraid mbox: Wait
for 2 commands to complete:280 May 30 12:23:21 omc-2 [ 1146.065098]
megaraid mbox: Wait for 2 commands to complete:275 May 30 12:23:26 omc-2
[ 1151.083870] megaraid mbox: Wait for 0 commands to complete:270 May 30
12:23:26 omc-2 [ 1151.083874] megaraid mbox: reset sequence completed
sucessfully May 30 12:23:26 omc-2 [ 1151.083979] sd 0:4:1:0: SCSI error:
return code = 0x00040001 May 30 12:23:26 omc-2 [ 1151.083983]
end_request: I/O error, dev sdb, sector 95601663 May 30 12:23:26 omc-2 [
1151.084124] sd 0:4:1:0: SCSI error: return code = 0x00040001 May 30
12:23:26 omc-2 [ 1151.084128] end_request: I/O error, dev sdb, sector
95601535 May 30 12:23:26 omc-2 [ 1151.084332] sd 0:4:1:0: SCSI error:
return code = 0x00040001 May 30 12:23:26 omc-2 [ 1151.084334]
end_request: I/O error, dev sdb, sector 95601535 May 30 12:23:27 omc-2 [
1152.725763] sd 0:4:1:0: SCSI error: return code = 0x00040001 May 30
12:23:27 omc-2 [ 1152.725768] end_request: I/O error, dev sdb, sector
71411967 May 30 12:23:27 omc-2 [ 1152.725816] sd 0:4:1:0: SCSI error:
return code = 0x00040001 May 30 12:23:27 omc-2 [ 1152.725818]
end_request: I/O error, dev sdb, sector 71411967 May 30 12:23:31 omc-2 [
1156.578149] sd 0:4:1:0: SCSI error: return code = 0x00040001 May 30
12:23:31 omc-2 [ 1156.578156] end_request: I/O error, dev sdb, sector
143351464
May 30 12:23:31 omc-2 [ 1156.578173] I/O error in filesystem ("sdb1")
meta-data dev sdb1 block 0x88b5e69       ("xlog_iodone") error 5 buf
count 10752
May 30 12:23:31 omc-2 [ 1156.578178] xfs_force_shutdown(sdb1,0x2) called
from line 960 of file fs/xfs/xfs_log.c.  Return address =
0xffffffff80398b56 May 30 12:23:31 omc-2 [ 1156.578204] Filesystem
"sdb1": Log I/O Error Detected.  Shutting down filesystem: sdb1 May 30
12:23:31 omc-2 [ 1156.578207] Please umount the filesystem, and rectify
the problem(s) May 30 12:23:31 omc-2 [ 1156.578251] sd 0:4:1:0: SCSI
error: return code = 0x00040001 May 30 12:23:31 omc-2 [ 1156.578253]
end_request: I/O error, dev sdb, sector 63 May 30 12:24:13 omc-2 [
1198.747915] xfs_force_shutdown(sdb1,0x1) called from line 424 of file
fs/xfs/xfs_rw.c.  Return address = 0xffffffff803afc2a


One of the drives in the array has been put offline after having seen
media errors. I'm waiting for a replacement but the recurring errors
worry me...

Any help/advises would be greatly appreciated.

Thanks a lot in advance,
  jules


PS: I'm running a distribution kernel, but having seen zero responses on
the gentoo list I dared to write here. The kernel is gentoo-sources
2.6.20-r8.
 

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in the body of a message to majordomo@vger.kernel.org More majordomo
info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
