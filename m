Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZBJDVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZBJDVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZBJDVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:21:36 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:21362 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbZBJDVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:21:35 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 1/1] trace: use the more accurate parameter.
Date: Mon,  9 Feb 2009 19:30:04 -0500
Message-Id: <1234225804-13314-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4990F2B8.021F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass tsk to __update_max_tr instead of current to avoid latent hazard.

Impact: clean up

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5b1e9a9..c1592f1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -335,7 +335,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	data->rt_priority = tsk->rt_priority;
 
 	/* record this tasks comm */
-	tracing_record_cmdline(current);
+	tracing_record_cmdline(tsk);
 }
 
 static void
-- 
1.5.6

