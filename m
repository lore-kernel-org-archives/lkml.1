Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0AOD7t (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820Ab0AOD7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:59:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0AOD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=o1d-4ZaDwXYA:10 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=lxLSvOYYNPbOw4Q1MkYA:9 a=QnDhDaUlUyH_U0BZ5aI6n0fs7yoA:4 a=jeBq3FmKZ4MA:10 a=R3dLrO48-uA4aVCZ:21 a=BBhAZR82T47yAcRw:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035854.194896867@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 8/8] tracing/filters: Add comment for match callbacks
References: <20100115035726.462940848@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-filters-Add-comment-for-match-callbacks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.6.5


