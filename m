Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZELS2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZELS2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZELS2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:28:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:60406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbZELS2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:28:07 -0400
Date: Tue, 12 May 2009 18:27:29 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:core/urgent] lockdep: increase MAX_LOCKDEP_ENTRIES and MAX_LOCKDEP_CHAINS
Message-ID: <tip-d80c19df5fcceb8c741e96f09f275c2da719efef@git.kernel.org>
Git-Commit-ID: d80c19df5fcceb8c741e96f09f275c2da719efef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 18:27:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d80c19df5fcceb8c741e96f09f275c2da719efef
Gitweb:     http://git.kernel.org/tip/d80c19df5fcceb8c741e96f09f275c2da719efef
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 12 May 2009 16:29:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 May 2009 19:59:52 +0200

lockdep: increase MAX_LOCKDEP_ENTRIES and MAX_LOCKDEP_CHAINS

Now that lockdep coverage has increased it has become easier to
run out of entries:

[   21.401387] BUG: MAX_LOCKDEP_ENTRIES too low!
[   21.402007] turning off the locking correctness validator.
[   21.402007] Pid: 1555, comm: S99local Not tainted 2.6.30-rc5-tip #2
[   21.402007] Call Trace:
[   21.402007]  [<ffffffff81069789>] add_lock_to_list+0x53/0xba
[   21.402007]  [<ffffffff810eb615>] ? lookup_mnt+0x19/0x53
[   21.402007]  [<ffffffff8106be14>] check_prev_add+0x14b/0x1c7
[   21.402007]  [<ffffffff8106c304>] validate_chain+0x474/0x52a
[   21.402007]  [<ffffffff8106c6fc>] __lock_acquire+0x342/0x3c7
[   21.402007]  [<ffffffff8106c842>] lock_acquire+0xc1/0xe5
[   21.402007]  [<ffffffff810eb615>] ? lookup_mnt+0x19/0x53
[   21.402007]  [<ffffffff8153aedc>] _spin_lock+0x31/0x66

Double the size - as we've done in the past.

[ Impact: allow lockdep to cover more locks ]

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep_internals.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2cc7e9..699a2ac 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -54,9 +54,9 @@ enum {
  * table (if it's not there yet), and we check it for lock order
  * conflicts and deadlocks.
  */
-#define MAX_LOCKDEP_ENTRIES	8192UL
+#define MAX_LOCKDEP_ENTRIES	16384UL
 
-#define MAX_LOCKDEP_CHAINS_BITS	14
+#define MAX_LOCKDEP_CHAINS_BITS	15
 #define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)
 
 #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
