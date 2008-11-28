Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbYK1JSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbYK1JSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYK1JSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:18:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:17330 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYK1JSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=vExlFhdLVWuXpHzdcnPh1xIf/9LjFJS+pWD+RKZ7D7iPHn/IEgsgmSIMI7U0zlvcjs
         RWxxvkZgUo03gz19wwhs+jHEA4haLJ5cU4m2b+x+RKYfXJwAx84yLmoK/4/Aex9IX7uc
         5azDyLOys8/55zEZFkwe9/RensiIYAT9iSk2M=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: adobriyan@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH] fix build: add missing #ifdef CONFIG_STACKTRACE
Date: Fri, 28 Nov 2008 11:17:56 +0200
Message-Id: <1227863876-22747-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <c62985530811280114s50abe288q255a185b6d64c81b@mail.gmail.com>
References: <c62985530811280114s50abe288q255a185b6d64c81b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 kernel/trace/trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5811e0a..91887a2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -983,6 +983,7 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long flags, int pc)
 {
+#ifdef CONFIG_STACKTRACE
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
 	struct stack_trace trace;
@@ -1008,6 +1009,7 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 
 	save_stack_trace_user(&trace);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+#endif
 }
 
 void __trace_userstack(struct trace_array *tr,
-- 
1.5.6.5

