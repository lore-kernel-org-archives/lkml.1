Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXEUUwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXEUUwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXEUUwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:52:00 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:10825 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbXEUUv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:51:59 -0400
X-IronPort-AV: i="4.14,562,1170662400"; 
   d="scan'208"; a="155858983:sNHT4001204565"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 21 May 2007 13:51:43 -0700
Message-ID: <adaodkddhnk.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 May 2007 20:51:44.0069 (UTC) FILETIME=[D7087750:01C79BE9]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the following post 2.6.22-rc2 fixes.  (This batch is
bigger than I would like, but I think it's all legitimately post-rc2
material: we've had some fixes for fairly serious problems cooking for
a while, and those fixes involve largish patches.  The rest is either
trivial stuff or fixes for the just-merged mlx4 driver)

Ali Ayoub (1):
      IB/mthca: Fix use-after-free on device restart

Eli Cohen (3):
      IB/core: Free umem when mm is already gone
      IB/mlx4: Fix check of max_qp_dest_rdma in modify QP
      IB/mlx4: Pass send queue sizes from userspace to kernel

Hoang-Nam Nguyen (1):
      IB/ehca: Return proper error code if register_mr fails

Michael S. Tsirkin (5):
      IB/mthca: Fix RESET to ERROR transition
      IB/mlx4: Fix RESET to RESET and RESET to ERROR transitions
      IB/ipoib: Fix typos in error messages
      IPoIB/cm: Fix SRQ WR leak
      IB/cm: Improve local id allocation

Roland Dreier (6):
      IB/ipath: Fix potential deadlock with multicast spinlocks
      IB/core: Use start_port() and end_port()
      IB/mlx4: Set GRH:HopLimit when sending globally routed MADs
      mlx4_core: Fix array overrun in dump_dev_cap_flags()
      IB/mlx4: Fix check of opcode in mlx4_ib_post_send()
      IB/mlx4: Check if SRQ is full when posting receive

Rolf Manderscheid (1):
      IB/mthca: Set GRH:HopLimit when building MLX headers

Yosef Etigin (2):
      IB/core: Add helpers for uncached GID and P_Key searches
      IPoIB: Handle P_Key table reordering

 drivers/infiniband/core/cm.c                    |    4 +-
 drivers/infiniband/core/device.c                |  135 ++++++++++++++-
 drivers/infiniband/core/umem.c                  |    4 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c          |    7 +-
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c |   16 +-
 drivers/infiniband/hw/mlx4/qp.c                 |  181 ++++++++++++++------
 drivers/infiniband/hw/mlx4/srq.c                |    6 +
 drivers/infiniband/hw/mlx4/user.h               |    5 +-
 drivers/infiniband/hw/mthca/mthca_av.c          |    1 +
 drivers/infiniband/hw/mthca/mthca_main.c        |    4 +-
 drivers/infiniband/hw/mthca/mthca_qp.c          |  158 +++++++++++-------
 drivers/infiniband/ulp/ipoib/ipoib.h            |   49 +++++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c         |  203 +++++++++++++++++++----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c         |   87 ++++++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c  |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c      |   40 ++---
 drivers/net/mlx4/fw.c                           |    2 +-
 include/rdma/ib_verbs.h                         |    8 +
 19 files changed, 697 insertions(+), 222 deletions(-)
