Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908Ab0CONVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:21:18 -0400
Received: from relay1.sgi.com ([192.48.179.29]:60747 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964882Ab0CONVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:21:13 -0400
Message-Id: <20100315132103.228021253@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 15 Mar 2010 08:21:03 -0500
From: holt@sgi.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org
Subject: [patch 0/2] x86,pat: Reduce contention on the memtype_lock -V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tracking memtype on x86 uses a single global spin_lock for either reading
or changing the memory type.  This includes changes made to page flags
which is perfectly parallel.

Part one of the patchset makes the page-based tracking use cmpxchg
without a need for a lock.

Part two of the patchset converts the spin_lock into a read/write lock.


To: Ingo Molnar <mingo@redhat.com>
To: H. Peter Anvin <hpa@zytor.com>
To: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org

---

 arch/x86/include/asm/cacheflush.h |   44 +++++++++++++++++++++-----------------
 arch/x86/mm/pat.c                 |   28 ++++++++----------------
 2 files changed, 35 insertions(+), 37 deletions(-)
