Return-Path: <linux-kernel-owner+w=401wt.eu-S935111AbYBCGU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935111AbYBCGU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759699AbYBCGUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:20:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:59319 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761505AbYBCGUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=naIqVo2L4hTPUloFYvuYml2UFmkyWehvdKtPuP2dCTmz52hXoqJXrVm7iv0woCrfaaraACz5RWod+Kya60XhMgurCB+RWHh+cs6iMXFjugmxobTVkrpURNmnKLAmwtgqwmyCdSbSpAo06hGc5ZkZyjPIdd2Df++GTJxciGsoclc=
Subject: [PATCH] cpuset: sparse warnings in cpuset.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 02 Feb 2008 22:20:19 -0800
Message-Id: <1202019619.1844.52.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to redeclare p, we have finished with it at this point,
so reuse it in the for loop.

kernel/cpuset.c:824:23: warning: symbol 'p' shadows an earlier one
kernel/cpuset.c:746:21: originally declared here
kernel/cpuset.c:1272:52: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/cpuset.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index cfaf641..fdbac43 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -821,7 +821,7 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	cgroup_iter_end(cgrp, &it);
 	if (heap.size) {
 		for (i = 0; i < heap.size; i++) {
-			struct task_struct *p = heap.ptrs[i];
+			p = heap.ptrs[i];
 			if (i == 0) {
 				latest_time = p->start_time;
 				latest_task = p;
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



