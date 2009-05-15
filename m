Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZEOOns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZEOOns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbZEOOn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:43:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:54697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbZEOOn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:43:26 -0400
Date: Fri, 15 May 2009 14:43:02 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A0CDC8C.30602@cn.fujitsu.com>
References: <4A0CDC8C.30602@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/filters: fix off-by-one bug
Message-ID: <tip-5872144f64b34a5942f6b4acedc90b02de72c58b@git.kernel.org>
Git-Commit-ID: 5872144f64b34a5942f6b4acedc90b02de72c58b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 14:43:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5872144f64b34a5942f6b4acedc90b02de72c58b
Gitweb:     http://git.kernel.org/tip/5872144f64b34a5942f6b4acedc90b02de72c58b
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 15 May 2009 11:07:56 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 May 2009 23:55:12 -0400

tracing/filters: fix off-by-one bug

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
