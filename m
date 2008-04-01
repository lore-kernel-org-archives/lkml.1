Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbYDAUCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbYDAUCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbYDAUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:02:22 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:59320 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbYDAUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:02:20 -0400
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's in infiniband.git)
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 01 Apr 2008 13:02:18 -0700
Message-ID: <adave31bayd.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Apr 2008 20:02:19.0281 (UTC) FILETIME=[4A6AB810:01C89433]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.26 will open soon, so it's time to review what my plans are
for the merge window opens.

As usual, patch review by non-me people is always welcome.

Anyway, here are all the pending things that I'm aware of.  As usual,
if something isn't already in my tree and isn't listed below, I
probably missed it or dropped it by mistake.  Please remind me again
in that case.

Core:

 - I did a bunch of cleanups all over drivers/infiniband and the
   gcc and sparse warning noise is down to a pretty reasonable level.
   Further cleanups welcome of course.

ULPs:

 - I merged Eli's IPoIB stateless offload changes for checksum
   offload and LSO changes.  The interrupt moderation changes are
   next, and should not be a problem to merge.  Please test IPoIB
   on all sorts of hardware!

 - Shirley's IPoIB 4 KB MTU changes.  I expect these to make it in,
   although I would certainly appreciate review from Eli or anyone else.

HW specific:

 - Vlad's mlx4 resize CQ support.  Looks basically OK, so I think we
   should be able to get it in.

 - ipath support for 7220 HCAs.  I don't expect any issues here once
   the patches appear.

Here are a few topics that I believe will not be ready in time for the
2.6.26 window and will need to wait for 2.6.27 at least:

 - XRC.  I still don't have a good feeling that we have settled on all
   the nuances of the ABI we want to expose to userspace for this, and
   ideally I would like to understand how ehca LL QPs fit into the
   picture as well.

 - Remove LLTX from IPoIB.  I haven't had time to finish this yet, so
   I guess it will probably wait for 2.6.27 now...

 - Multiple CQ event vector support.  I still haven't seen any
   discussions about how ULPs or userspace apps should decide which
   vector to use, and hence no progress has been made since we
   deferred this during the 2.6.23 merge window.

Here all the patches I already have in my for-2.6.26 branch:

Arthur Jones (4):
      IB/ipath: Fix sparse warning about pointer signedness
      IB/ipath: Misc sparse warning cleanup
      IB/ipath: Provide I/O bus speeds for diagnostic purposes
      IB/ipath: Fix link up LED display

Dave Olson (4):
      IB/ipath: Make some constants chip-specific, related cleanup
      IB/ipath: Shared context code needs to be sure device is usable
      IB/ipath: Enable 4KB MTU
      IB/ipath: HW workaround for case where chip can send but not receive

David Dillow (1):
      IB/srp: Enforce protocol limit on srp_sg_tablesize

Eli Cohen (7):
      IPoIB: Use checksum offload support if available
      IB/mlx4: Add IPoIB checksum offload support
      IB/mthca: Add IPoIB checksum offload support
      IB/core: Add creation flags to struct ib_qp_init_attr
      IB/core: Add IPoIB UD LSO support
      IPoIB: Add LSO support
      IB/mlx4: Add IPoIB LSO support

Harvey Harrison (1):
      IB: Replace remaining __FUNCTION__ occurrences with __func__

Hoang-Nam Nguyen (1):
      IB/ehca: Remove tgid checking

John Gregor (1):
      IB/ipath: Head of Line blocking vs forward progress of user apps

Julia Lawall (1):
      RDMA/iwcm: Test rdma_create_id() for IS_ERR rather than 0

Michael Albaugh (2):
      IB/ipath: Prevent link-recovery code from negating admin disable
      IB/ipath: EEPROM support for 7220 devices, robustness improvements, cleanup

Ralph Campbell (11):
      IB/ipath: Fix byte order of pioavail in handle_errors()
      IB/ipath: Fix error recovery for send buffer status after chip freeze mode
      IB/ipath: Don't try to handle freeze mode HW errors if diagnostic mode
      IB/ipath: Make debug error message match the constraint that is checked for
      IB/ipath: Add code to support multiple link speeds and widths
      IB/ipath: Remove useless comments
      IB/ipath: Fix sanity checks on QP number of WRs and SGEs
      IB/ipath: Change the module author
      IB/ipath: Remove some useless (void) casts
      IB/ipath: Make send buffers available for kernel if not allocated to user
      IB/ipath: Use PIO buffer for RC ACKs

Robert P. J. Day (2):
      IB: Use shorter list_splice_init() for brevity
      RDMA/nes: Use more concise list_for_each_entry()

Roland Dreier (28):
      IB/mthca: Formatting cleanups
      IB/mlx4: Convert "if(foo)" to "if (foo)"
      mlx4_core: Move opening brace of function onto a new line
      RDMA/amso1100: Don't use 0UL as a NULL pointer
      RDMA/cxgb3: IDR IDs are signed
      IB: Make struct ib_uobject.id a signed int
      IB/ipath: Fix sparse warning about shadowed symbol
      IB/mlx4: Endianness annotations
      IB/cm: Endianness annotations
      RDMA/ucma: Endian annotation
      RDMA/nes: Trivial endianness annotations
      RDMA/nes: Delete unused variables
      RDMA/amso1100: Start of endianness annotation
      RDMA/amso1100: Endian annotate mqsq allocator
      mlx4_core: Fix confusion between mlx4_event and mlx4_dev_event enums
      IB/uverbs: Don't store struct file * for event files
      IB/uverbs: Use alloc_file() instead of get_empty_filp()
      RDMA/nes: Remove redundant NULL check in nes_unregister_ofa_device()
      RDMA/nes: Remove unused nes_netdev_exit() function
      RDMA/nes: Use proper format and cast to print dma_addr_t
      RDMA/nes: Make symbols used only in a single source file static
      IB/ehca: Make symbols used only in a single source file static
      IB/core: Add support for "send with invalidate" work requests
      RDMA/amso1100: Add support for "send with invalidate" work requests
      IB/mthca: Avoid integer overflow when dealing with profile size
      IB/mthca: Avoid integer overflow when allocating huge ICM table
      IB/ipath: Fix PCI config write size used to clear linkctrl error bits
      RDMA/nes: Remove session_id from nes_cm stuff
