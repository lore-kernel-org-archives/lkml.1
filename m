Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYLDTkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYLDTkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbYLDTkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:40:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbYLDTkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:40:11 -0500
Date: Thu, 4 Dec 2008 20:39:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20081204193954.GA31785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Mathieu Desnoyers (1):
      documentation: local_ops fix on_each_cpu

Roel Kluin (1):
      check_hung_task(): unsigned sysctl_hung_task_warnings cannot be less than 0


 Documentation/local_ops.txt |    2 +-
 kernel/softlockup.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/local_ops.txt b/Documentation/local_ops.txt
index f4f8b1c..23045b8 100644
--- a/Documentation/local_ops.txt
+++ b/Documentation/local_ops.txt
@@ -149,7 +149,7 @@ static void do_test_timer(unsigned long data)
 	int cpu;
 
 	/* Increment the counters */
-	on_each_cpu(test_each, NULL, 0, 1);
+	on_each_cpu(test_each, NULL, 1);
 	/* Read all the counters */
 	printk("Counters read from CPU %d\n", smp_processor_id());
 	for_each_online_cpu(cpu) {
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 3953e4a..dc0b3be 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -188,7 +188,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
 	if ((long)(now - t->last_switch_timestamp) <
 					sysctl_hung_task_timeout_secs)
 		return;
-	if (sysctl_hung_task_warnings < 0)
+	if (!sysctl_hung_task_warnings)
 		return;
 	sysctl_hung_task_warnings--;
 
