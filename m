Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZKWOmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZKWOmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZKWOmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:42:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:22984 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbZKWOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:42:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OzH92MrhwZXzDm+uWDUa9lt0mk9g5wATatzhTZUZH22uSeos6yUTayIJIQvxsOk6YS
         D6bxPaeX9ARPq33Wjnuj4v2Xw4PcDbkGqdZ+FygO9PfFOd2qbgpzUVoltpEpK3+ZbkA3
         qSA+B48ysNsylo9xHtHh/sfi6j0GN0zrOkTTw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 1/4] hw-breakpoints: Include only linux/perf_event.h from kernel part of bp headers
Date: Mon, 23 Nov 2009 15:42:32 +0100
Message-Id: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As userspace only needs the breakpoints enum types from the breakpoints
headers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 4659e0c..76a48ab 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_HW_BREAKPOINT_H
 #define _LINUX_HW_BREAKPOINT_H
 
-#include <linux/perf_event.h>
-
 enum {
 	HW_BREAKPOINT_LEN_1 = 1,
 	HW_BREAKPOINT_LEN_2 = 2,
@@ -19,6 +17,8 @@ enum {
 #ifdef __KERNEL__
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
+#include <linux/perf_event.h>
+
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
-- 
1.6.2.3

