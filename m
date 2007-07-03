Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbXGCQfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbXGCQfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXGCQfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:35:09 -0400
Received: from ns1.coraid.com ([65.14.39.133]:26401 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753212AbXGCQfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:35:07 -0400
Date: Tue, 3 Jul 2007 12:33:56 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: [PATCH 1/1] docs: static initialization of spinlocks is OK
Message-ID: <20070703163356.GF30089@coraid.com>
References: <<20070702213832.8864656c.akpm@linux-foundation.org>>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <<20070702213832.8864656c.akpm@linux-foundation.org>>
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Static initialization of spinlocks is preferable to dynamic
initialization when it is practical.  This patch updates documentation
for consistency with comments in spinlock_types.h.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 Documentation/spinlocks.txt |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
index a661d68..471e753 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/spinlocks.txt
@@ -1,7 +1,12 @@
-UPDATE March 21 2005 Amit Gud <gud@eth.net>
+SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED defeat lockdep state tracking and
+are hence deprecated.
 
-Macros SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated and will be
-removed soon. So for any new code dynamic initialization should be used:
+Please use DEFINE_SPINLOCK()/DEFINE_RWLOCK() or
+__SPIN_LOCK_UNLOCKED()/__RW_LOCK_UNLOCKED() as appropriate for static
+initialization.
+
+Dynamic initialization, when necessary, may be performed as
+demonstrated below.
 
    spinlock_t xxx_lock;
    rwlock_t xxx_rw_lock;
@@ -15,12 +20,9 @@ removed soon. So for any new code dynamic initialization should be used:
 
    module_init(xxx_init);
 
-Reasons for deprecation
-  - it hurts automatic lock validators
-  - it becomes intrusive for the realtime preemption patches
-
-Following discussion is still valid, however, with the dynamic initialization
-of spinlocks instead of static.
+The following discussion is still valid, however, with the dynamic
+initialization of spinlocks or with DEFINE_SPINLOCK, etc., used
+instead of SPIN_LOCK_UNLOCKED.
 
 -----------------------
 
-- 
1.5.2.1
