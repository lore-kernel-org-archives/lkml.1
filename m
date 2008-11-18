Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYKRVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYKRVby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYKRVbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:31:46 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:24975 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYKRVbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:31:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Ot3eiqosrRwwbs+xKj7xcszrfw28tLKHRke+++kiWVZG+RR4El6tgnkpq1hbMnYxV3
         aQ/cUqNOKT4KpiwoOyUDG3SlN9y2Jvso3BKyF+bvnawkkq9ZghoDpYjmjhx+h3Llhzx3
         wrybiZicMFtZUmub8Wu7sNHobxA+CXeuspSro=
Subject: [PATCH] kmemtrace: gfp_t is an unsigned int, not an unsigned long
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Eduard Munteanu <eduard.munteanu@linux360.ro>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 13:31:43 -0800
Message-Id: <1227043903.13182.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a bonus, gets rid of all the sparse warnings as you are casting a
restricted type (gfp_t) without __force.

include/linux/kmemtrace.h:33:2: warning: cast from restricted gfp_t

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kmemtrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
index 5bea8ea..80e9a7a 100644
--- a/include/linux/kmemtrace.h
+++ b/include/linux/kmemtrace.h
@@ -31,10 +31,10 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
 					     int node)
 {
 	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
-		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
+		   "bytes_req %lu bytes_alloc %lu gfp_flags %u node %d",
 		   type_id, call_site, (unsigned long) ptr,
 		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
-		   (unsigned long) gfp_flags, node);
+		   gfp_flags, node);
 }
 
 static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-- 
1.6.0.4.994.g16bd3e



