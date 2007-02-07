Return-Path: <linux-kernel-owner+w=401wt.eu-S1422883AbXBGS6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422883AbXBGS6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422905AbXBGS57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:57:59 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:56108 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422883AbXBGS5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:57:48 -0500
Message-ID: <45CA212A.7000504@kernel.org>
Date: Wed, 07 Feb 2007 10:57:46 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] rcutorture: Remove redundant assignment to cur_ops in
 for loop
References: <45CA206C.2080205@kernel.org>
In-Reply-To: <45CA206C.2080205@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The for loop in rcutorture_init uses the condition
cur_ops = torture_ops[i], cur_ops
but then makes the same assignment to cur_ops inside the loop.  Remove the
redundant assignment inside the loop, and remove now-unnecessary braces.

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 kernel/rcutorture.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 0c7bf0c..7258bcb 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -875,12 +875,9 @@ rcu_torture_init(void)
 
 	/* Process args and tell the world that the torturer is on the job. */
 
-	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
-		cur_ops = torture_ops[i];
-		if (strcmp(torture_type, cur_ops->name) == 0) {
+	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++)
+		if (strcmp(torture_type, cur_ops->name) == 0)
 			break;
-		}
-	}
 	if (cur_ops == NULL) {
 		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
 		       torture_type);

