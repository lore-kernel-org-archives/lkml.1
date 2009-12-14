Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZLND6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZLND6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZLND6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:58:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65402 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756571AbZLND6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:58:45 -0500
Message-ID: <4B25B7E0.5000403@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 11:58:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching
References: <4B25B797.1040201@cn.fujitsu.com>
In-Reply-To: <4B25B797.1040201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @str might not be NULL-terminated if it's of type
DYN_STRING or STATIC_STRING, so we should use strnstr()
instead of strstr().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 49e44dd..f364b08 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -268,7 +268,7 @@ static int regex_match_front(char *str, struct regex *r, int len)
 
 static int regex_match_middle(char *str, struct regex *r, int len)
 {
-	if (strstr(str, r->pattern))
+	if (strnstr(str, r->pattern, len))
 		return 1;
 	return 0;
 }
-- 
1.6.3

