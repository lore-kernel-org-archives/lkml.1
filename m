Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYHSRrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYHSRrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYHSRqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:46:48 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:44207 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbYHSRqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=A3OusxUuiAKNA4ikTECz97pdzhz4D8u8iablSwrcoZRwVNXwM4g3AHKz7JtzD8Wd0V
         oE78WHOqQQ9F8zFNQ8BkHy9w4TnI6CZVzIjShP4p6Nak3o9mbbInDdtTkKmYrUCVmU8g
         kXwr0nE/d8tJ0jlEzM4tACXL7NLBaYvwBnVUQ=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
Date: Tue, 19 Aug 2008 20:43:23 +0300
Message-Id: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 79cf3d5e207243eecb1c4331c569e17700fa08fa.

The reverted commit, while it fixed printk format warnings, it resulted in
marker-probe format mismatches. Another approach should be used to fix
these warnings.
---
 include/linux/kmemtrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
index a865064..2c33201 100644
--- a/include/linux/kmemtrace.h
+++ b/include/linux/kmemtrace.h
@@ -31,7 +31,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
 					     int node)
 {
 	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
-		   "bytes_req %zu bytes_alloc %zu gfp_flags %lu node %d",
+		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
 		   type_id, call_site, (unsigned long) ptr,
 		   bytes_req, bytes_alloc, (unsigned long) gfp_flags, node);
 }
-- 
1.5.6.1

