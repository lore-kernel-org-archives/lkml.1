Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031160Ab0B1BAQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 20:00:16 -0500
Received: from ozlabs.org ([203.10.76.45]:45429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031145Ab0B1BAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 20:00:10 -0500
Date: Sun, 28 Feb 2010 12:00:02 +1100
From: Anton Blanchard <anton@samba.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: [PATCH] workqueue: Fix a compile warning in work_busy
Message-ID: <20100228010002.GB13594@kryten>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ensure ret is initialised to avoid the following warning:

kernel/workqueue.c: In function ‘work_busy’:
kernel/workqueue.c:2697: warning: ‘ret’ may be used uninitialized in this function

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5871708..6003afd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2682,7 +2682,7 @@ unsigned int work_busy(struct work_struct *work)
 {
 	struct global_cwq *gcwq = get_work_gcwq(work);
 	unsigned long flags;
-	unsigned int ret;
+	unsigned int ret = 0;
 
 	if (!gcwq)
 		return false;
