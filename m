Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZEOEIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZEOEIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZEOEHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:07:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43599 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZEOEHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:07:47 -0400
Message-Id: <20090515040747.107781601@goodmis.org>
References: <20090515040554.074680910@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 00:05:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/4] tracing/filters: fix off-by-one bug
Content-Disposition: inline; filename=0004-tracing-filters-fix-off-by-one-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

We should leave the last slot for the ending '\0'.

[ Impact: fix possible crash when the length of an operand is 128 ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A0CDC8C.30602@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 22c2998..a7430b1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -736,7 +736,7 @@ static inline void clear_operand_string(struct filter_parse_state *ps)
 
 static inline int append_operand_char(struct filter_parse_state *ps, char c)
 {
-	if (ps->operand.tail == MAX_FILTER_STR_VAL)
+	if (ps->operand.tail == MAX_FILTER_STR_VAL - 1)
 		return -EINVAL;
 
 	ps->operand.string[ps->operand.tail++] = c;
-- 
1.6.2.4

-- 
