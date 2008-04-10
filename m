Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYDJUz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYDJUz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbYDJUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:55:23 -0400
Received: from ns.suse.de ([195.135.220.2]:52576 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbYDJUzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:55:22 -0400
Date: Thu, 10 Apr 2008 13:55:21 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Jon Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Add additional examples in Documentation/spinlocks.txt
Message-ID: <20080410205520.GY21261@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch will throw an error if code doesn't use the correct initializers
for static spinlocks:

ERROR: Use of SPIN_LOCK_UNLOCKED is deprecated: see Documentation/spinlocks.txt

This is fine, but Documentation/spinlocks.txt isn't very clear on how to
_use_ the new initializers for static variables. To save people time in the
future, I added two small examples of how to fix old-style static
initializers to be more lockdep friendly.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>

diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
index 471e753..619699d 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/spinlocks.txt
@@ -5,6 +5,28 @@ Please use DEFINE_SPINLOCK()/DEFINE_RWLOCK() or
 __SPIN_LOCK_UNLOCKED()/__RW_LOCK_UNLOCKED() as appropriate for static
 initialization.
 
+Most of the time, you can simply turn:
+
+	static spinlock_t xxx_lock = SPIN_LOCK_UNLOCKED;
+
+into:
+
+	static DEFINE_SPINLOCK(xxx_lock);
+
+Static structure member variables go from:
+
+	struct foo bar {
+		.lock	=	SPIN_LOCK_UNLOCKED;
+	};
+
+to:
+
+	struct foo bar {
+		.lock	=	__SPIN_LOCK_UNLOCKED(bar.lock);
+	};
+
+Declaration of static rw_locks undergo a similar transformation.
+
 Dynamic initialization, when necessary, may be performed as
 demonstrated below.
 
