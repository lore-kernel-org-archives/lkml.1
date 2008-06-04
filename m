Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYFDCmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYFDCmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYFDCmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:42:08 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28626 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYFDCmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:42:07 -0400
Date: Tue, 3 Jun 2008 19:42:16 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 2/4] per-task-delay-accounting: update taskstats for memory
Message-Id: <20080603194216.fdf42dd4.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
---
 include/linux/taskstats.h |    4 ++++
 kernel/delayacct.c        |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 5d69c07..87aae21 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -81,6 +81,10 @@ struct taskstats {
 	__u64	swapin_count;
 	__u64	swapin_delay_total;

+	/* Delay waiting for memory reclaim */
+	__u64	freepages_count;
+	__u64	freepages_delay_total;
+
 	/* cpu "wall-clock" running time
 	 * On some architectures, value will adjust for cpu time stolen
 	 * from the kernel in involuntary waits due to virtualization.
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 84b6782..b3179da 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -145,8 +145,11 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	d->blkio_delay_total = (tmp < d->blkio_delay_total) ? 0 : tmp;
 	tmp = d->swapin_delay_total + tsk->delays->swapin_delay;
 	d->swapin_delay_total = (tmp < d->swapin_delay_total) ? 0 : tmp;
+	tmp = d->freepages_delay_total + tsk->delays->freepages_delay;
+	d->freepages_delay_total = (tmp < d->freepages_delay_total) ? 0 : tmp;
 	d->blkio_count += tsk->delays->blkio_count;
 	d->swapin_count += tsk->delays->swapin_count;
+	d->freepages_count += tsk->delays->freepages_count;
 	spin_unlock_irqrestore(&tsk->delays->lock, flags);

 done:
-- 
1.5.0.6 
