Return-Path: <linux-kernel-owner+w=401wt.eu-S936511AbYBCHmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936511AbYBCHmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYBCHmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:42:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:34203 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbYBCHmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TBofnjHmfFEbSUiFU8bRtpqN6bZhvDR3xfxlU9Q57vv/igvj8BFzjTUyjmS9DlBak9FWgA/29Qe8dbwEK92nygg3NDfw6+o7HBjSKsPRSSgdWxtwIP/2eEXwUSrhcRHUYQSbxNLGRpnkUH4NYCGo4PHp3HWrE7kiOBD878wzWu0=
Subject: Re: [PATCH] cpuset: sparse warnings in cpuset.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Jackson <pj@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080203012815.05a50b13.pj@sgi.com>
References: <1202019619.1844.52.camel@brick>
	 <20080203012815.05a50b13.pj@sgi.com>
Content-Type: text/plain
Date: Sat, 02 Feb 2008 23:42:23 -0800
Message-Id: <1202024543.1844.57.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't redeclare p, use a new variable q.

kernel/cpuset.c:824:23: warning: symbol 'p' shadows an earlier one
kernel/cpuset.c:746:21: originally declared here
kernel/cpuset.c:1272:52: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Paul, used a variable q instead as per your request.

 kernel/cpuset.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index cfaf641..ce0cfff 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -821,13 +821,13 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	cgroup_iter_end(cgrp, &it);
 	if (heap.size) {
 		for (i = 0; i < heap.size; i++) {
-			struct task_struct *p = heap.ptrs[i];
+			struct task_struct *q = heap.ptrs[i];
 			if (i == 0) {
-				latest_time = p->start_time;
-				latest_task = p;
+				latest_time = q->start_time;
+				latest_task = q;
 			}
-			set_cpus_allowed(p, cs->cpus_allowed);
-			put_task_struct(p);
+			set_cpus_allowed(q, cs->cpus_allowed);
+			put_task_struct(q);
 		}
 		/*
 		 * If we had to process any tasks at all, scan again
@@ -1269,7 +1269,8 @@ static ssize_t cpuset_common_file_write(struct cgroup *cont,
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
-	if ((buffer = kmalloc(nbytes + 1, GFP_KERNEL)) == 0)
+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
 	if (copy_from_user(buffer, userbuf, nbytes)) {
-- 
1.5.4.rc5.1138.g2602



