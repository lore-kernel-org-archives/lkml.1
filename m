Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZK3JNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZK3JNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZK3JNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:13:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbZK3JNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:13:08 -0500
Date: Mon, 30 Nov 2009 04:12:02 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20091130091501.4507.28683.sendpatchset@localhost.localdomain>
Subject: [Patch] percpu: remove two suspicious break statements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two break statements seem to be very suspicious,
they are at the end of the statements inside the loop.
Remove them.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Tejun Heo <tj@kernel.org>

---
diff --git a/mm/percpu.c b/mm/percpu.c
index 5adfc26..dbcfee8 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -917,7 +917,6 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
 		if (rs == page_start && re == page_end)
 			return;
-		break;
 	}
 
 	/* immutable chunks can't be depopulated */
@@ -972,7 +971,6 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end) {
 		if (rs == page_start && re == page_end)
 			goto clear;
-		break;
 	}
 
 	/* need to allocate and map pages, this chunk can't be immutable */
