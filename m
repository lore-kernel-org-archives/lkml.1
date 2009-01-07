Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZAGERS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZAGERS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZAGERC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:17:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZAGERB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:17:01 -0500
Message-Id: <20090107041659.239423042@goodmis.org>
References: <20090107041605.168020089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Jan 2009 23:16:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 1/4] ftrace: convert unsigned index to signed
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

[
  Converted ftrace_page->index to int from unsigned long as
  Andrew Morton pointed out that there's no need for it to
  stay a long.
]

Reported-by: Roel Kluin <roel.kluin@gmail.com>
Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2f32969..9e54a6c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -289,7 +289,7 @@ static DEFINE_MUTEX(ftrace_regex_lock);
 
 struct ftrace_page {
 	struct ftrace_page	*next;
-	unsigned long		index;
+	int			index;
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
