Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZDRQaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZDRQaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 12:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZDRQ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 12:29:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:58219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbZDRQ3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 12:29:52 -0400
Date: Sat, 18 Apr 2009 16:28:24 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0904171717080.1016@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0904171717080.1016@gandalf.stny.rr.com>
Subject: [tip:tracing/core] tracing: remove format attribute of inline function
Message-ID: <tip-8e668b5b3455207e4540fc7ccab9ecf70142f288@git.kernel.org>
Git-Commit-ID: 8e668b5b3455207e4540fc7ccab9ecf70142f288
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Apr 2009 16:28:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e668b5b3455207e4540fc7ccab9ecf70142f288
Gitweb:     http://git.kernel.org/tip/8e668b5b3455207e4540fc7ccab9ecf70142f288
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Fri, 17 Apr 2009 17:17:55 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Apr 2009 09:49:10 +0200

tracing: remove format attribute of inline function

Due to a cut and paste error, I added the gcc attribute for printf
format to the static inline stub of trace_seq_printf.

This will cause a compile failure.

[ Impact: fix compiler error when CONFIG_TRACING is off ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
LKML-Reference: <alpine.DEB.2.00.0904171717080.1016@gandalf.stny.rr.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/trace_seq.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 15ca2c7..37db9bd 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -42,7 +42,6 @@ extern int trace_seq_path(struct trace_seq *s, struct path *path);
 
 #else /* CONFIG_TRACING */
 static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)))
 {
 	return 0;
 }
