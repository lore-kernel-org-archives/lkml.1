Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbZFWQw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbZFWQw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbZFWQwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:52:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33292 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760015AbZFWQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:52:42 -0400
Subject: [GIT PATCH] final (hopefully) SCSI updates for the merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Jun 2009 11:52:41 -0500
Message-Id: <1245775961.4149.131.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically a small set of driver updates and fixes which has
remained from the rest of the merges.  Hopefully all the cnic config
problems are now fixed and we should now have VPD based limits exposed
to the block device and SSD nonrotational flag detection in sd.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Andrew Vasquez (3):
      qla2xxx: Update version number to 8.03.01-k4.
      qla2xxx: Correct (again) overflow during dump-processing on large-memory ISP23xx parts.
      qla2xxx: Limit querying to supported mailbox-registers while reading FW state.

Anirban Chakraborty (1):
      qla2xxx: Fixed a bug in number of response queue creation logic.

Brian King (2):
      ibmvfc: Fix endless PRLI loop in discovery
      ibmvfc: Process async events before command responses

Erez Zilber (1):
      libiscsi: add conn and scsi eh log debug flags

FUJITA Tomonori (2):
      block: revert "bsg: setting rq->bio to NULL"
      scsi_transport_sas: needs to call blk_end_request_all for SMP requests

Giridhar Malavali (2):
      fc_transport: Selective return value from BSG timeout function
      fc_transport: The softirq_done function registration for BSG request

Hannes Reinecke (1):
      sd, sr: fix Driver 'sd' needs updating message

Harish Zunjarrao (1):
      qla2xxx: Correct iiDMA-update calling conventions.

James Bottomley (5):
      scsi_transport_fc: replace BUS_ID_SIZE by fixed count
      Revert " cnic: fix error: implicit declaration of function ‘__symbol_get’"
      scsi_transport_spi: Blacklist Ultrium-3 tape for IU transfers
      scsi_transport_spi: use spi target settings instead of inquiry data for DV
      enhance device info matching for multiple tables

Jaswinder Singh Rajput (1):
      scsi_transport_iscsi: return -EOVERFLOW for Too many iscsi targets

Jiri Slaby (1):
      fusion: mptsas, fix lock imbalance

Joe Eykholt (1):
      fix race that can give duplicate host number

John Stoffel (1):
      sym53c8xx: ratelimit parity errors

Karen Xie (2):
      cxgb3i: suppot of different kernel page sizes
      cxgb3i: use kref to track ddp usage

Martin K. Petersen (4):
      scsi_debug: Add support for physical block exponent and alignment
      sd: Block limits VPD support
      sd: Detect non-rotational devices
      sd: Physical block size and alignment support

Michael Chan (1):
      cnic: Fix __symbol_get() build error.

Mike Christie (2):
      iscsi_tcp: propogate EAGAIN from sendpage to libiscsi
      libiscsi: don't run scsi eh if iscsi task is making progress

Randy Dunlap (1):
      cnic: add NETDEV_1000 and NETDEVICES to Kconfig select

Robert Love (3):
      libfc: Add runtime debugging with debug_logging module parameter
      libfcoe: Add runtime debugging with module param debug_logging
      fcoe: Add runtime debug logging with module parameter debug_logging

Stefan Richter (1):
      explain the hidden scsi_wait_scan Kconfig variable

Wayne Boyer (2):
      ipr: differentiate pci-x and pci-e based adapters
      ipr: add test for MSI interrupt support

And the diffstat:

 block/bsg.c                         |    3 
 drivers/message/fusion/mptsas.c     |    4 
 drivers/net/cnic.c                  |    6 
 drivers/net/cnic_if.h               |    2 
 drivers/scsi/Kconfig                |   13 +
 drivers/scsi/bnx2i/Kconfig          |    2 
 drivers/scsi/cxgb3i/cxgb3i_ddp.c    |   90 ++++++++++---
 drivers/scsi/cxgb3i/cxgb3i_ddp.h    |    2 
 drivers/scsi/fcoe/fcoe.c            |  108 +++++++--------
 drivers/scsi/fcoe/fcoe.h            |   24 +++
 drivers/scsi/fcoe/libfcoe.c         |   94 +++++++------
 drivers/scsi/hosts.c                |    8 -
 drivers/scsi/ibmvscsi/ibmvfc.c      |   36 +++--
 drivers/scsi/ibmvscsi/ibmvfc.h      |    1 
 drivers/scsi/ipr.c                  |  138 +++++++++++++++++---
 drivers/scsi/ipr.h                  |   10 +
 drivers/scsi/iscsi_tcp.c            |   14 +-
 drivers/scsi/libfc/fc_disc.c        |   83 +++++-------
 drivers/scsi/libfc/fc_exch.c        |   58 +++-----
 drivers/scsi/libfc/fc_fcp.c         |   97 +++++++-------
 drivers/scsi/libfc/fc_lport.c       |  156 ++++++++++------------
 drivers/scsi/libfc/fc_rport.c       |  120 +++++++----------
 drivers/scsi/libiscsi.c             |  161 +++++++++++++++--------
 drivers/scsi/libiscsi_tcp.c         |    6 
 drivers/scsi/qla2xxx/qla_dbg.c      |    2 
 drivers/scsi/qla2xxx/qla_init.c     |    2 
 drivers/scsi/qla2xxx/qla_mbx.c      |   28 ++--
 drivers/scsi/qla2xxx/qla_os.c       |    2 
 drivers/scsi/qla2xxx/qla_version.h  |    2 
 drivers/scsi/scsi_debug.c           |   30 ++++
 drivers/scsi/scsi_devinfo.c         |  247 ++++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_lib.c             |    1 
 drivers/scsi/scsi_priv.h            |   17 ++
 drivers/scsi/scsi_sysfs.c           |   17 --
 drivers/scsi/scsi_transport_fc.c    |   44 +++---
 drivers/scsi/scsi_transport_iscsi.c |    1 
 drivers/scsi/scsi_transport_sas.c   |    4 
 drivers/scsi/scsi_transport_spi.c   |   51 ++++++-
 drivers/scsi/sd.c                   |   74 ++++++++++
 drivers/scsi/sd.h                   |    1 
 drivers/scsi/sr.c                   |    1 
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    5 
 include/scsi/fc_encode.h            |    2 
 include/scsi/libfc.h                |   77 +++++++++--
 include/scsi/libiscsi.h             |    4 
 include/scsi/scsi_driver.h          |    1 
 46 files changed, 1245 insertions(+), 604 deletions(-)

James


