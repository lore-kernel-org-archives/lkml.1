Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZKVEV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZKVEV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 23:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZKVEVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 23:21:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42536 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbZKVEVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 23:21:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BUZwTBD6WFLs3He+yfLaVVSxt+k9qNQ+MOzEo0DapHdO4/FdEzvC6yP5N/8uPRKAwt
         sgHH9o7ghrVEj0P+fwUm6wLJ0zlthUXIj3E0vYHFdJopVKD8wH2SdsbAgGFhhLsGLdRm
         ZscoLTM23TXQRF3ZCPofHhV1ULPniXntW8vUI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 4/4] hw-breakpoints: Separate the kernel part from breakpoint headers
Date: Sun, 22 Nov 2009 05:21:35 +0100
Message-Id: <1258863695-10464-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
References: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we can include this header from userspace tools, like
perf tools, to get the breakpoint types and len definitions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 0b98cbf..4659e0c 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -16,6 +16,7 @@ enum {
 	HW_BREAKPOINT_X = 4,
 };
 
+#ifdef __KERNEL__
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
@@ -133,5 +134,6 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 }
 
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* __KERNEL__ */
 
 #endif /* _LINUX_HW_BREAKPOINT_H */
-- 
1.6.2.3

