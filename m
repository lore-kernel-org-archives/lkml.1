Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZLND6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZLND6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZLND6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:58:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64061 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbZLND6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:58:05 -0500
Message-ID: <4B25B7B7.9010008@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 11:57:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] tracing/filters: Fix MATCH_FRONT_ONLY filter matching
References: <4B25B797.1040201@cn.fujitsu.com>
In-Reply-To: <4B25B797.1040201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MATCH_FRONT_ONLY actually is a full matching.

We should pass the length of the pattern string to strncmp().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 50504cb..11c3973 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -261,7 +261,7 @@ static int regex_match_full(char *str, struct regex *r, int len)
 
 static int regex_match_front(char *str, struct regex *r, int len)
 {
-	if (strncmp(str, r->pattern, len) == 0)
+	if (strncmp(str, r->pattern, r->len) == 0)
 		return 1;
 	return 0;
 }
-- 
1.6.3

