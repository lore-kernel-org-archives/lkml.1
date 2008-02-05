Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYBEEtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYBEEtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbYBEEtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:49:31 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:33137 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbYBEEt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:49:29 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       gstreiff@neteffect.com
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 04 Feb 2008 20:49:20 -0800
Message-ID: <adamyqgf1nz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Feb 2008 04:49:21.0436 (UTC) FILETIME=[7924E5C0:01C867B2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a second batch of InfiniBand/RDMA batches.  In addition
to the usual motley crew of changes, this pull includes a new driver
for NetEffect RNICs in drivers/infiniband/hw/nes.  The code could use
some further cleaning, but I don't think it's worth holding off on the
merge.

David Dillow (1):
      IB/srp: Retry stale connections

Eli Cohen (2):
      IB/mthca: Remove checks for srq->first_free < 0
      IB/ib_mthca: Pre-link receive WQEs in Tavor mode

Glenn Streiff (1):
      RDMA/nes: Add a driver for NetEffect RNICs

Hoang-Nam Nguyen (1):
      IB/ehca: Add PMA support

Jack Morgenstein (2):
      IB/mthca: Don't read reserved fields in mthca_QUERY_ADAPTER()
      mlx4_core: Don't read reserved fields in mlx4_QUERY_ADAPTER()

Joachim Fenkes (2):
      IB/ehca: Prevent sending UD packets to QP0
      IB/ehca: Update sma_attr also in case of disruptive config change

Olaf Kirch (1):
      IB/mthca: Return proper error codes from mthca_fmr_alloc()

Or Gerlitz (3):
      IPoIB: Handle bonding failover race for connected neighbours too
      IPoIB: Remove a misleading debug print
      IB/fmr_pool: Allocate page list for pool FMRs only when caching enabled

Roland Dreier (4):
      mlx4_core: Fix more section mismatches
      IB/mthca: Fix and simplify page size calculation in mthca_reg_phys_mr()
      IB/mlx4: Actually print out the driver version
      IB: Avoid marking __devinitdata as const

Sean Hefty (1):
      IB/cm: Add interim support for routed paths

 MAINTAINERS                                  |   10 +
 drivers/infiniband/Kconfig                   |    2 +-
 drivers/infiniband/Makefile                  |    1 +
 drivers/infiniband/core/cm.c                 |   89 +-
 drivers/infiniband/core/fmr_pool.c           |    7 +-
 drivers/infiniband/hw/ehca/ehca_classes.h    |    1 +
 drivers/infiniband/hw/ehca/ehca_irq.c        |    2 +
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |    5 +
 drivers/infiniband/hw/ehca/ehca_main.c       |    2 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c       |    4 +
 drivers/infiniband/hw/ehca/ehca_sqp.c        |   91 +
 drivers/infiniband/hw/mlx4/main.c            |   10 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c      |   11 +-
 drivers/infiniband/hw/mthca/mthca_main.c     |    5 +-
 drivers/infiniband/hw/mthca/mthca_mr.c       |    8 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |   22 +-
 drivers/infiniband/hw/mthca/mthca_qp.c       |   13 +-
 drivers/infiniband/hw/mthca/mthca_srq.c      |   47 +-
 drivers/infiniband/hw/nes/Kconfig            |   16 +
 drivers/infiniband/hw/nes/Makefile           |    3 +
 drivers/infiniband/hw/nes/nes.c              | 1152 ++++++++
 drivers/infiniband/hw/nes/nes.h              |  560 ++++
 drivers/infiniband/hw/nes/nes_cm.c           | 3088 ++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_cm.h           |  433 +++
 drivers/infiniband/hw/nes/nes_context.h      |  193 ++
 drivers/infiniband/hw/nes/nes_hw.c           | 3080 ++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_hw.h           | 1206 ++++++++
 drivers/infiniband/hw/nes/nes_nic.c          | 1703 +++++++++++
 drivers/infiniband/hw/nes/nes_user.h         |  112 +
 drivers/infiniband/hw/nes/nes_utils.c        |  917 ++++++
 drivers/infiniband/hw/nes/nes_verbs.c        | 3917 ++++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_verbs.h        |  169 ++
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   19 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |   53 +-
 drivers/infiniband/ulp/srp/ib_srp.h          |    1 +
 drivers/net/mlx4/fw.c                        |    6 -
 drivers/net/mlx4/fw.h                        |    3 -
 drivers/net/mlx4/main.c                      |   11 +-
 drivers/net/mlx4/mr.c                        |    2 +-
 39 files changed, 16848 insertions(+), 126 deletions(-)
 create mode 100644 drivers/infiniband/hw/nes/Kconfig
 create mode 100644 drivers/infiniband/hw/nes/Makefile
 create mode 100644 drivers/infiniband/hw/nes/nes.c
 create mode 100644 drivers/infiniband/hw/nes/nes.h
 create mode 100644 drivers/infiniband/hw/nes/nes_cm.c
 create mode 100644 drivers/infiniband/hw/nes/nes_cm.h
 create mode 100644 drivers/infiniband/hw/nes/nes_context.h
 create mode 100644 drivers/infiniband/hw/nes/nes_hw.c
 create mode 100644 drivers/infiniband/hw/nes/nes_hw.h
 create mode 100644 drivers/infiniband/hw/nes/nes_nic.c
 create mode 100644 drivers/infiniband/hw/nes/nes_user.h
 create mode 100644 drivers/infiniband/hw/nes/nes_utils.c
 create mode 100644 drivers/infiniband/hw/nes/nes_verbs.c
 create mode 100644 drivers/infiniband/hw/nes/nes_verbs.h
