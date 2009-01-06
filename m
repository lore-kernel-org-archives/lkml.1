Return-Path: <linux-kernel-owner+w=401wt.eu-S1761917AbZAFWkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761917AbZAFWkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbZAFWeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:34:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867AbZAFWeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:34:08 -0500
Message-Id: <20090106223405.302758015@goodmis.org>
References: <20090106223337.677427397@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Jan 2009 17:33:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: convert unsigned index to signed
Content-Disposition: inline; filename=0001-ftrace-convert-unsigned-index-to-signed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to unsigned compared to less than zero

Roel Kluin pointed out that there is a compare of an unsigned number
to less than zero. A previous clean up had the unsigned index set
to -1 for certain cases, but never converted it to signed.

Frederic Weisbecker noticed that another index is used to compare
the above index to and it also needs to be converted to signed.

Reported-by: Roel Kluin <roel.kluin@gmail.com>
Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2f32969..3576707 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -289,7 +289,7 @@ static DEFINE_MUTEX(ftrace_regex_lock);
 
 struct ftrace_page {
 	struct ftrace_page	*next;
-	unsigned long		index;
+	long			index;
 	struct dyn_ftrace	records[];
 };
 
@@ -786,7 +786,7 @@ enum {
 
 struct ftrace_iterator {
 	struct ftrace_page	*pg;
-	unsigned		idx;
+	int			idx;
 	unsigned		flags;
 	unsigned char		buffer[FTRACE_BUFF_MAX+1];
 	unsigned		buffer_idx;
-- 
1.5.6.5

-- 
