Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYJWLm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYJWLm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYJWLmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:42:50 -0400
Received: from mail49.e.nsc.no ([193.213.115.49]:47497 "EHLO mail49.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbYJWLmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:42:50 -0400
From: henrik@austad.us
To: menage@google.com
Cc: linux-kernel@vger.kernel.org, Henrik Austad <henrik@austad.us>
Subject: [PATCH] cgroup.c remove unused variable in cgroup_tasks_start
Date: Thu, 23 Oct 2008 13:42:40 +0200
Message-Id: <1224762160-23646-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <henrik@austad.us>

The variable i was moved by commit cc31edce, but the corresponding for loop that used i,
was completely removed. This causes warning at compile time.

Signed-off-by: Henrik Austad <henrik@austad.us>
---
 kernel/cgroup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 046c160..ed21eb5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2104,7 +2104,6 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
 		int end = cgrp->pids_length;
-		int i;
 		while (index < end) {
 			int mid = (index + end) / 2;
 			if (cgrp->tasks_pids[mid] == pid) {
-- 
1.6.0.2

