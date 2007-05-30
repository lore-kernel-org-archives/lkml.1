Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbXE3LHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbXE3LHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXE3LHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:07:44 -0400
Received: from mail-smtp3.ode.cdnet.dk ([85.218.129.6]:53800 "EHLO
	mail-smtp3.ode.cdnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXE3LHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:07:44 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 07:07:43 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.998
Subject: LSI MegaRAID problems
From: Jules Colding <colding@omesc.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 May 2007 12:59:37 +0200
Message-Id: <1180522777.6308.14.camel@omc-2.omesc.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a "LSI Logic MegaRAID SCSI 320-4x" adapter with an external raid5
array of 5 Seagate ST336754LW and XFS as fs on it. The device in
question is /dev/sdb and the box is a dual Opteron 252.

I've recently started to see this in the log almost whenever I touch the
filesystem:

May 30 12:22:56 omc-2 [ 1120.991356] megaraid: aborting-109150 cmd=28 <c=4 t=1 l=0>
May 30 12:22:56 omc-2 [ 1120.991366] megaraid abort: 109150:68[255:129], fw owner
May 30 12:22:56 omc-2 [ 1120.991371] megaraid: aborting-109151 cmd=28 <c=4 t=1 l=0>
May 30 12:22:56 omc-2 [ 1120.991374] megaraid abort: 109151:64[255:129], fw owner
May 30 12:22:56 omc-2 [ 1120.991379] megaraid: 2 outstanding commands. Max wait 300 sec
May 30 12:22:56 omc-2 [ 1120.991382] megaraid mbox: Wait for 2 commands to complete:300
May 30 12:23:01 omc-2 [ 1126.006002] megaraid mbox: Wait for 2 commands to complete:295
May 30 12:23:06 omc-2 [ 1131.020774] megaraid mbox: Wait for 2 commands to complete:290
May 30 12:23:11 omc-2 [ 1136.035548] megaraid mbox: Wait for 2 commands to complete:285
May 30 12:23:16 omc-2 [ 1141.050325] megaraid mbox: Wait for 2 commands to complete:280
May 30 12:23:21 omc-2 [ 1146.065098] megaraid mbox: Wait for 2 commands to complete:275
May 30 12:23:26 omc-2 [ 1151.083870] megaraid mbox: Wait for 0 commands to complete:270
May 30 12:23:26 omc-2 [ 1151.083874] megaraid mbox: reset sequence completed sucessfully
May 30 12:23:26 omc-2 [ 1151.083979] sd 0:4:1:0: SCSI error: return code = 0x00040001
May 30 12:23:26 omc-2 [ 1151.083983] end_request: I/O error, dev sdb, sector 95601663
May 30 12:23:26 omc-2 [ 1151.084124] sd 0:4:1:0: SCSI error: return code = 0x00040001
May 30 12:23:26 omc-2 [ 1151.084128] end_request: I/O error, dev sdb, sector 95601535
May 30 12:23:26 omc-2 [ 1151.084332] sd 0:4:1:0: SCSI error: return code = 0x00040001
May 30 12:23:26 omc-2 [ 1151.084334] end_request: I/O error, dev sdb, sector 95601535
May 30 12:23:27 omc-2 [ 1152.725763] sd 0:4:1:0: SCSI error: return code = 0x00040001
May 30 12:23:27 omc-2 [ 1152.725768] end_request: I/O error, dev sdb, sector 71411967
May 30 12:23:27 omc-2 [ 1152.725816] sd 0:4:1:0: SCSI error: return code = 0x00040001
May 30 12:23:27 omc-2 [ 1152.725818] end_request: I/O error, dev sdb, sector 71411967
May 30 12:23:31 omc-2 [ 1156.578149] sd 0:4:1:0: SCSI error: return code = 0x00040001
May 30 12:23:31 omc-2 [ 1156.578156] end_request: I/O error, dev sdb, sector 143351464
May 30 12:23:31 omc-2 [ 1156.578173] I/O error in filesystem ("sdb1") meta-data dev sdb1 block 0x88b5e69       ("xlog_iodone") error 5 buf count 10752
May 30 12:23:31 omc-2 [ 1156.578178] xfs_force_shutdown(sdb1,0x2) called from line 960 of file fs/xfs/xfs_log.c.  Return address = 0xffffffff80398b56
May 30 12:23:31 omc-2 [ 1156.578204] Filesystem "sdb1": Log I/O Error Detected.  Shutting down filesystem: sdb1
May 30 12:23:31 omc-2 [ 1156.578207] Please umount the filesystem, and rectify the problem(s)
May 30 12:23:31 omc-2 [ 1156.578251] sd 0:4:1:0: SCSI error: return code = 0x00040001
May 30 12:23:31 omc-2 [ 1156.578253] end_request: I/O error, dev sdb, sector 63
May 30 12:24:13 omc-2 [ 1198.747915] xfs_force_shutdown(sdb1,0x1) called from line 424 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803afc2a


One of the drives in the array has been put offline after having seen
media errors. I'm waiting for a replacement but the recurring errors
worry me...

Any help/advises would be greatly appreciated.

Thanks a lot in advance,
  jules


PS: I'm running a distribution kernel, but having seen zero responses on
the gentoo list I dared to write here. The kernel is gentoo-sources
2.6.20-r8.
 

