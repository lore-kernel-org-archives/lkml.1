Return-Path: <linux-kernel-owner+w=401wt.eu-S933657AbZFQOW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbZFQOW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZFQOWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:22:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38226 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755548AbZFQOWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:22:16 -0400
Subject: [GIT PATCH] intermediate set of SCSI updates for the merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 10:22:13 -0400
Message-Id: <1245248533.8585.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These represent an initial update set (including a few bug fixes) that
have been incubating in linux-next.  Hopefully I'll be sending the last
set of updates next tuesday.

The update is available from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Alexey Zaytsev (1):
      compat: don't perform unneeded copy in sg_io code

Anirban Chakraborty (1):
      qla2xxx: Resolve a performance issue in interrupt

Christof Schmitt (1):
      zfcp: Update FC pass-through support

James Bottomley (2):
      aic79xx: make driver respect nvram for IU and QAS settings
      don't attach ULD to Dell Universal Xport

James Smart (6):
      lpfc 8.3.3 : Update driver version to 8.3.3
      lpfc 8.3.3 : Add support for Target Reset handler entrypoint
      lpfc 8.3.3 : Fix a couple of spin_lock and memory issues and a crash
      lpfc 8.3.3 : FC/FCOE discovery fixes
      lpfc 8.3.3 : Fix various SLI-3 vs SLI-4 differences
      FC Pass Thru support

Michael Chan (1):
      cnic, bnx2i: Fix build failure when CONFIG_PCI is not set.

Randy Dunlap (1):
      qla2xxx: fix printk format warnings

Roel Kluin (2):
      nsp_cs: time_out reaches -1
      ncr53c8xx: div reaches -1

Sven Schuetz (1):
      zfcp: Add FC pass-through support

and the diffstat:
 Documentation/scsi/scsi_fc_transport.txt |   14 
 Documentation/scsi/scsi_mid_low_api.txt  |    5 
 drivers/net/Kconfig                      |    5 
 drivers/s390/scsi/zfcp_aux.c             |   10 
 drivers/s390/scsi/zfcp_def.h             |   18 
 drivers/s390/scsi/zfcp_erp.c             |    2 
 drivers/s390/scsi/zfcp_ext.h             |    6 
 drivers/s390/scsi/zfcp_fc.c              |  185 ++++++++
 drivers/s390/scsi/zfcp_fsf.c             |    3 
 drivers/s390/scsi/zfcp_scsi.c            |   15 
 drivers/scsi/aic7xxx/aic79xx_osm.c       |   10 
 drivers/scsi/bnx2i/Kconfig               |    1 
 drivers/scsi/lpfc/lpfc.h                 |    4 
 drivers/scsi/lpfc/lpfc_attr.c            |    6 
 drivers/scsi/lpfc/lpfc_ct.c              |    4 
 drivers/scsi/lpfc/lpfc_els.c             |   27 +
 drivers/scsi/lpfc/lpfc_hbadisc.c         |   35 +
 drivers/scsi/lpfc/lpfc_hw.h              |    1 
 drivers/scsi/lpfc/lpfc_hw4.h             |    6 
 drivers/scsi/lpfc/lpfc_init.c            |   34 -
 drivers/scsi/lpfc/lpfc_mbox.c            |    7 
 drivers/scsi/lpfc/lpfc_nportdisc.c       |    2 
 drivers/scsi/lpfc/lpfc_scsi.c            |  661 +++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_sli.c             |  264 +++++++++---
 drivers/scsi/lpfc/lpfc_sli.h             |    1 
 drivers/scsi/lpfc/lpfc_sli4.h            |    2 
 drivers/scsi/lpfc/lpfc_version.h         |    2 
 drivers/scsi/lpfc/lpfc_vport.c           |    2 
 drivers/scsi/ncr53c8xx.c                 |    2 
 drivers/scsi/pcmcia/nsp_cs.c             |    6 
 drivers/scsi/qla2xxx/qla_isr.c           |   15 
 drivers/scsi/qla2xxx/qla_sup.c           |    7 
 drivers/scsi/scsi_devinfo.c              |    1 
 drivers/scsi/scsi_transport_fc.c         |  614 ++++++++++++++++++++++++++++
 drivers/scsi/scsi_transport_spi.c        |   18 
 fs/compat_ioctl.c                        |    6 
 include/Kbuild                           |    1 
 include/scsi/Kbuild                      |    4 
 include/scsi/scsi_bsg_fc.h               |  322 +++++++++++++++
 include/scsi/scsi_host.h                 |    9 
 include/scsi/scsi_transport_fc.h         |   52 ++
 include/scsi/scsi_transport_spi.h        |    4 
 42 files changed, 1888 insertions(+), 505 deletions(-)

James



