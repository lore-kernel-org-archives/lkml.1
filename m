Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbYEGTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbYEGTRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbYEGTRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:17:34 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:58775 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYEGTRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:17:31 -0400
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 07 May 2008 12:17:26 -0700
Message-ID: <adaiqxpvs8p.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2008 19:17:26.0566 (UTC) FILETIME=[FC4E0460:01C8B076]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a fixes for various low-level HW driver issues:

 - cxgb3 severe limits on memory registration size
 - ehca QP async event race
 - ipath miscellaneous issues

Dave Olson (2):
      IB/ipath: Fix bug that can leave sends disabled after freeze recovery
      IB/ipath: Need to always request and handle PIO avail interrupts

John Gregor (1):
      IB/ipath: Fix SDMA error recovery in absence of link status change

Michael Albaugh (2):
      IB/ipath: Only warn about prototype chip during init
      IB/ipath: Fix count of packets received by kernel

Ralph Campbell (2):
      IB/ipath: Only increment SSN if WQE is put on send queue
      IB/ipath: Return the correct opcode for RDMA WRITE with immediate

Roland Dreier (2):
      RDMA/cxgb3: Don't add PBL memory to gen_pool in chunks
      RDMA/cxgb3: Fix severe limit on userspace memory registration size

Stefan Roscher (1):
      IB/ehca: Wait for async events to finish before destroying QP

 drivers/infiniband/hw/cxgb3/cxio_hal.c        |   90 ++++++++--------
 drivers/infiniband/hw/cxgb3/cxio_hal.h        |    8 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c   |   36 +++++--
 drivers/infiniband/hw/cxgb3/iwch_mem.c        |   75 +++++++++-----
 drivers/infiniband/hw/cxgb3/iwch_provider.c   |   68 ++++++++++---
 drivers/infiniband/hw/cxgb3/iwch_provider.h   |    8 +-
 drivers/infiniband/hw/ehca/ehca_classes.h     |    2 +
 drivers/infiniband/hw/ehca/ehca_irq.c         |    4 +
 drivers/infiniband/hw/ehca/ehca_qp.c          |    5 +
 drivers/infiniband/hw/ipath/ipath_driver.c    |  138 ++++++++++++++++++++++---
 drivers/infiniband/hw/ipath/ipath_file_ops.c  |   72 ++++++--------
 drivers/infiniband/hw/ipath/ipath_iba7220.c   |   26 ++---
 drivers/infiniband/hw/ipath/ipath_init_chip.c |   95 ++++++++----------
 drivers/infiniband/hw/ipath/ipath_intr.c      |   80 ++------------
 drivers/infiniband/hw/ipath/ipath_kernel.h    |    8 ++-
 drivers/infiniband/hw/ipath/ipath_rc.c        |    6 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c       |    7 +-
 drivers/infiniband/hw/ipath/ipath_sdma.c      |   44 ++++++--
 drivers/infiniband/hw/ipath/ipath_verbs.c     |    2 +-
 19 files changed, 458 insertions(+), 316 deletions(-)
