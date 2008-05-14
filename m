Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYENQdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYENQdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYENQdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:33:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:32019 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYENQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:33:46 -0400
X-IronPort-AV: E=Sophos;i="4.27,487,1204531200"; 
   d="scan'208";a="98662559"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infinibang.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 May 2008 09:33:44 -0700
Message-ID: <aday76cj15j.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 May 2008 16:33:45.0179 (UTC) FILETIME=[47318AB0:01C8B5E0]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a fixes for various low-level HW driver issues:

 - nes bugs with LRO module parameter
 - cxgb3 bug in handling flushing on connection teardown
 - ipath miscellaneous issues (kind of big but look like needed fixes)

Pavel Emelyanov (1):
      IB/ipath: Make ipath_portdata work with struct pid * not pid_t

Ralph Campbell (3):
      IB/ipath: Fix RC and UC error handling
      IB/ipath: Fix many locking issues when switching to error state
      IB/ipath: Fix RDMA read response sequence checking

Roland Dreier (2):
      RDMA/nes: Fix up nes_lro_max_aggr module parameter
      IB/ipath: Change ipath_devdata.ipath_sdma_status to be unsigned long

Steve Wise (1):
      RDMA/cxgb3: Wrap the software send queue pointer as needed on flush

 drivers/infiniband/hw/cxgb3/cxio_hal.c        |    4 +-
 drivers/infiniband/hw/ipath/ipath_driver.c    |   20 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c  |   19 +-
 drivers/infiniband/hw/ipath/ipath_kernel.h    |   10 +-
 drivers/infiniband/hw/ipath/ipath_qp.c        |  237 ++++++++-----------
 drivers/infiniband/hw/ipath/ipath_rc.c        |  285 +++++++++++-----------
 drivers/infiniband/hw/ipath/ipath_ruc.c       |  329 ++++++++++++++----------
 drivers/infiniband/hw/ipath/ipath_uc.c        |   57 +++--
 drivers/infiniband/hw/ipath/ipath_ud.c        |   66 ++++--
 drivers/infiniband/hw/ipath/ipath_user_sdma.h |    2 -
 drivers/infiniband/hw/ipath/ipath_verbs.c     |  176 +++++++++-----
 drivers/infiniband/hw/ipath/ipath_verbs.h     |   64 ++++-
 drivers/infiniband/hw/nes/nes.c               |    4 -
 drivers/infiniband/hw/nes/nes.h               |    1 -
 drivers/infiniband/hw/nes/nes_hw.c            |    6 +-
 15 files changed, 725 insertions(+), 555 deletions(-)
