Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbZLKK6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbZLKK6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760928AbZLKK6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:58:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62763 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbZLKK6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:58:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tWZ8fHT4syNQ0Semxy2yrI/PHgRKjwi0ruJw+krKRmo/lKHFO6gp/PA767EVk7l3Mr
         lG6oVJY1kW/4WiOqD3TSILYRSoatCIDmylfEX09MQoW/Y8aEOYOS7aecwfOLoiyj/3JI
         NWu4i5AUbIV0ORN0UsJlwxzw1Tjzj+EMLvgiE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH] hw-breakpoints: Handle bad modify_user_hw_breakpoint off-case return value
Date: Fri, 11 Dec 2009 11:58:42 +0100
Message-Id: <1260529122-6260-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20091211153828.6ba80bc4.sfr@canb.auug.org.au>
References: <20091211153828.6ba80bc4.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While converting modify_user_hw_breakpoint() return value, we forgot
to handle the off-case. It's not returning a pointer anymore.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 69f07a9..41235c9 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -93,7 +93,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    struct task_struct *tsk)	{ return NULL; }
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr)	{ return NULL; }
+			  struct perf_event_attr *attr)	{ return -ENOSYS; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,
-- 
1.6.2.3

