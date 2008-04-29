Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbYD2U6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbYD2U6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763903AbYD2U5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:57:38 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:52737 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763230AbYD2U5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:57:35 -0400
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 29 Apr 2008 13:57:33 -0700
Message-ID: <adamynctm4i.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Apr 2008 20:57:34.0099 (UTC) FILETIME=[A5C4CE30:01C8AA3B]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a last batch of changes before 2.6.26-rc1:

Eli Cohen (2):
      IPoIB: Use separate CQ for UD send completions
      IPoIB: Copy child MTU from parent

Eli Dorfman (2):
      IB/iser: Move high-volume debug output to higher debug level
      IB/iser: Count FMR alignment violations per session

Eric Schneider (1):
      RDMA/nes: Add support for SFP+ PHY

Faisal Latif (1):
      RDMA/nes: Use LRO

Glenn Streiff (1):
      RDMA/nes: Formatting cleanup

Hoang-Nam Nguyen (1):
      IB/ehca: handle negative return value from ibmebus_request_irq() properly

Olaf Kirch (2):
      mlx4_core: Avoid recycling old FMR R_Keys too soon
      IB/mthca: Avoid recycling old FMR R_Keys too soon

Roland Dreier (1):
      IB/mthca: Avoid changing userspace ABI to handle DMA write barrier attribute

Stefan Roscher (1):
      IB/ehca: Allocate event queue size depending on max number of CQs and QPs

Steve Wise (3):
      RDMA/cxgb3: Correctly serialize peer abort path
      RDMA/cxgb3: Set the max_mr_size device attribute correctly
      RDMA/cxgb3: Support peer-2-peer connection setup

Yevgeny Petrilin (1):
      mlx4_core: Add a way to set the "collapsed" CQ flag

 drivers/infiniband/hw/cxgb3/cxio_hal.c       |   18 ++-
 drivers/infiniband/hw/cxgb3/cxio_hal.h       |    1 +
 drivers/infiniband/hw/cxgb3/cxio_wr.h        |   21 ++-
 drivers/infiniband/hw/cxgb3/iwch.c           |    1 +
 drivers/infiniband/hw/cxgb3/iwch.h           |    1 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |  167 ++++++++----
 drivers/infiniband/hw/cxgb3/iwch_cm.h        |    2 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.h  |    3 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c        |   60 ++++-
 drivers/infiniband/hw/ehca/ehca_classes.h    |    5 +
 drivers/infiniband/hw/ehca/ehca_cq.c         |   11 +
 drivers/infiniband/hw/ehca/ehca_eq.c         |   35 ++--
 drivers/infiniband/hw/ehca/ehca_main.c       |   36 +++-
 drivers/infiniband/hw/ehca/ehca_qp.c         |   26 ++-
 drivers/infiniband/hw/mlx4/cq.c              |    2 +-
 drivers/infiniband/hw/mthca/mthca_mr.c       |   13 -
 drivers/infiniband/hw/mthca/mthca_provider.c |   14 +-
 drivers/infiniband/hw/mthca/mthca_provider.h |    1 +
 drivers/infiniband/hw/mthca/mthca_user.h     |   10 +-
 drivers/infiniband/hw/nes/Kconfig            |    1 +
 drivers/infiniband/hw/nes/nes.c              |    4 +
 drivers/infiniband/hw/nes/nes.h              |    5 +-
 drivers/infiniband/hw/nes/nes_cm.c           |    8 +-
 drivers/infiniband/hw/nes/nes_hw.c           |  371 ++++++++++++++++++++------
 drivers/infiniband/hw/nes/nes_hw.h           |   19 +-
 drivers/infiniband/hw/nes/nes_nic.c          |  180 ++++++++-----
 drivers/infiniband/hw/nes/nes_utils.c        |   10 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h         |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |   45 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c   |   39 ++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    |    3 +
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    4 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    7 +
 drivers/infiniband/ulp/iser/iser_memory.c    |    9 +-
 drivers/net/cxgb3/version.h                  |    2 +-
 drivers/net/mlx4/cq.c                        |    4 +-
 drivers/net/mlx4/mr.c                        |    6 -
 include/linux/mlx4/device.h                  |    3 +-
 include/scsi/libiscsi.h                      |    1 +
 44 files changed, 845 insertions(+), 327 deletions(-)
