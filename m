Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZDQACA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZDQACA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZDQABs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:01:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:46992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZDQABq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:01:46 -0400
Date: Fri, 17 Apr 2009 00:00:45 GMT
From: tip-bot for H Hartley Sweeten <hartleys@visionengravers.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       hartleys@visionengravers.com, tglx@linutronix.de,
       hsweeten@visionengravers.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hartleys@visionengravers.com,
       hsweeten@visionengravers.com, mingo@elte.hu
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F9033@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F9033@mi8nycmail19.Mi8.com>
Subject: [tip:core/urgent] kernel/softirq.c: fix sparse warning
Message-ID: <tip-79d381c9f2354b594dcab9b04dfcc0debf7294fe@git.kernel.org>
Git-Commit-ID: 79d381c9f2354b594dcab9b04dfcc0debf7294fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 00:00:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79d381c9f2354b594dcab9b04dfcc0debf7294fe
Gitweb:     http://git.kernel.org/tip/79d381c9f2354b594dcab9b04dfcc0debf7294fe
Author:     H Hartley Sweeten <hartleys@visionengravers.com>
AuthorDate: Thu, 16 Apr 2009 19:30:18 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 01:57:54 +0200

kernel/softirq.c: fix sparse warning

Fix sparse warning in kernel/softirq.c.

  warning: do-while statement is not a compound statement

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
LKML-Reference: <BD79186B4FD85F4B8E60E381CAEE1909015F9033@mi8nycmail19.Mi8.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/softirq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2fecefa..b525dd3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -472,9 +472,9 @@ void tasklet_kill(struct tasklet_struct *t)
 		printk("Attempt to kill tasklet from interrupt\n");
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
-		do
+		do {
 			yield();
-		while (test_bit(TASKLET_STATE_SCHED, &t->state));
+		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
 	}
 	tasklet_unlock_wait(t);
 	clear_bit(TASKLET_STATE_SCHED, &t->state);
