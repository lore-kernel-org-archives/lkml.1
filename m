Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbZI0GKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbZI0GKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 02:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZI0GKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 02:10:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:59393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZI0GKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 02:10:33 -0400
Date: Sun, 27 Sep 2009 06:10:05 GMT
From: tip-bot for Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rdreier@cisco.com, rolandd@cisco.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, tglx@linutronix.de, rolandd@cisco.com, mingo@elte.hu
In-Reply-To: <ada1vlw126s.fsf_-_@cisco.com>
References: <ada1vlw126s.fsf_-_@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer: Remove overly verbose "switch to high res mode" message
Message-ID: <tip-d3f6302e7e51b41af86c6496ffb2f95e8f2179df@git.kernel.org>
Git-Commit-ID: d3f6302e7e51b41af86c6496ffb2f95e8f2179df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 27 Sep 2009 06:10:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3f6302e7e51b41af86c6496ffb2f95e8f2179df
Gitweb:     http://git.kernel.org/tip/d3f6302e7e51b41af86c6496ffb2f95e8f2179df
Author:     Roland Dreier <rdreier@cisco.com>
AuthorDate: Thu, 24 Sep 2009 14:07:55 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 26 Sep 2009 16:58:09 +0200

hrtimer: Remove overly verbose "switch to high res mode" message

On big systems, printing <number of CPUs> copies of

    Switched to high resolution mode on CPU nnn

clutters up the kernel log for minimal gain.  Just get rid of them.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
LKML-Reference: <ada1vlw126s.fsf_-_@cisco.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/hrtimer.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e5d98ce..4267279 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -720,8 +720,6 @@ static int hrtimer_switch_to_hres(void)
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
 	local_irq_restore(flags);
-	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
-	       smp_processor_id());
 	return 1;
 }
 
