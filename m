Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509Ab0ANCyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0ANCyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226Ab0ANCyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:54:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0ANCyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:54:09 -0500
Message-ID: <4B4E8753.2000102@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 10:54:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching
References: <4B4E86FB.40208@cn.fujitsu.com>
In-Reply-To: <4B4E86FB.40208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @str might not be NULL-terminated if it's of type
DYN_STRING or STATIC_STRING, so we should use strnstr()
instead of strstr().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c6a0f8d..c43ebb3 100644
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

