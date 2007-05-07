Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXEGETV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXEGETV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 00:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXEGETV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 00:19:21 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:16447 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbXEGETU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 00:19:20 -0400
X-IronPort-AV: i="4.14,500,1170662400"; 
   d="scan'208"; a="145263769:sNHT48829221"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 06 May 2007 21:19:18 -0700
Message-ID: <adaps5d6zax.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2007 04:19:18.0932 (UTC) FILETIME=[E1951D40:01C7905E]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This is the second batch of merges for 2.6.22 -- mostly fixes, but
also the conversion of IPoIB to use NAPI:

Ishai Rabinovitz (1):
      IB/srp: Add orig_dgid sysfs attribute to scsi_host

Michael S. Tsirkin (4):
      IB/mthca: Work around kernel QP starvation
      IPoIB/cm: Fix error handling in ipoib_cm_dev_open()
      IPoIB/cm: Don't crash if remote side uses one QP for both directions
      IB: Add CQ comp_vector support

Ralph Campbell (4):
      IB/ipath: Don't call spin_lock_irq() from interrupt context
      IB/ipath: Don't put QP in timeout queue if waiting to send
      IB/ipath: Fix two more spin lock problems
      IB/ipath: Fix a race condition when generating ACKs

Robert Walsh (1):
      IB/ipath: Don't corrupt pending mmap list when unmapped objects are freed

Roland Dreier (4):
      IB/srp: Set proc_name
      IB/fmr_pool: Add prefix to all printks
      IB: Return "maybe missed event" hint from ib_req_notify_cq()
      IPoIB: Convert to NAPI

Steve Wise (4):
      RDMA/cxgb3: Fix TERM codes
      RDMA/cxgb3: Fail qp creation if the requested max_inline is too large
      RDMA/cxgb3: Initialize cpu_idx field in cpl_close_listserv_req message
      RDMA/cxgb3: Support for new abort logic

 drivers/infiniband/core/fmr_pool.c           |   32 +++++----
 drivers/infiniband/core/mad.c                |    2 +-
 drivers/infiniband/core/uverbs_cmd.c         |    1 +
 drivers/infiniband/core/uverbs_main.c        |    2 +-
 drivers/infiniband/core/verbs.c              |    4 +-
 drivers/infiniband/hw/amso1100/c2.h          |    2 +-
 drivers/infiniband/hw/amso1100/c2_cq.c       |   16 ++++-
 drivers/infiniband/hw/amso1100/c2_provider.c |    3 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c       |    3 +
 drivers/infiniband/hw/cxgb3/cxio_wr.h        |    1 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |   19 ++++++
 drivers/infiniband/hw/cxgb3/iwch_cm.h        |    6 ++
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |   14 +++-
 drivers/infiniband/hw/cxgb3/iwch_qp.c        |   69 +++++++++++---------
 drivers/infiniband/hw/ehca/ehca_cq.c         |    2 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |    4 +-
 drivers/infiniband/hw/ehca/ehca_main.c       |    3 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c       |   14 +++-
 drivers/infiniband/hw/ehca/ipz_pt_fn.h       |    8 ++
 drivers/infiniband/hw/ipath/ipath_cq.c       |   68 ++++++++++----------
 drivers/infiniband/hw/ipath/ipath_mmap.c     |   64 +++++++++++++++++--
 drivers/infiniband/hw/ipath/ipath_qp.c       |   52 +++++++++------
 drivers/infiniband/hw/ipath/ipath_rc.c       |   55 ++++++++--------
 drivers/infiniband/hw/ipath/ipath_srq.c      |   55 ++++++++--------
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    4 +
 drivers/infiniband/hw/ipath/ipath_verbs.h    |   24 +++++--
 drivers/infiniband/hw/mthca/mthca_cq.c       |   12 ++--
 drivers/infiniband/hw/mthca/mthca_dev.h      |    4 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 +
 drivers/infiniband/hw/mthca/mthca_qp.c       |   13 ++++
 drivers/infiniband/ulp/ipoib/ipoib.h         |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |   14 +++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |   89 ++++++++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    2 +
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c   |    2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |   27 +++++++-
 drivers/infiniband/ulp/srp/ib_srp.h          |    1 +
 drivers/net/cxgb3/version.h                  |    4 +-
 include/rdma/ib_verbs.h                      |   47 +++++++++++---
 40 files changed, 508 insertions(+), 239 deletions(-)
