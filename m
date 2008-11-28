Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYK1Cc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYK1Cc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 21:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYK1Ccs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 21:32:48 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:12932 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYK1Ccs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 21:32:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XPJzwejNG7kwvlq791c0vIgNRJPBtiZEN3gZf3/SRC8ukjECS2IF6OMkpc3ZNAD5nN
         WRwDyqwIaHO25VPHbCKy4NFM1lXb2XDo+vx1vlxNQEmprv3RzxLBIfvLcbK0YBCImv0V
         Iev7nBRDpoFvTXF11uNRXLKy9a1fw77o8M5cc=
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ftrace: improve document
Date: Fri, 28 Nov 2008 10:32:41 +0800
Message-Id: <1227839561-8694-1-git-send-email-walimisdev@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <20081127162117.GA3467@elte.hu>
References: <20081127162117.GA3467@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add notice of using wild cards correctly

We know that we can use wild cards to set set_ftrace_filter, but there's
problem when using such as "echo h* > /debug/tracing/set_ftrace_filter".
If there are files named with "h" prefix in current directory, echo "h*"
will echo these files' name to set_ftrace_filter, not "h*".
For example:
$cat /debug/tracing/available_filter_functions |grep ^hr |wc -l
23
$ls
$touch hraa hrdd
$ls
hraa  hrdd
$echo hr* > /debug/tracing/set_ftrace_filter
$cat /debug/tracing/set_ftrace_filter

No output in /debug/tracing/set_ftrace_filter!
If we use '' to enclose wild cards, it works:

$ls
hraa  hrdd
$echo "hr*" > /debug/tracing/set_ftrace_filter
$cat /debug/tracing/set_ftrace_filter |wc -l
23

This problem can lead to unexpected result if current directory has a
lot of files.

Signed-off-by: walimis <walimisdev@gmail.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/ftrace.txt |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index de05042..0012a4a 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -1251,7 +1251,10 @@ These are the only wild cards which are supported.
 
   <match>*<match> will not work.
 
- # echo hrtimer_* > /debug/tracing/set_ftrace_filter
+Note: you'd better to use '' to enclose wild cards, otherwise in some
+cases you can't get the correct result.
+
+ # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
 
 Produces:
 
@@ -1306,7 +1309,7 @@ Again, now we want to append.
  # echo sys_nanosleep > /debug/tracing/set_ftrace_filter
  # cat /debug/tracing/set_ftrace_filter
 sys_nanosleep
- # echo hrtimer_* >> /debug/tracing/set_ftrace_filter
+ # echo 'hrtimer_*' >> /debug/tracing/set_ftrace_filter
  # cat /debug/tracing/set_ftrace_filter
 hrtimer_run_queues
 hrtimer_run_pending
-- 
1.6.0.3

