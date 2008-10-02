Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbYJBXdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbYJBXdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYJBXdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:33:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:30429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbYJBXdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:33:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,353,1220252400"; 
   d="scan'208";a="446393111"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH 2.6.27-rc8 0/6] e1000e mutex protection
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tglx@linutronix.de,
       arjan@linux.intel.com, airlied@gmail.com, davem@davemloft.net,
       jeff@garzik.org
Date: Thu, 02 Oct 2008 16:33:14 -0700
Message-ID: <20081002233314.12556.49143.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2008 23:33:14.0952 (UTC) FILETIME=[3DCADC80:01C924E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes several bugs found by putting a
mutex inside e1000_acquire_swfw_flag, and then the patch from
Thomas actually adds this mutex to help find any further bugs.

Like Jesse Barnes said, "totally up to you (obviously) whether we
stuff this into 2.6.27 or hold on it until 2.6.28."

Linus, since you mentioned this exact same issue that Thomas (and
Dave Airlie) spotted I figured I should just send these.
Testing will continue over the next couple of days and I'll let
you know immediately if we find something.

The patches are pretty straight forward and each one fixed a
separate bug we found using the mutex patch.  It is possible that
these fix the actual corruption issue but we haven't verified
that yet.

---

Jesse Brandeburg (5):
      e1000e: update version from k4 to k6
      e1000e: drop stats lock
      e1000e: remove phy read from inside spinlock
      e1000e: do not ever sleep in interrupt context
      e1000e: reset swflag after resetting hardware

Thomas Gleixner (1):
      e1000e: debug contention on NVM SWFLAG


 drivers/net/e1000e/e1000.h   |    3 +-
 drivers/net/e1000e/ethtool.c |    6 +++-
 drivers/net/e1000e/ich8lan.c |   20 +++++++++++++
 drivers/net/e1000e/netdev.c  |   64 +++++++++++++++++++-----------------------
 4 files changed, 56 insertions(+), 37 deletions(-)

-- 
Jesse Brandeburg
