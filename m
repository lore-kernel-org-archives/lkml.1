Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0AOD67 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629Ab0AOD64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:58:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0AOD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=BDJRW4DWT_kA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=8tRRyqQ7ZM891AgXRl8A:9 a=fF_WwCyopPVWpRC0eiid1ja4GY8A:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035852.706293101@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/8] tracing/filters: Fix MATCH_FRONT_ONLY filter matching
References: <20100115035726.462940848@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-filters-Fix-MATCH_FRONT_ONLY-filter-matching.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

MATCH_FRONT_ONLY actually is a full matching:

  # ./perf record -R -f -a -e lock:lock_acquire \
	--filter 'name ~rcu_*' sleep 1
  # ./perf trace
  (no output)

We should pass the length of the pattern string to strncmp().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B4E8721.5090301@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.6.5


