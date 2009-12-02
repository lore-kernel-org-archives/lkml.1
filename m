Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZLBN22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZLBN22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZLBN22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:28:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:36534 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZLBN21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:28:27 -0500
Date: Wed, 2 Dec 2009 13:27:36 GMT
From: tip-bot for Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
In-Reply-To: <4B16503A.8030508@klingt.org>
References: <4B16503A.8030508@klingt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] Revert "sched, x86: Optimize branch hint in __switch_to()"
Message-ID: <tip-be8147e68625a1adb111acfd6b98a492be4b74d0@git.kernel.org>
Git-Commit-ID: be8147e68625a1adb111acfd6b98a492be4b74d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be8147e68625a1adb111acfd6b98a492be4b74d0
Gitweb:     http://git.kernel.org/tip/be8147e68625a1adb111acfd6b98a492be4b74d0
Author:     Tim Blechmann <tim@klingt.org>
AuthorDate: Wed, 2 Dec 2009 12:32:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 12:38:03 +0100

Revert "sched, x86: Optimize branch hint in __switch_to()"

This reverts commit a3a1de0c34de6f5f8332cd6151c46af7813c0fcb.

Commit 8ec6993d9f7d961014af970ded57542961fe9ad9 cleared the es
and ds selectors, so the original branch hints are correct now.
Therefore the branch hint doesn't need to be removed.

Signed-off-by: Tim Blechmann <tim@klingt.org>
LKML-Reference: <4B16503A.8030508@klingt.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_64.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 93c501d..eb62cbc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -406,10 +406,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
 	savesegment(es, prev->es);
-	if (next->es | prev->es)
+	if (unlikely(next->es | prev->es))
 		loadsegment(es, next->es);
+
 	savesegment(ds, prev->ds);
-	if (next->ds | prev->ds)
+	if (unlikely(next->ds | prev->ds))
 		loadsegment(ds, next->ds);
 
 
