Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbZDCKjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbZDCKjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763957AbZDCKhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:37:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:42952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763930AbZDCKhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:37:38 -0400
Date: Fri, 3 Apr 2009 10:36:56 GMT
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
References: <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
Subject: [tip:tracing/kmemtrace-v2] kmemtrace: kmemtrace_alloc() must fill type_id
Message-ID: <tip-da2635a9854423b4aa3a5f0e4e6efcc39ac99004@git.kernel.org>
Git-Commit-ID: da2635a9854423b4aa3a5f0e4e6efcc39ac99004
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:36:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da2635a9854423b4aa3a5f0e4e6efcc39ac99004
Gitweb:     http://git.kernel.org/tip/da2635a9854423b4aa3a5f0e4e6efcc39ac99004
Author:     Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
AuthorDate: Mon, 23 Mar 2009 15:12:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:23:07 +0200

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
index 4f7b5db..ae259f0 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -52,6 +52,7 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 	tracing_generic_entry_update(&entry->ent, 0, 0);
 
 	entry->ent.type = TRACE_KMEM_ALLOC;
+	entry->type_id = type_id;
 	entry->call_site = call_site;
 	entry->ptr = ptr;
 	entry->bytes_req = bytes_req;
