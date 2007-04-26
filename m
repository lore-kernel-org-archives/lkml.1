Return-Path: <linux-kernel-owner+w=401wt.eu-S1031418AbXDZSm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031418AbXDZSm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031434AbXDZSm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:42:28 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:45794 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031418AbXDZSm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:42:27 -0400
X-IronPort-AV: i="4.14,457,1170662400"; 
   d="scan'208"; a="481754595:sNHT56566668"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 26 Apr 2007 11:42:18 -0700
Message-ID: <adak5vzrn91.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Apr 2007 18:42:18.0742 (UTC) FILETIME=[9E35D960:01C78832]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This is the first batch of merges for 2.6.22 -- mostly ipath driver fixes:

Arthur Jones (2):
      IB/ipath: Call free_irq() on chip specific initialization failure
      IB/ipath: Force PIOAvail update entry point

Bryan O'Sullivan (17):
      IB/ipath: Add ability to set and clear IB local loopback
      IB/ipath: Fix user memory region creation when IOMMU present
      IB/ipath: Definitions of two RXE parity err bits were reversed
      IB/ipath: Fix up some debug messages
      IB/ipath: Change packet problems vs chip errors handling and reporting
      IB/ipath: Fix bad argument to clear_bit()
      IB/ipath: Fix CQ flushing when QP is modified to error state
      IB/ipath: Remove unused ipath_read_kreg64_port()
      IB/ipath: Fix calculation for number of kernel PIO buffers
      IB/ipath: Discard multicast packets without a GRH
      IB/ipath: Print better error messages if kernel is misconfigured
      IB/ipath: Improve handling and reporting of parity errors
      IB/ipath: On unrecoverable errors, force link down, LEDs off
      IB/ipath: Prevent random program use of diags interface
      IB/ipath: Disable IB link earlier in shutdown sequence
      IB/ipath: Don't allow QPs 0 and 1 to be opened multiple times
      IB/ipath: Fix unit selection when all CPU affinity bits set

Hal Rosenstock (3):
      IB/umad: Fix declaration of dev_map[]
      IB/mad: Change SMI to use enums rather than magic return codes
      IB/umad: Clarify documentation of transaction ID

Joachim Fenkes (2):
      IB/ehca: Implement modify_port
      IB: Set class_dev->dev in core for nice device symlink

Mark Debbage (1):
      IB/ipath: Allow receive ports mapped into userspace to be shared

Michael Albaugh (1):
      IB/ipath: Fix driver crash (in interrupt or during unload) after chip reset

Ralph Campbell (8):
      IB/ipath: Don't initialize port memory for subports
      IB/ipath: Fix SRQ limit event causing dropped CQ entry
      IB/ipath: NMI cpu lockup if local loopback used
      IB/ipath: Support larger IB_QP_MAX_DEST_RD_ATOMIC and IB_QP_MAX_QP_RD_ATOMIC
      IB/ipath: Fix QP error completion queue entries
      IB/ipath: Fix PSN update for RC retries
      IB/ipath: Fix port sharing on powerpc
      IB/ipath: Fix RDMA reads of length zero and error handling

Robert Walsh (4):
      IB/ipath: Check reserved memory keys
      IB/ipath: Remove duplicate stuff from ipath_verbs.h
      IB/ipath: Check that a UD work request's address handle is valid
      IB/ipath: Fix WC format drift between user and kernel space

Roland Dreier (6):
      IB: Remove reference to obsolete CONFIG_IPATH_CORE
      IPoIB: Remove pointless opcode field from debugging output
      IB/mthca: Update HCA firmware revisions
      IB/mthca: Fix mthca_write_mtt() on HCAs with hidden memory
      IB/mthca: Simplify CQ cleaning in mthca_free_qp()
      IPoIB/cm: spin_lock_irqsave() -> spin_lock_irq() replacements

Sean Hefty (5):
      RDMA/ucma: Simplify ucma_get_event()
      IB/ucm: Simplify ib_ucm_event()
      IB/sa: Set src_path_bits correctly in ib_init_ah_from_path()
      IB/ipoib: Use ib_init_ah_from_path to initialize ah_attr
      IB/umad: Implement GRH handling for sent/received MADs

 Documentation/infiniband/user_mad.txt         |    8 +
 drivers/Makefile                              |    1 -
 drivers/infiniband/core/mad.c                 |   34 +-
 drivers/infiniband/core/sa_query.c            |   24 +-
 drivers/infiniband/core/smi.c                 |   86 ++--
 drivers/infiniband/core/smi.h                 |   34 +-
 drivers/infiniband/core/sysfs.c               |    1 +
 drivers/infiniband/core/ucm.c                 |   23 +-
 drivers/infiniband/core/ucma.c                |   22 +-
 drivers/infiniband/core/user_mad.c            |   20 +-
 drivers/infiniband/hw/amso1100/c2_provider.c  |    1 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c   |    1 -
 drivers/infiniband/hw/ehca/ehca_classes.h     |    1 +
 drivers/infiniband/hw/ehca/ehca_hca.c         |   55 ++-
 drivers/infiniband/hw/ehca/ehca_main.c        |    1 +
 drivers/infiniband/hw/ehca/hcp_if.c           |   24 +
 drivers/infiniband/hw/ehca/hcp_if.h           |    4 +
 drivers/infiniband/hw/ipath/ipath_common.h    |   23 +-
 drivers/infiniband/hw/ipath/ipath_cq.c        |   38 +-
 drivers/infiniband/hw/ipath/ipath_debug.h     |    1 +
 drivers/infiniband/hw/ipath/ipath_diag.c      |   11 +-
 drivers/infiniband/hw/ipath/ipath_driver.c    |  123 +++--
 drivers/infiniband/hw/ipath/ipath_eeprom.c    |    4 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c  |  287 +++++----
 drivers/infiniband/hw/ipath/ipath_iba6110.c   |  152 +++--
 drivers/infiniband/hw/ipath/ipath_iba6120.c   |   73 ++-
 drivers/infiniband/hw/ipath/ipath_init_chip.c |   86 ++-
 drivers/infiniband/hw/ipath/ipath_intr.c      |  100 ++-
 drivers/infiniband/hw/ipath/ipath_kernel.h    |   10 +-
 drivers/infiniband/hw/ipath/ipath_keys.c      |   14 +-
 drivers/infiniband/hw/ipath/ipath_mr.c        |   12 +-
 drivers/infiniband/hw/ipath/ipath_qp.c        |  133 +++--
 drivers/infiniband/hw/ipath/ipath_rc.c        |  920 ++++++++++++++-----------
 drivers/infiniband/hw/ipath/ipath_registers.h |   22 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c       |   63 +-
 drivers/infiniband/hw/ipath/ipath_stats.c     |   16 +-
 drivers/infiniband/hw/ipath/ipath_uc.c        |    6 +-
 drivers/infiniband/hw/ipath/ipath_ud.c        |    8 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c     |   15 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h     |   57 +-
 drivers/infiniband/hw/mthca/mthca_main.c      |   10 +-
 drivers/infiniband/hw/mthca/mthca_mr.c        |    6 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |    1 -
 drivers/infiniband/hw/mthca/mthca_qp.c        |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |   64 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   12 +-
 47 files changed, 1620 insertions(+), 1002 deletions(-)
