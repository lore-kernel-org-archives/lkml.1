Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZLNODt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZLNODt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbZLNODs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:03:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbZLNODr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:03:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix no-hardware-breakpoint case
To: torvalds@osdl.org, akpm@linux-foundation.org, fweisbec@gmail.com
Cc: dhowells@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Mon, 14 Dec 2009 14:03:27 +0000
Message-ID: <20091214140326.11689.80251.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is no hardware breakpoint support, modify_user_hw_breakpoint() tries
to return a NULL pointer through as an 'int' return value:

In file included from kernel/exit.c:53:
include/linux/hw_breakpoint.h: In function 'modify_user_hw_breakpoint':
include/linux/hw_breakpoint.h:96: warning: return makes integer from pointer without a cast

Return 0 instead.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/hw_breakpoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 69f07a9..e268388 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -93,7 +93,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    struct task_struct *tsk)	{ return NULL; }
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr)	{ return NULL; }
+			  struct perf_event_attr *attr)	{ return 0; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,

