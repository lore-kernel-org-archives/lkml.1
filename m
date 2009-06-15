Return-Path: <linux-kernel-owner+w=401wt.eu-S1764871AbZFOSNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764871AbZFOSNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933353AbZFOSNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:13:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:42616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013AbZFOSNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:13:35 -0400
Date: Mon, 15 Jun 2009 18:13:02 GMT
From: tip-bot for Wu Zhangjin <wuzj@lemote.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, wuzj@lemote.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, wuzj@lemote.com
In-Reply-To: <1244962350-28702-1-git-send-email-wuzhangjin@gmail.com>
References: <1244962350-28702-1-git-send-email-wuzhangjin@gmail.com>
Subject: [tip:tracing/urgent] tracing: fix undeclared 'PAGE_SIZE' in include/linux/trace_seq.h
Message-ID: <tip-78be6914cb5c6d648617c51bb99bf81f28471d89@git.kernel.org>
Git-Commit-ID: 78be6914cb5c6d648617c51bb99bf81f28471d89
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 18:13:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78be6914cb5c6d648617c51bb99bf81f28471d89
Gitweb:     http://git.kernel.org/tip/78be6914cb5c6d648617c51bb99bf81f28471d89
Author:     Wu Zhangjin <wuzj@lemote.com>
AuthorDate: Sun, 14 Jun 2009 14:52:30 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 15 Jun 2009 11:37:09 -0400

tracing: fix undeclared 'PAGE_SIZE' in include/linux/trace_seq.h

when compiling linux-mips with kmemtrace enabled, there will be an
error:

include/linux/trace_seq.h:12: error: 'PAGE_SIZE' undeclared here (not in
				a function)

I checked the source code and found trace_seq.h used PAGE_SIZE but not
included the relative header file, so, fix it via adding the header file
<asm/page.h>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
LKML-Reference: <1244962350-28702-1-git-send-email-wuzhangjin@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 include/linux/trace_seq.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index c68bccb..c134dd1 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -3,6 +3,8 @@
 
 #include <linux/fs.h>
 
+#include <asm/page.h>
+
 /*
  * Trace sequences are used to allow a function to call several other functions
  * to create a string of data to use (up to a max of PAGE_SIZE.
