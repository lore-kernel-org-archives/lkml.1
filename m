Return-Path: <linux-kernel-owner+w=401wt.eu-S1762987AbXEZRQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987AbXEZRQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 13:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXEZRQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 13:16:31 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:43813 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751434AbXEZRQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 13:16:30 -0400
Subject: [GIT PATCH] SCSI bug fixes for 2.6.22-rc3
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 26 May 2007 12:16:27 -0500
Message-Id: <1180199788.3712.61.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This represents the accumulated SCSI bug fixes so far.  There's one
driver update: stex, but that's also mainly a bug fix.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Alan Stern (1):
      sd: fix refcounting regression in suspend/resume routines

Brian King (1):
      ipr: Proper return codes for eh_dev_reset for SATA devices

Christoph Hellwig (1):
      NCR53C9x: correct spelling mistake in deprecation notice

Darrick J. Wong (1):
      aic94xx: asd_clear_nexus should fail if the cleared task does not complete

Dave Jones (1):
      fusion: Fix |/|| confusion

Ed Lin (4):
      stex: minor cleanup and version update
      stex: fix reset recovery for console device
      stex: extend hard reset wait time
      stex: fix id mapping issue

FUJITA Tomonori (1):
      tgt: fix a rdma indirect transfer error bug

James Bottomley (2):
      aic7xxx: fix aicasm build failure with gcc-3.4.6
      aacraid: fix panic on short Inquiry

Martin Peschke (1):
      zfcp: avoid clutter in erp_dbf

Michael Loehr (1):
      zfcp: IO stall after deleting and path checker changes after reenabling zf

Salyzyn, Mark (2):
      aacraid: apply commit config for reset_devices flag
      aacraid: Correct sa platform support. (Was: [Bug 8469] Bad EIP value on pe

Sumant Patro (2):
      megaraid_sas: intercept cmd timeout and throttle io
      MegaRAID: Update MAINTAINERS email-id


and the diffstat:

 Documentation/feature-removal-schedule.txt      |    2 
 MAINTAINERS                                     |    2 
 drivers/message/fusion/mptbase.h                |    2 
 drivers/message/fusion/mptscsih.c               |    8 +-
 drivers/s390/scsi/zfcp_aux.c                    |    1 
 drivers/s390/scsi/zfcp_ccw.c                    |    5 -
 drivers/s390/scsi/zfcp_fsf.c                    |   40 +++-------
 drivers/s390/scsi/zfcp_scsi.c                   |    3 
 drivers/scsi/aacraid/aachba.c                   |   15 ++--
 drivers/scsi/aacraid/aacraid.h                  |    3 
 drivers/scsi/aacraid/rx.c                       |    8 +-
 drivers/scsi/aacraid/sa.c                       |    9 ++
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y       |    1 
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y |    1 
 drivers/scsi/aic94xx/aic94xx_tmf.c              |   14 ++-
 drivers/scsi/ipr.c                              |    7 +
 drivers/scsi/libsrp.c                           |    1 
 drivers/scsi/megaraid/megaraid_sas.c            |   67 ++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h            |   14 ++-
 drivers/scsi/scsi_devinfo.c                     |    1 
 drivers/scsi/sd.c                               |   18 ++--
 drivers/scsi/stex.c                             |   90 ++++++++++++++----------
 22 files changed, 206 insertions(+), 106 deletions(-)

James


