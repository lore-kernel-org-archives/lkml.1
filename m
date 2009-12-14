Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZLNJYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZLNJYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZLNJYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:24:17 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:35155 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZLNJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:24:15 -0500
Date: Mon, 14 Dec 2009 10:24:12 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hw-breakpoints: let modify_user_hw_breakpoint return an int
Message-ID: <20091214092412.GA5242@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Let modify_user_hw_breakpoint return an int to avoid hundreds of compile
warnings like this one:

include/linux/hw_breakpoint.h: In function 'modify_user_hw_breakpoint':
include/linux/hw_breakpoint.h:96: warning: return makes integer from pointer without a cast

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/hw_breakpoint.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/hw_breakpoint.h
===================================================================
--- linux-2.6.orig/include/linux/hw_breakpoint.h
+++ linux-2.6/include/linux/hw_breakpoint.h
@@ -93,7 +93,7 @@ register_user_hw_breakpoint(struct perf_
 			    struct task_struct *tsk)	{ return NULL; }
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr)	{ return NULL; }
+			  struct perf_event_attr *attr)	{ return 0; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,
