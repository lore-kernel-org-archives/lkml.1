Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbZEODG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbZEODG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZEODGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:06:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58534 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZEODGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:06:47 -0400
Message-ID: <4A0CDC8C.30602@cn.fujitsu.com>
Date: Fri, 15 May 2009 11:07:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/filters: fix off-by-one bug
References: <4A0CDC6F.7070200@cn.fujitsu.com>
In-Reply-To: <4A0CDC6F.7070200@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should leave the last slot for the ending '\0'.

[ Impact: fix possible crash when the length of an operand is 128 ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3
