Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbZJGRBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbZJGRBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZJGRBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbZJGRBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:01:21 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tracing - correct module boundaries for ftrace_release
Date: Wed,  7 Oct 2009 19:00:34 +0200
Message-Id: <1254934835-363-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1254934835-363-1-git-send-email-jolsa@redhat.com>
References: <1254934835-363-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the module is about the unload we release its call records.
The ftrace_release function was given wrong values representing
the module core boundaries, thus not releasing its call records.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9a72853..09971c5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2652,9 +2652,9 @@ static int ftrace_module_notify(struct notifier_block *self,
 				   mod->num_ftrace_callsites);
 		break;
 	case MODULE_STATE_GOING:
-		ftrace_release(mod->ftrace_callsites,
-			       mod->ftrace_callsites +
-			       mod->num_ftrace_callsites);
+		ftrace_release(mod->module_core,
+			       mod->module_core +
+			       mod->core_size);
 		break;
 	}
 
