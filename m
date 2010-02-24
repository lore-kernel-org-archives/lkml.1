Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0BXHkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:40:55 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:56344 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab0BXHkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:40:53 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH -tip 5/5] tracing: simplify memory recycle of trace_define_field
Date: Wed, 24 Feb 2010 15:40:26 +0800
Message-Id: <1266997226-6833-5-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1266997226-6833-4-git-send-email-wenji.huang@oracle.com>
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
 <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
 <1266997226-6833-3-git-send-email-wenji.huang@oracle.com>
 <1266997226-6833-4-git-send-email-wenji.huang@oracle.com>
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B84D801.00A4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discard freeing field->type since it's not necessary and may be hazard.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_events.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c2a3077..3f972ad 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -60,10 +60,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	return 0;
 
 err:
-	if (field) {
+	if (field)
 		kfree(field->name);
-		kfree(field->type);
-	}
 	kfree(field);
 
 	return -ENOMEM;
-- 
1.5.6

