Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbZDEEDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbZDEEDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 00:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZDEECt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 00:02:49 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:25218 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750823AbZDEECr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 00:02:47 -0400
X-YMail-OSG: oWVVhRcVM1kojiPsq_MLkbGXNT8ezojpiZP_m6yoWNBtvsSAx_PzVqbsnNakpo1lpDA6Ax6h9deJctgi4u6qbgsTXHHDNZdPCXmyh7pYHpDMyY_WddvOjL5asVzyS1s3zyM7Hh7QCfNbz8jIb11HNOkqU7NbIxHl7QiZu2dh8_K0NXIK85qhUffXlgtVDz4OhEEpPAny0oMHaJQw4ZDRCoy1Ra8qF.wky4R2nVMaVSp3DQYVuSlI2NCCC7snk7.3hgpvhRmKB4moCqq77PgmH38kiYMtM2i6V.gwCf0iTbx_fxFCPPt53AN3D_OxtPTrX.EdQWzRaT7pxOiAviM.LZHWt7u3WKs-
X-Yahoo-Newman-Property: ymail-3
Subject: [RFC PATCH 0/19] Target_Core_Mod/ConfigFS v3.0 for v2.6.30
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Joel Becker <joel.becker@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Ming Zhang <blackmagic02881@gmail.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>,
       Douglas Gilbert <dgilbert@interlog.com>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 21:01:31 -0700
Message-Id: <1238904091.4250.741.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

I am very proud to announce the first RFC and submission for review of
Target_Core_Mod/ConfigFS v3.0 for v2.6.30.

Target_Core_Mod is a generic target engine and ConfigFS enabled
infrastructure that provides access to the export server side resources
from Linux/SCSI, Linux/BLOCK and Linux/FILEIO (using buffered I/O)
subsytems to target mode storage fabric modules (like the LIO-Target
v3.0 fabric module).  It does complete SPC-3 control emulation on top of
Linux/BLOCK and Linux/FILEIO objects, and does a SCSI passthrough (with
intelligent max_sectors handling) for Linux/SCSI objects.

Target_Core_Mod/ConfigFS is the next generation version of the
LIO-Target v2.9 codebase that is completely SCSI fabric module
independent.  The configuration plane has been ported from our legacy
LIO IOCTl control path in v2.9, and is now 100% upstream ConfigFS
infrastructure clean for v3.0.

Target_Core_Mod/ConfigFS also contains a number of SCSI fabric features
that you will not find in any other open source Linux-SCSI or
Linux-iSCSI target implementation.  These now include SPC-3 compliant
persistent reservation support that is passing complete domain
validation from multiple client environments (RHEL SCSI fencing and MSFT
Cluster 2008), Asymmetric Logical Unit Assignment (Linux scsi_dh_alua
and MPxIO on OpenSolaris clients), VPD/WWN information emulation and
SCSI MIBs to name the most interesting ones.

Primary development is with the LIO-Target/ConfigFS v3.0 fabric module,
this module will be submitted for review seperately in order to focus on
the kernel-level target engine pieces for this submission.

These patches are made against lio-core-2.6.git/master that tracks
linux-2.6.git, and has been tested on v2.6.29 x86 32-bit HVM, x86_64 and
ppc64.  The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

While the user docs for the v3.0 code are still a bit lacking (this is
being worked on), you can look at the following locations for more
information:

http://linux-iscsi.org/index.php/LIO-Target/ConfigFS
http://linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
http://linux-iscsi.org/index.php/LIO-Target

also, the best place to look and ask questions is on the LIO-devel
mailing list at:

http://groups.google.com/group/linux-iscsi-target-dev

and finally, a huge thanks to the people who have made this possible:

Douglas Gilbert (SPC-3 PR support, and many other features would not have been possible w/o sg3_utils)
Joel Becker (For creating ConfigFS and answering many questions early on)
Ming Zhang (For recommending ConfigFS in the first place!)
Mike Christie (For making quick Open-iSCSI patches when we found bugs, and creating STGT)
Fujita Tomonori (For creating STGT and his IOMMU work)
Dr. Hannes Reinecke (For creating scsi_dh_alua and all his Linux/SCSI work)
James Bottomley (For maintaing Linux/SCSI, and answering obsecure SCSI spec questions)
Al Tobey (For endless OpenSolaris MPxIO ALUA testing)
Brad Fennel and Jason Hodges (For endless MSFT Cluster 2008 PR testing)

