Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZHTLEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZHTLEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZHTLEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:04:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:54650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZHTLEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:04:11 -0400
Date: Thu, 20 Aug 2009 11:03:38 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A8A277D.4090304@ct.jp.nec.com>
References: <4A8A277D.4090304@ct.jp.nec.com>
Subject: [tip:sched/core] sched: Use for_each_class macro in move_one_task()
Message-ID: <tip-cde7e5ca4e329a157108769d1f752d191cbb71c6@git.kernel.org>
Git-Commit-ID: cde7e5ca4e329a157108769d1f752d191cbb71c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Aug 2009 11:03:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cde7e5ca4e329a157108769d1f752d191cbb71c6
Gitweb:     http://git.kernel.org/tip/cde7e5ca4e329a157108769d1f752d191cbb71c6
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Tue, 18 Aug 2009 13:01:01 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 20 Aug 2009 13:00:30 +0200

sched: Use for_each_class macro in move_one_task()

Replace for loop with the macro for_each_class to cleanup.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
LKML-Reference: <4A8A277D.4090304@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7f83be3..1b529ef 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3461,9 +3461,10 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 {
 	const struct sched_class *class;
 
-	for (class = sched_class_highest; class; class = class->next)
+	for_each_class(class) {
 		if (class->move_one_task(this_rq, this_cpu, busiest, sd, idle))
 			return 1;
+	}
 
 	return 0;
 }
