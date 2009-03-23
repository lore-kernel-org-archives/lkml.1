Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbZCWNNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbZCWNNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZCWNMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:12:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:46849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZCWNMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=JY+gtbIlImB9+hi3u8T4273IJxZd/VjAjTB469jwH+QobdwniqmaUJydixLCBh7t+y
         c8P580gIiKzYOc8tREXJ0gbnrp5dSmdPgJg5XHUDIWM5IMoVHhFey21e8wG6Dkeovz/8
         4PZ5K9Zr++4q65o4jXyJSmFcQFrwgvkH6qPvU=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] kmemtrace: kmemtrace_alloc() must fill type_id
Date: Mon, 23 Mar 2009 15:12:25 +0200
Message-Id: <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <ae61c0f37156db8ec8dc0d5778018edde60a92e3.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
 <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
 <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
 <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
 <ae61c0f37156db8ec8dc0d5778018edde60a92e3.1237813499.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemtrace_alloc() was not filling type_id, which allowed garbage to make
it into tracing data.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/kmemtrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 9e9327e..6f3cb4c 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -69,6 +69,7 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 	tracing_generic_entry_update(&entry->ent, 0, 0);
 
 	entry->ent.type = TRACE_KMEM_ALLOC;
+	entry->type_id = type_id;
 	entry->call_site = call_site;
 	entry->ptr = ptr;
 	entry->bytes_req = bytes_req;
-- 
1.6.0.6

