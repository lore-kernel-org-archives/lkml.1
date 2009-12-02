Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZLBLcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZLBLcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZLBLcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:32:14 -0500
Received: from mail.klingt.org ([86.59.21.178]:37987 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbZLBLcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:32:12 -0500
Message-ID: <4B16503A.8030508@klingt.org>
Date: Wed, 02 Dec 2009 12:32:10 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091128 Shredder/3.0.1pre
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "sched, x86: Optimize branch hint in __switch_to()"
References: <tip-a3a1de0c34de6f5f8332cd6151c46af7813c0fcb@git.kernel.org>
In-Reply-To: <tip-a3a1de0c34de6f5f8332cd6151c46af7813c0fcb@git.kernel.org>
Content-Type: multipart/mixed;
 boundary="------------000901070508040408030808"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Wed, 02 Dec 2009 12:32:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000901070508040408030808
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


This reverts commit a3a1de0c34de6f5f8332cd6151c46af7813c0fcb.

Commit 8ec6993d9f7d961014af970ded57542961fe9ad9 cleared the es and ds
selectors, so the original branch hints are correct now. Therefore
the branch hint doesn't need to be removed.

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
  arch/x86/kernel/process_64.c |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)



--------------000901070508040408030808
Content-Type: text/x-patch;
 name="0001-Revert-sched-x86-Optimize-branch-hint-in-__switch_to.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Revert-sched-x86-Optimize-branch-hint-in-__switch_to.pa";
 filename*1="tch"

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
 
 


--------------000901070508040408030808--
