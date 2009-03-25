Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZCYDd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZCYDd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZCYDdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:33:49 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:50356 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZCYDds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:33:48 -0400
X-IronPort-AV: E=Sophos;i="4.38,416,1233532800"; 
   d="scan'208";a="146190762"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: RDMA/InfiniBand merge plans for 2.6.30
X-Message-Flag: Warning: May contain useful information
Date: Tue, 24 Mar 2009 20:33:45 -0700
Message-ID: <ada4oxiwa1y.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2009 03:33:46.0017 (UTC) FILETIME=[80D76110:01C9ACFA]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.29 is out, I should update everyone on 2.6.30 merge plans.
All the pending things that I'm aware of are listed below.  As usual, if
something isn't already in my tree and it isn't listed below, I probably
missed it or dropped it unintentionally.  Please remind me again.

Boilerplate:

As usual, when submitting a patch:

 - Give a good changelog that explains what issue your patch
   addresses, how you address the issue, how serious the issue is, and
   any other information that would be useful to someone evaluating
   your patch or reading it years from now.

 - Please make sure that you include a "Signed-off-by:" line, and put
   any extra junk that should not go into the final kernel log *after*
   the "---" line so that git tools strip it off automatically.  Make
   the subject line be appropriate for inclusion in the kernel log as
   well once the leading "[PATCH ...]" stuff is stripped off.  I waste a
   lot of time fixing patches by hand that could otherwise be spent
   doing something productive like watching youtube.

 - Run your patch through checkpatch.pl so I don't have to nag you to
   fix trivial issues (or spend time fixing them myself).

 - Read your patch over so I don't see a memory leak or deadlock as
   soon as I look at it.

 - Build your patch with sparse checking ("C=2 CF=-D__CHECK_ENDIAN__")
   and make sure it doesn't introduce new warnings.  (A big bonus in
   goodwill for sending patches that fix old warnings)

 - Test your patch on a kernel with things like slab debugging and
   lockdep turned on.

And while you're waiting for me to get to your patch, I sure wouldn't
mind if you read and commented on someone else's patch.  None of this
means you shouldn't remind me about pending patches, since I often
lose track of things and drop them accidentally.

Core:

 - Fix for sysfs lifetime problem that could allow userspace to call
   into a device driver after it's unloaded.

 - Several fixes for the MAD handling layer.

ULPs:

 - I have one IPoIB fix merge, and I have the nagging feeling that
   there are still IPoIB crash bugs that I lost track of.

HW specific:

 - I have a few cxgb3 fixes merged already, and I'll merge the EEH
   patch after the net-next tree lands, just to avoid merge hassles.

 - Many nes fixes.

 - Support for port type (IB or Ethernet) autonegotiation for mlx4 devices.

Here are a few topics that I believe will not be ready in time for the
2.6.30 window and will need to wait for 2.6.31 at least:

 - Jack's XRC patch set.  I just need time to work with Jack and clean
   up the code.

Here all the patches I already have in my for-next branch:

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

Steve Wise (3):
      RDMA/cxgb3: sgl/pbl offset calculation needs 64 bits
      RDMA/cxgb3: Connection termination fixes
      RDMA/cxgb3: Remove modulo math from build_rdma_recv()

Yevgeny Petrilin (3):
      mlx4_core: Don't perform SET_PORT command for Ethernet ports
      mlx4_core: Add link type autosensing
      IB/mlx4: Unregister IB device prior to CLOSE PORT command

