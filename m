Return-Path: <linux-kernel-owner+w=401wt.eu-S1946311AbXBPXs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946311AbXBPXs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946100AbXBPXs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:48:29 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:2858 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946311AbXBPXs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:48:28 -0500
X-IronPort-AV: i="4.14,182,1170662400"; 
   d="scan'208"; a="389985926:sNHT50154676"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, openib-general@openib.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 16 Feb 2007 15:48:19 -0800
Message-ID: <adahctlacl8.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Feb 2007 23:48:20.0296 (UTC) FILETIME=[F00BE480:01C75224]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This adds IB multicast tracking, to allow userspace to use multicast
groups in a sane way, an ehca interrupt handling fixup, and a few
other minor things.  I don't think there is anything major left, so we
should be good for 2.6.21-rc1 after this pull.

Dotan Barak (1):
      IB/mthca: Allow the QP state transition RESET->RESET

Hoang-Nam Nguyen (4):
      IB/ehca: Rework irq handler
      IB/ehca: Fix race condition/locking issues in scaling code
      IB/ehca: Allow en/disabling scaling code via module parameter
      IB/ehca: Change query_port() to return LINK_UP instead UNKNOWN

Michael S. Tsirkin (1):
      IPoIB: CM error handling thinko fix

Roland Dreier (5):
      IB/mthca: Fix allocation of ICM chunks in coherent memory
      IPoIB: Only allow root to change between datagram and connected mode
      IB/core: Fix sparse warnings about shadowed declarations
      IB/ipath: Make ipath_map_sg() static
      IB/core: Set static rate in ib_init_ah_from_path()

Sean Hefty (2):
      IB/sa: Track multicast join/leave requests
      RDMA/cma: Add multicast communication support

Steve Wise (3):
      RDMA/iwcm: iw_cm_id destruction race fixes
      RDMA/cxgb3: Fail posts synchronously when in TERMINATE state
      RDMA/cxgb3: Remove Open Grid Computing copyrights in iw_cxgb3 driver

 drivers/infiniband/core/Makefile               |    2 +-
 drivers/infiniband/core/cma.c                  |  359 +++++++++--
 drivers/infiniband/core/fmr_pool.c             |    4 +-
 drivers/infiniband/core/iwcm.c                 |   47 +-
 drivers/infiniband/core/multicast.c            |  837 ++++++++++++++++++++++++
 drivers/infiniband/core/sa.h                   |   66 ++
 drivers/infiniband/core/sa_query.c             |   30 +-
 drivers/infiniband/core/sysfs.c                |    2 -
 drivers/infiniband/core/ucma.c                 |  204 ++++++-
 drivers/infiniband/hw/cxgb3/cxio_dbg.c         |    1 -
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |    1 -
 drivers/infiniband/hw/cxgb3/cxio_hal.h         |    1 -
 drivers/infiniband/hw/cxgb3/cxio_resource.c    |    1 -
 drivers/infiniband/hw/cxgb3/cxio_resource.h    |    1 -
 drivers/infiniband/hw/cxgb3/cxio_wr.h          |    1 -
 drivers/infiniband/hw/cxgb3/iwch.c             |    1 -
 drivers/infiniband/hw/cxgb3/iwch.h             |    1 -
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    1 -
 drivers/infiniband/hw/cxgb3/iwch_cm.h          |    1 -
 drivers/infiniband/hw/cxgb3/iwch_cq.c          |    1 -
 drivers/infiniband/hw/cxgb3/iwch_ev.c          |    1 -
 drivers/infiniband/hw/cxgb3/iwch_mem.c         |    1 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    1 -
 drivers/infiniband/hw/cxgb3/iwch_provider.h    |    1 -
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |    3 +-
 drivers/infiniband/hw/cxgb3/iwch_user.h        |    1 -
 drivers/infiniband/hw/ehca/Kconfig             |    8 -
 drivers/infiniband/hw/ehca/ehca_classes.h      |   19 +-
 drivers/infiniband/hw/ehca/ehca_eq.c           |    1 +
 drivers/infiniband/hw/ehca/ehca_hca.c          |    3 +
 drivers/infiniband/hw/ehca/ehca_irq.c          |  307 +++++----
 drivers/infiniband/hw/ehca/ehca_irq.h          |    1 +
 drivers/infiniband/hw/ehca/ehca_main.c         |   32 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.h         |   11 +-
 drivers/infiniband/hw/ipath/ipath_dma.c        |    4 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c    |    4 +-
 drivers/infiniband/hw/mthca/mthca_qp.c         |    5 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  195 ++----
 include/rdma/ib_addr.h                         |    6 +
 include/rdma/ib_sa.h                           |  159 ++---
 include/rdma/rdma_cm.h                         |   21 +-
 include/rdma/rdma_cm_ib.h                      |    4 +-
 include/rdma/rdma_user_cm.h                    |   13 +-
 44 files changed, 1889 insertions(+), 478 deletions(-)
 create mode 100644 drivers/infiniband/core/multicast.c
 create mode 100644 drivers/infiniband/core/sa.h
