Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYKUHNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYKUHNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYKUHNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:13:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62726 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYKUHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:13:30 -0500
Message-Id: <20081121071327.769783077@goodmis.org>
References: <20081121071213.365288293@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 02:12:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4] trace: remove extra assign in branch check
Content-Disposition: inline; filename=0001-trace-remove-extra-assign-in-branch-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up of branch check

The unlikely/likely profiler does an extra assign of the f.line.
This is not needed since it is already calculated at compile time.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/compiler.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c7d804a..c25e525 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -87,7 +87,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 				.file = __FILE__,			\
 				.line = __LINE__,			\
 			};						\
-			______f.line = __LINE__;			\
 			______r = likely_notrace(x);			\
 			ftrace_likely_update(&______f, ______r, 1);	\
 			______r;					\
@@ -102,7 +101,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 				.file = __FILE__,			\
 				.line = __LINE__,			\
 			};						\
-			______f.line = __LINE__;			\
 			______r = unlikely_notrace(x);			\
 			ftrace_likely_update(&______f, ______r, 0);	\
 			______r;					\
-- 
1.5.6.5

-- 
