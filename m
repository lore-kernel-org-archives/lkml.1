Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZHDOQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZHDOQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZHDOQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:16:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:40670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbZHDOQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:16:17 -0400
Date: Tue, 4 Aug 2009 14:15:38 GMT
From: tip-bot for Bart Van Assche <bart.vanassche@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, gregkh@suse.de, tglx@linutronix.de,
       bart.vanassche@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, gregkh@suse.de, tglx@linutronix.de,
       bart.vanassche@gmail.com, mingo@elte.hu
In-Reply-To: <200907301900.54202.bart.vanassche@gmail.com>
References: <200907301900.54202.bart.vanassche@gmail.com>
Subject: [tip:core/cleanups] workqueues: Improve schedule_work() documentation
Message-ID: <tip-5b0f437df0a3e374d26ad533eb78fe64744f55a8@git.kernel.org>
Git-Commit-ID: 5b0f437df0a3e374d26ad533eb78fe64744f55a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 14:15:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b0f437df0a3e374d26ad533eb78fe64744f55a8
Gitweb:     http://git.kernel.org/tip/5b0f437df0a3e374d26ad533eb78fe64744f55a8
Author:     Bart Van Assche <bart.vanassche@gmail.com>
AuthorDate: Thu, 30 Jul 2009 19:00:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 15:21:16 +0200

workqueues: Improve schedule_work() documentation

Two important aspects of the schedule_work() function are not
yet documented:

 - that it is allowed to pass a struct work_struct * to this
   function that is already on the kernel-global workqueue;

 - the meaning of its return value.

The patch below documents both aspects.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <200907301900.54202.bart.vanassche@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/workqueue.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0668795..3c44b56 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -600,7 +600,12 @@ static struct workqueue_struct *keventd_wq __read_mostly;
  * schedule_work - put work task in global workqueue
  * @work: job to be done
  *
- * This puts a job in the kernel-global workqueue.
+ * Returns zero if @work was already on the kernel-global workqueue and
+ * non-zero otherwise.
+ *
+ * This puts a job in the kernel-global workqueue if it was not already
+ * queued and leaves it in the same position on the kernel-global
+ * workqueue otherwise.
  */
 int schedule_work(struct work_struct *work)
 {
