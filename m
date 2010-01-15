Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0AOD7y (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750695Ab0AOD7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:59:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0AOD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=uVms-pL-hwIA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=E4w6SHRIdX0XDnkOxFUA:9 a=3eY1we9ngWmBJewzGgIC4XrZg3oA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035853.488710245@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/8] tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching
References: <20100115035726.462940848@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-filters-Fix-MATCH_MIDDLE_ONLY-filter-matchin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

The @str might not be NULL-terminated if it's of type
DYN_STRING or STATIC_STRING, so we should use strnstr()
instead of strstr().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B4E8753.2000102@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.6.5