There are many more people to thank than these very talented folks, you know who you are.

Thank you!!

--nab

[RFC PATCH 1/19] Target_Core_Mod Asymmetric Logical Unit Assignment (ALUA) support
[RFC PATCH 2/19] Target_Core_Mod ConfigFS infrastructure
[RFC PATCH 3/19] Target_Core_Mod device core infrastructure
[RFC PATCH 4/19] Target_Core_Mod FILEIO <-> Linux/VFS subsystem 
[RFC PATCH 5/19] Target_Core_Mod HBA core infrastructure
[RFC PATCH 6/19] Target_Core_Mod IBLOCK <-> Linux/Block subsystem plugin
[RFC PATCH 7/19] Target_Core_Mod base and fabric_module includes
[RFC PATCH 8/19] Target_Core_Mod Makefile and Kconfig
[RFC PATCH 9/19] Target_Core_Mod SPC-3 Persistent Reservations
[RFC PATCH 10/19] Target_Core_Mod Subsystem and SE Object plugin infrastructure
[RFC PATCH 11/19] Target_Core_Mod PSCSI <-> Linux/SCSI subsystem plugin
[RFC PATCH 12/19] Target_Core_Mod RAMDISK_DR and RAMDISK_MCP subsystem plugin
[RFC PATCH 13/19] Target_Core_Mod READ/WRITE command descriptor block generation code
[RFC PATCH 14/19] Target_Core_Mod SCSI MIBs 
[RFC PATCH 15/19] Target_Core_Mod Storage Engine Object infrastructure
[RFC PATCH 16/19] Target_Core_Mod Task Management infrastructure
[RFC PATCH 17/19] Target_Core_Mod portal group endpoint infrastructure
[RFC PATCH 18/19] Target_Core_Mod Generic Transport Core
[RFC PATCH 19/19] Target_Core_Mod Unit Attention emulation support

 drivers/Makefile                              |    7 +-
 drivers/target/Kconfig                        |    6 +
 drivers/target/MCONFIG_ALL                    |   20 +
 drivers/target/MCONFIG_TARGET                 |   23 +
 drivers/target/Makefile                       |  101 +
 drivers/target/div64.c                        |   16 +
 drivers/target/target_core_alua.c             |  718 +++
 drivers/target/target_core_configfs.c         | 2366 ++++++++
 drivers/target/target_core_device.c           | 1384 +++++
 drivers/target/target_core_file.c             | 1213 ++++
 drivers/target/target_core_hba.c              |  260 +
 drivers/target/target_core_iblock.c           | 1033 ++++
 drivers/target/target_core_mib.c              | 1188 ++++
 drivers/target/target_core_plugin.c           |  310 +
 drivers/target/target_core_pr.c               | 2207 ++++++++
 drivers/target/target_core_pscsi.c            | 1657 ++++++
 drivers/target/target_core_rd.c               | 1422 +++++
 drivers/target/target_core_scdb.c             |  154 +
 drivers/target/target_core_seobj.c            |  679 +++
 drivers/target/target_core_tmr.c              |  395 ++
 drivers/target/target_core_tpg.c              |  867 +++
 drivers/target/target_core_transport.c        | 7537 +++++++++++++++++++++++++
 drivers/target/target_core_ua.c               |  334 ++
 include/target/configfs_macros.h              |  147 +
 include/target/target_core_alua.h             |   71 +
 include/target/target_core_base.h             |  860 +++
 include/target/target_core_configfs.h         |   62 +
 include/target/target_core_device.h           |   82 +
 include/target/target_core_fabric_ops.h       |   45 +
 include/target/target_core_file.h             |  220 +
 include/target/target_core_hba.h              |   44 +
 include/target/target_core_iblock.h           |  174 +
 include/target/target_core_mib.h              |   57 +
 include/target/target_core_plugin.h           |   71 +
 include/target/target_core_pr.h               |   54 +
 include/target/target_core_pscsi.h            |  189 +
 include/target/target_core_rd.h               |  257 +
 include/target/target_core_scdb.h             |   42 +
 include/target/target_core_seobj.h            |  114 +
 include/target/target_core_tmr.h              |   43 +
 include/target/target_core_tpg.h              |   59 +
 include/target/target_core_transport.h        |  519 ++
 include/target/target_core_transport_plugin.h |   60 +
 include/target/target_core_ua.h               |   36 +
 44 files changed, 27100 insertions(+), 3 deletions(-)


