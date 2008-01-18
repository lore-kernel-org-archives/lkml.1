Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYARALe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYARALe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbYARALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:11:17 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:23885 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbYARALO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:11:14 -0500
To: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: InfiniBand/RDMA merge plans for 2.6.25
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 17 Jan 2008 16:11:11 -0800
Message-ID: <ada7ii8xaao.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jan 2008 00:11:12.0272 (UTC) FILETIME=[A2311100:01C85966]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.25 will open soon, so it's time to review what my plans are
for the merge window opens.

A note on reviewing: the upstream push for "Reviewed-by:" tags seems
to have lost some momentum, but it is still the case that if you can
get someone other than me to review your work, then the chances of it
being merged increase dramatically.  I'm talking about a real review--
ideally, someone independent (a different domain after the '@' would
be good ;) who is willing to provide a "Reviewed-by:" line that means
the reviewer has really looked at and thought about the patch.  There
should be a mailing list thread you can point me at where the reviewer
comments on the patch and a new version of that patch addressing all
comments is posted (or in exceptional cases, where the patch is
perfect to start with, where the reviewer says the patch is great).

Anyway, here are all the pending things that I'm aware of.  As usual,
if something isn't already in my tree and isn't listed below, I
probably missed it or dropped it by mistake.  Please remind me again
in that case.

Core:

 - Sean's inter-subnet CM changes.  My first reaction is that I'll
   probably merge it, but I need to find the time to really read it
   over first.

ULPs:

 - Rolf's IPoIB MGID scope changes.  I have the core changes queued
   up, so at least recompiling the whole kernel should no longer be
   necessary.  I need to look over the rest of the patches more
   carefully and make sure we have the correct userspace interface at
   least.

 - Eli's IPoIB stateless offload (checksum offload, LSO, interrupt
   moderation, etc).  It's a big series that makes quite a few core
   changes.  I hope to merge at least part of this queue soon.
   Outside opinions are welcome though.

 - Remove LLTX from IPoIB.  I haven't posted a draft of this patch
   yet, so I guess it will probably wait for 2.6.26...

 - I still have a few SRP changes from David Dillow to review and
   apply.  Nothing looked to radical so they should be good to go.

HW specific:

 - Neteffect "nes" driver.  It's not terribly clean code but since
   it's a new driver that is completely self-contained, I plan on
   merging it and letting cleanups happen upstream.

 - mlx4 WQE shrinking patch.  I would like to see this as two patches:
   one that vmap()s work queues, and another that does the tricky part
   of using smaller WQEs.  If I get a chance I'll try to do the
   split up myself.

 - ipath pending patches.  Nothing looks like a problem there; it's
   just a matter of actually pulling the patches into my tree.

Here are a few topics that I believe will not be ready in time for the
2.6.25 window and will need to wait for 2.6.26 at least:

 - Multiple CQ event vector support.  I still haven't seen any
   discussions about how ULPs or userspace apps should decide which
   vector to use, and hence no progress has been made since we
   deferred this during the 2.6.23 merge window.

 - XRC.  I don't get the feeling that even the interface has converged
   sufficiently to merge this.

Here all the patches I already have in my for-2.6.25 branch:

Adrian Bunk (1):
      IB/mthca: Remove MSI support as scheduled

Anton Blanchard (1):
      IB/ehca: Use round_jiffies() for EQ polling timer

Arthur Jones (2):
      IB/ipath: Better comment for rmb() in ipath_intr()
      IB/ipath: Add ipath_read_ireg() abstraction

Dave Olson (5):
      IB/ipath: Improve interrupt handler cache footprint
      IB/ipath: Generalize some xxx_SHIFT macros
      IB/ipath: Changes for fields moving from devdata to portdata
      IB/ipath: Clean up some comments
      IB/ipath: Drop support for the original QHT7040 board

David Dillow (3):
      IB/srp: Respect target credit limit
      IB/srp: Enable SG list chaining
      IB/srp: Add identifying information to log messages

Erez Zilber (1):
      IB/iser: update URLs of iSER docs

Hoang-Nam Nguyen (1):
      IB/ehca: Forward event client-reregister-required to registered clients

Jack Morgenstein (1):
      mlx4_core: Fix max_eqs masking in QUERY_DEV_CAP

Joe Perches (2):
      drivers/infiniband: Add missing "space"
      IB: Spelling fixes in comments

John Gregor (1):
      IB/ipath: Fix sendctrl locking

Matthias Kaehlcke (1):
      IB/ipath: Convert ipath_eep_sem semaphore to a mutex

Nick Piggin (1):
      IB/ipath: Convert from .nopage to .fault

Olaf Kirch (1):
      IB/fmr_pool: Flush serial numbers can get out of sync

Oliver Pinter (1):
      IB/iser: Typo fix (s/destory/destroy/)

Pradeep Satyanarayana (2):
      IPoIB/cm: Add connected mode support for devices without SRQs
      IPoIB/CM: Enable SRQ support on HCAs that support fewer than 16 SG entries

Ralph Campbell (14):
      IB/mad: Remove redundant NULL pointer check in ib_mad_recv_done_handler()
      IB/ipath: Enable loopback of DR SMP responses from userspace
      IB/ipath: Remove dead code for user process waiting for send buffer
      IB/ipath: Fix error returned from ib_resize_cq if new size smaller than # entries
      IB/ipath: Fix comments for ipath_create_srq()
      IB/ipath: Add the work completion error code to the QP error debug output
      IB/ipath: Fix RNR NAK handling
      IB/ipath: Cleanup ipath_get_egrbuf()
      IB/ipath: kreceive uses portdata rather than devdata
      IB/ipath: MAD performance sampling registers support
      IB/ipath: Export hardware counters more consistently
      IB/ipath: Allow more flexible user register alignments
      IB/ipath: Port config has on-chip effects for 7220
      IB/ipath: Add flag and handling for chips with swapped register bug

Roland Dreier (8):
      IPoIB: Trivial formatting cleanups
      IPoIB/cm: Factor out ipoib_cm_free_rx_ring()
      IPoIB/cm: Factor out ipoib_cm_create_srq()
      IPoIB/cm: Factor out ipoib_cm_free_rx_reap_list()
      IB/mlx4: Micro-optimize mlx4_ib_poll_one()
      RDMA/cxgb3: Endianness annotation for irs field
      IB/ipath: Fix some sparse warnings about shadowed symbols
      IB/umad: Simplify and fix locking

Rolf Manderscheid (1):
      IPoIB: improve IPv4/IPv6 to IB mcast mapping functions

Sean Hefty (6):
      IB/multicast: Report errors on multicast groups if P_key changes
      IB/mad: Report number of times a mad was retried
      IB/cm: Add basic performance counters
      IB/mad: Fix incorrect access to items on local_list
      RDMA/cma: add support for rdma_migrate_id()
      RDMA/cma: Override default responder_resources with user value

Steve Welch (1):
      IB/mad: Enable loopback of DR SMP responses from userspace

Steve Wise (3):
      RDMA/iwcm: Set initiator depth and responder resources to device max values
      RDMA/cxgb3: Hold rtnl_lock() around ethtool get_drvinfo call
      RDMA/cxgb3: Support version 5.0 firmware

Vladimir Sokolovsky (1):
      RDMA/cma: Reenable device removal on passive side
