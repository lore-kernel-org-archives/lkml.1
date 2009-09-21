Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZIURNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZIURNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZIURNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:13:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZIURNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:13:10 -0400
Date: Mon, 21 Sep 2009 19:13:00 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: mingo@elte.hu, tglx@linuxtronix.de
cc: linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>
Subject: [PATCH] Increase MAX_STACK_TRACE_ENTRIES
Message-ID: <alpine.LFD.2.00.0909211744230.6572@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo: please consider this patch if there are no negative consequences to 
increasing this value. It fixes a problem that we have seen in the past on
(at least) the real-time kernel. (BUG: MAX_STACK_TRACE_ENTRIES).

This patch applies to the current tip/master

Thank You

Author: Clark Williams <williams@redhat.com>
Date: Mon, 21 Sep 2009 18:29:30 +0200
Subject: [PATCH] Increase MAX_STACK_TRACE_ENTRIES to compensate for lockdep and debug options eating up backtrace slots.

    Signed-off-by: Clark Williams <williams@redhat.com>
    Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/lockdep_internals.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2ee95a..953745c 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -65,7 +65,7 @@ enum {
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
  */
-#define MAX_STACK_TRACE_ENTRIES	262144UL
+#define MAX_STACK_TRACE_ENTRIES	393216UL
 
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
-- 
1.6.0.6


