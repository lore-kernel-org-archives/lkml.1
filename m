Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbZLKIBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbZLKIBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760691AbZLKIBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:01:21 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:26622 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZLKIBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:01:20 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, tzanussi@gmail.com,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH]tracing: Fix inaccurate function definition in trace_events_filter.c
Date: Fri, 11 Dec 2009 15:58:58 +0800
Message-Id: <1260518338-16034-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B21FC51.014D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strcmp instead of strncmp to do full match.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 50504cb..06dc376 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -254,7 +254,7 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
 /* Basic regex callbacks */
 static int regex_match_full(char *str, struct regex *r, int len)
 {
-	if (strncmp(str, r->pattern, len) == 0)
+	if (strcmp(str, r->pattern) == 0)
 		return 1;
 	return 0;
 }
-- 
1.5.6

