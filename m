Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZHMGJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZHMGJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZHMGJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:09:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58020 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbZHMGJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:09:05 -0400
Date: Thu, 13 Aug 2009 02:00:13 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, akpm@linux-foundation.org,
       mingo@elte.hu, Amerigo Wang <amwang@redhat.com>
Message-Id: <20090813060235.5516.12662.sendpatchset@localhost.localdomain>
Subject: [Patch] percpu: use the right flag for get_vm_area()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


get_vm_area() only accepts VM_* flags, not GFP_*.

And according to the doc of get_vm_area(), here should be
VM_ALLOC.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>

---
diff --git a/mm/percpu.c b/mm/percpu.c
index b70f2ac..3ef18c7 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -749,7 +749,7 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 	chunk->map[chunk->map_used++] = pcpu_unit_size;
 	chunk->page = chunk->page_ar;
 
-	chunk->vm = get_vm_area(pcpu_chunk_size, GFP_KERNEL);
+	chunk->vm = get_vm_area(pcpu_chunk_size, VM_ALLOC);
 	if (!chunk->vm) {
 		free_pcpu_chunk(chunk);
 		return NULL;
