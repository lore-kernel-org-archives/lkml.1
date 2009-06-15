Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbZFOPon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbZFOPon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbZFOPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:44:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZFOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:09 -0400
Message-Id: <20090615154410.762557673@goodmis.org>
References: <20090615154226.058101204@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 11:42:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Wu Zhangjin <wuzj@lemote.com>
Subject: [PATCH 2/7] tracing: fix undeclared PAGE_SIZE in include/linux/trace_seq.h
Content-Disposition: inline; filename=0002-tracing-fix-undeclared-PAGE_SIZE-in-include-linux-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

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
-- 
1.6.3.1

-- 
