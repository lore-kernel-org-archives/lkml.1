Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbZEKK2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbZEKK2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZEKK2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:28:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:51610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZEKK2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:28:43 -0400
Date: Mon, 11 May 2009 10:27:30 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A07C6B3.9080802@cn.fujitsu.com>
References: <4A07C6B3.9080802@cn.fujitsu.com>
Subject: [tip:tracing/core] blktrace: pdu_buf of pc events should be unsigned
Message-ID: <tip-049862579333cc6cd9e6edfd6987cd0addfd8c59@git.kernel.org>
Git-Commit-ID: 049862579333cc6cd9e6edfd6987cd0addfd8c59
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 10:27:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  049862579333cc6cd9e6edfd6987cd0addfd8c59
Gitweb:     http://git.kernel.org/tip/049862579333cc6cd9e6edfd6987cd0addfd8c59
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 11 May 2009 14:33:23 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 12:25:50 +0200

blktrace: pdu_buf of pc events should be unsigned

I got this:
  8,0    1   305.417782332  2037  I   R 32 (ffffff9e 10 00 ...) [bash]

It should be:
  8,0    1   305.417782332  2037  I   R 32 (9e 10 00 ...) [bash]

[ Impact: fix output of pc events ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A07C6B3.9080802@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index e099f8c..05b4747 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1065,7 +1065,7 @@ static int blk_log_action(struct trace_iterator *iter, const char *act)
 
 static int blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
 {
-	const char *pdu_buf;
+	const unsigned char *pdu_buf;
 	int pdu_len;
 	int i, end, ret;
 
