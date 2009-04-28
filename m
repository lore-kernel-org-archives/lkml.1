Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZD1XEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZD1XEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZD1XDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:03:54 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:9007 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZD1XDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:03:53 -0400
X-IronPort-AV: E=Sophos;i="4.40,262,1238976000"; 
   d="scan'208";a="157479279"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Apr 2009 16:03:49 -0700
Message-ID: <ada8wlk2xey.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2009 23:03:49.0916 (UTC) FILETIME=[97ABBDC0:01C9C855]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a batch of changes for -rc2, mostly low-level hardware
driver fixes with a few other miscellaneous fixes and an IPoIB
documentation update.

Chien Tung (8):
      RDMA/nes: Fix compiler warning at nes_verbs.c:1955
      RDMA/nes: Modify thermo mitigation to flip SerDes1 ref clk to internal
      RDMA/nes: Correct CDR loop filter setting for port 1
      RDMA/nes: Enable repause timer for port 1
      RDMA/nes: Set trace length to 1 inch for SFP_D
      RDMA/nes: Fix fw_ver in /sys
      RDMA/nes: Fix unused variable compile warning when INFINIBAND_NES_DEBUG=n
      RDMA/nes: Update iw_nes version

Don Wood (1):
      RDMA/nes: Fix bugs in nes_reg_phys_mr()

Faisal Latif (5):
      RDMA/nes: Do not set apbvt entry for loopback
      RDMA/nes: Check for sequence number wrap-around
      RDMA/nes: Increase rexmit timeout interval
      RDMA/nes: Fix hang issues for large cluster dynamic connections
      RDMA/nes: Fix error path in nes_accept()

Jack Morgenstein (1):
      IB/mthca: Fix timeout for INIT_HCA and a few other commands

Matt Kraai (1):
      RDMA/nes: Remove root_256()'s unused pbl_count_256 parameter

Miroslaw Walukiewicz (1):
      RDMA/nes: Fix resource issues in nes_create_cq() and nes_destroy_cq()

Nicolas Morey-Chaisemartin (1):
      mlx4_core: Fix memory leak in mlx4_enable_msi_x()

Roland Dreier (1):
      Merge branches 'cxgb3', 'ipoib', 'mthca', 'mlx4' and 'nes' into for-linus

Steve Wise (2):
      RDMA/cxgb3: Adjust ORD/IRD (if needed) for peer2peer connections
      RDMA/cxgb3: Don't zero QP attrs when moving to IDLE

Yossi Etigin (1):
      IPoIB: Disable NAPI while CQ is being drained

 drivers/infiniband/hw/cxgb3/iwch_cm.c     |    8 +++
 drivers/infiniband/hw/cxgb3/iwch_qp.c     |    1 -
 drivers/infiniband/hw/mthca/mthca_cmd.c   |   16 +++---
 drivers/infiniband/hw/nes/nes.h           |    4 +-
 drivers/infiniband/hw/nes/nes_cm.c        |   84 ++++++++++++++--------------
 drivers/infiniband/hw/nes/nes_cm.h        |    1 +
 drivers/infiniband/hw/nes/nes_hw.c        |   30 ++++++----
 drivers/infiniband/hw/nes/nes_verbs.c     |   67 +++++++++++++++--------
 drivers/infiniband/hw/nes/nes_verbs.h     |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    6 ++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    5 +--
 drivers/net/mlx4/main.c                   |    2 +-
 12 files changed, 130 insertions(+), 95 deletions(-)
