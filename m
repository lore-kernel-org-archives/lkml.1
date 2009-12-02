Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZLBTtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZLBTtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZLBTtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:49:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64981 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbZLBTtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:49:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a9Tv8zcIXJzl/ves/O9lIpF4MdqZtRAifWHycc2S2PSsMWPPdSC6M7u4MQNjqpm9U9
         /LlgGHgKmHKAhUXdfvgyo2SQTob3gjhHmgp/xOytF70RLAvB2qVmshBdb8o/Eq+LxeSm
         0TrB0JbounEQ16sbSNsUgf6v3I8oTc72DHhys=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] mutex: Fix missing conditions to build mutex_spin_on_owner()
Date: Wed,  2 Dec 2009 20:49:17 +0100
Message-Id: <1259783357-8542-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1259783357-8542-1-git-send-regression-fweisbec@gmail.com>
References: <1259783357-8542-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to build mutex_spin_on_owner() if we have
CONFIG_DEBUG_MUTEXES or CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES as it
won't be used under such configs.

Use CONFIG_MUTEX_SPIN_ON_OWNER as it gathers all the necessary checks
before building it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7b1b2b5..aa31244 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5527,7 +5527,7 @@ need_resched_nonpreemptible:
 }
 EXPORT_SYMBOL(schedule);
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 /*
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
-- 
1.6.2.3

