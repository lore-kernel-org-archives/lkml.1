Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZKWSzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZKWSzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZKWSzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:55:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:56017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZKWSzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:55:38 -0500
Date: Mon, 23 Nov 2009 18:54:36 GMT
From: tip-bot for Jan Blunck <jblunck@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jamie@shareable.org, peterz@infradead.org, alan@lxorguk.ukuu.org.uk,
       jblunck@suse.de, hch@infradead.org, arnd@arndb.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jamie@shareable.org, peterz@infradead.org, jblunck@suse.de,
       alan@lxorguk.ukuu.org.uk, hch@infradead.org, arnd@arndb.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258735245-25826-8-git-send-email-jblunck@suse.de>
References: <1258735245-25826-8-git-send-email-jblunck@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched_feat_write(): Update ppos instead of file->f_pos
Message-ID: <tip-429947248f814e90f416ab4f68a871ab628000c3@git.kernel.org>
Git-Commit-ID: 429947248f814e90f416ab4f68a871ab628000c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  429947248f814e90f416ab4f68a871ab628000c3
Gitweb:     http://git.kernel.org/tip/429947248f814e90f416ab4f68a871ab628000c3
Author:     Jan Blunck <jblunck@suse.de>
AuthorDate: Fri, 20 Nov 2009 17:40:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 19:38:03 +0100

sched_feat_write(): Update ppos instead of file->f_pos

sched_feat_write() should update ppos instead of file->f_pos.

(This reduces some BKL dependencies of this code.)

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: jkacur@redhat.com
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
LKML-Reference: <1258735245-25826-8-git-send-email-jblunck@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ab9a034..93474a7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -771,7 +771,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	if (!sched_feat_names[i])
 		return -EINVAL;
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
