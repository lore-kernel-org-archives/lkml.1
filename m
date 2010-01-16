Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0APJo7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840Ab0APJo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:44:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:54245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab0APJoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:44:54 -0500
Date: Sat, 16 Jan 2010 09:44:27 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4B4E8770.7000608@cn.fujitsu.com>
References: <4B4E8770.7000608@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/filters: Add comment for match callbacks
Message-ID: <tip-d1303dd1d6b220cab375f24fa91a5640e54e169e@git.kernel.org>
Git-Commit-ID: d1303dd1d6b220cab375f24fa91a5640e54e169e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:44:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1303dd1d6b220cab375f24fa91a5640e54e169e
Gitweb:     http://git.kernel.org/tip/d1303dd1d6b220cab375f24fa91a5640e54e169e
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 14 Jan 2010 10:54:40 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jan 2010 22:38:14 -0500

tracing/filters: Add comment for match callbacks

We should be clear on 2 things:

- the length parameter of a match callback includes
  tailing '\0'.

- the string to be searched might not be NULL-terminated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B4E8770.7000608@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 60c2a4e..e42af9a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -252,7 +252,18 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
 	return 0;
 }
 
-/* Basic regex callbacks */
+/*
+ * regex_match_foo - Basic regex callbacks
+ *
+ * @str: the string to be searched
+ * @r:   the regex structure containing the pattern string
+ * @len: the length of the string to be searched (including '\0')
+ *
+ * Note:
+ * - @str might not be NULL-terminated if it's of type DYN_STRING
+ *   or STATIC_STRING
+ */
+
 static int regex_match_full(char *str, struct regex *r, int len)
 {
 	if (strncmp(str, r->pattern, len) == 0)
