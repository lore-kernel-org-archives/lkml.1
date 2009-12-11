Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZLKJ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZLKJ7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZLKJ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:59:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55231 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZLKJ7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:59:39 -0500
Message-ID: <4B221800.1050504@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 17:59:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tracing/filters: Fix MATCH_FRONT_ONLY filter matching
References: <4B2217D0.5000308@cn.fujitsu.com>
In-Reply-To: <4B2217D0.5000308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MATCH_FRONT_ONLY matching works exactly as MATCH_FULL.

We should pass the length of the pattern to strncmp().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c8eb1c0..bd492ce 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -262,7 +262,7 @@ static int regex_match_full(char *str, struct regex *r, int len)
 
 static int regex_match_front(char *str, struct regex *r, int len)
 {
-	if (strncmp(str, r->pattern, len) == 0)
+	if (strncmp(str, r->pattern, r->len) == 0)
 		return 1;
 	return 0;
 }
-- 
1.6.3

