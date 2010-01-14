Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620Ab0ANCym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab0ANCym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167Ab0ANCyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:54:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab0ANCyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:54:39 -0500
Message-ID: <4B4E8770.7000608@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 10:54:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] tracing/filters: Add comment for match callbacks
References: <4B4E86FB.40208@cn.fujitsu.com>
In-Reply-To: <4B4E86FB.40208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be clear on 2 things:

- the length parameter of a match callback includes
  tailing '\0'.

- the string to be searched might not be NULL-terminated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 14e83de..4615f62 100644
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
1.6.3

