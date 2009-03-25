Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZCYEFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZCYEFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbZCYEFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:05:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:51572 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZCYEFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:05:03 -0400
X-IronPort-AV: E=Sophos;i="4.38,416,1233532800"; 
   d="scan'208";a="273583987"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 24 Mar 2009 21:05:00 -0700
Message-ID: <adar60muu1f.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2009 04:05:00.0627 (UTC) FILETIME=[DE322A30:01C9ACFE]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This has the first batch of 2.6.30 changes -- I have one more patch
that I'll send after the net-next tree is merged (just to avoid merge
hassles due to dependencies).

Chien Tung (3):
      RDMA/nes: Update copyright to new legal entity and year
      RDMA/nes: Report correct vendor_id and vendor_part_id
      RDMA/nes: Fix tmp_addr compilation warning

Don Wood (3):
      RDMA/nes: Account for freed PBL after HW operation
      RDMA/nes: Inform hardware that asynchronous event has been handled
      RDMA/nes: Improve use of PBLs

Faisal Latif (2):
      RDMA/nes: Remove LLTX
      RDMA/nes: Handle MPA Reject message properly

Harvey Harrison (1):
      IB: Remove __constant_{endian} uses

Jack Morgenstein (3):
      IPoIB: In unicast_arp_send(), only free newly-created paths
      mlx4_core: Add device IDs for MT25458 10GigE devices
      IB/sa_query: Fix AH leak due to update_sm_ah() race

Moni Shoua (2):
      IB/mlx4: Fix dispatch of IB_EVENT_LID_CHANGE event
      IB/mthca: Fix dispatch of IB_EVENT_LID_CHANGE event

Or Gerlitz (1):
      IB/iser: Remove hard setting of path MTU

Ralph Campbell (3):
      IB/mad: Fix null pointer dereference in local_completions()
      IB/mad: initialize mad_agent_priv before putting on lists
      IB/mad: Fix ib_post_send_mad() returning 0 with no generate send comp

Ramachandra K (1):
      IB/mad: Fix RMPP header RRespTime manipulation

Roland Dreier (5):
      IB/ipath: Fix memory leak in init_shadow_tids() error path
      IB/ipath: Really run work in ipath_release_user_pages_on_close()
      IB: Remove sysfs files before unregistering device
      IB: Remove useless ibdev_is_alive() tests from sysfs code
      Merge branches 'cxgb3', 'endian', 'ipath', 'ipoib', 'iser', 'mad', 'misc', 'mlx4', 'mthca', 'nes' and 'sysfs' into for-next

Steve Wise (4):
      RDMA/cxgb3: sgl/pbl offset calculation needs 64 bits
      RDMA/cxgb3: Connection termination fixes
      RDMA/cxgb3: Remove modulo math from build_rdma_recv()
      RDMA/cxgb3: Enforce required firmware

Yevgeny Petrilin (3):
      mlx4_core: Don't perform SET_PORT command for Ethernet ports
      mlx4_core: Add link type autosensing
      IB/mlx4: Unregister IB device prior to CLOSE PORT command

 drivers/infiniband/core/cm.c                   |   15 +-
 drivers/infiniband/core/cm_msgs.h              |   22 +-
 drivers/infiniband/core/device.c               |    4 +-
 drivers/infiniband/core/mad.c                  |   40 +-
 drivers/infiniband/core/mad_rmpp.c             |    2 +-
 drivers/infiniband/core/sa_query.c             |    2 +
 drivers/infiniband/core/sysfs.c                |   19 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |   30 ++-
 drivers/infiniband/hw/cxgb3/cxio_hal.h         |    3 +
 drivers/infiniband/hw/cxgb3/cxio_wr.h          |    6 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    3 +
 drivers/infiniband/hw/cxgb3/iwch_ev.c          |    5 -
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |   17 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c          |    8 +-
 drivers/infiniband/hw/ipath/ipath_eeprom.c     |    4 +-
 drivers/infiniband/hw/ipath/ipath_init_chip.c  |    2 +-
 drivers/infiniband/hw/ipath/ipath_mad.c        |   95 ++--
 drivers/infiniband/hw/ipath/ipath_rc.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_sdma.c       |    4 +-
 drivers/infiniband/hw/ipath/ipath_uc.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_ud.c         |    4 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    8 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c  |    6 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c      |    2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h      |   10 +-
 drivers/infiniband/hw/mlx4/mad.c               |   27 +-
 drivers/infiniband/hw/mlx4/main.c              |    5 +-
 drivers/infiniband/hw/mlx4/qp.c                |   22 +-
 drivers/infiniband/hw/mthca/mthca_mad.c        |   25 +-
 drivers/infiniband/hw/nes/nes.c                |    2 +-
 drivers/infiniband/hw/nes/nes.h                |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c             |  586 ++++++++++++++++--------
 drivers/infiniband/hw/nes/nes_cm.h             |   12 +-
 drivers/infiniband/hw/nes/nes_context.h        |    2 +-
 drivers/infiniband/hw/nes/nes_hw.c             |   17 +-
 drivers/infiniband/hw/nes/nes_hw.h             |    5 +-
 drivers/infiniband/hw/nes/nes_nic.c            |  142 +++----
 drivers/infiniband/hw/nes/nes_user.h           |    2 +-
 drivers/infiniband/hw/nes/nes_utils.c          |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c          |  249 +++++++----
 drivers/infiniband/hw/nes/nes_verbs.h          |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    9 +-
 drivers/infiniband/ulp/iser/iser_verbs.c       |    7 -
 drivers/net/mlx4/Makefile                      |    2 +-
 drivers/net/mlx4/catas.c                       |   16 +-
 drivers/net/mlx4/eq.c                          |   16 +-
 drivers/net/mlx4/main.c                        |  106 ++++--
 drivers/net/mlx4/mlx4.h                        |   27 +-
 drivers/net/mlx4/port.c                        |   13 +-
 drivers/net/mlx4/sense.c                       |  156 +++++++
 include/linux/mlx4/cmd.h                       |    1 +
 include/linux/mlx4/device.h                    |    6 +-
 include/rdma/ib_cm.h                           |   12 +-
 include/rdma/ib_mad.h                          |    4 +-
 include/rdma/ib_smi.h                          |   34 +-
 55 files changed, 1190 insertions(+), 636 deletions(-)
 create mode 100644 drivers/net/mlx4/sense.c
