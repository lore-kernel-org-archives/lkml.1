Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZKTQnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZKTQnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZKTQnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:43:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbZKTQk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:40:59 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 07/15] sched_feat_write: Update ppos instead of file->f_pos
Date: Fri, 20 Nov 2009 17:40:37 +0100
Message-Id: <1258735245-25826-8-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_feat_write() should update ppos instead of file->f_pos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..0114845 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -772,7 +772,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	if (!sched_feat_names[i])
 		return -EINVAL;
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
-- 
1.6.4.2

