Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZCWPVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZCWPVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbZCWPTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:19:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:48139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651AbZCWPTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:19:42 -0400
Date: Mon, 23 Mar 2009 15:19:04 GMT
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
References: <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
Subject: [tip:tracing/kmemtrace] kmemtrace: kmemtrace_alloc() must fill type_id
Message-ID: <tip-76825df5cfefce3c2b8d9768b058848930427e4e@git.kernel.org>
Git-Commit-ID: 76825df5cfefce3c2b8d9768b058848930427e4e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:19:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76825df5cfefce3c2b8d9768b058848930427e4e
Gitweb:     http://git.kernel.org/tip/76825df5cfefce3c2b8d9768b058848930427e4e
Author:     Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
AuthorDate: Mon, 23 Mar 2009 15:12:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:06:56 +0100

kmemtrace: kmemtrace_alloc() must fill type_id

Impact: fix trace output

kmemtrace_alloc() was not filling type_id, which allowed garbage to make
it into tracing data.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/kmemtrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 3316dc5..15f40f4 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -67,6 +67,7 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 	tracing_generic_entry_update(&entry->ent, 0, 0);
 
 	entry->ent.type = TRACE_KMEM_ALLOC;
+	entry->type_id = type_id;
 	entry->call_site = call_site;
 	entry->ptr = ptr;
 	entry->bytes_req = bytes_req;
