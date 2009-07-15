Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZGOBGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZGOBGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 21:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZGOBGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 21:06:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813AbZGOBGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 21:06:38 -0400
Date: Tue, 14 Jul 2009 21:05:57 -0400
From: Rik van Riel <riel@redhat.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rientjes@google.com, mel@csn.ul.ie, npiggin@suse.de
Subject: [PATCH] copy over oom_adj value at fork time
Message-ID: <20090714210557.0f983c37@bree.surriel.com>
In-Reply-To: <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org>
	<6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After moving the oom_adj value from the task struct to the
mm_struct, the oom_adj value was no longer properly inherited
by child processes.

Copying over the oom_adj value at fork time fixes that bug.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Paul Menage <manage@google.com>
---
Paul, does this fix your bug?

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

Index: mmotm/kernel/fork.c
===================================================================
--- mmotm.orig/kernel/fork.c	2009-07-14 20:58:01.000000000 -0400
+++ mmotm/kernel/fork.c	2009-07-14 21:00:40.000000000 -0400
@@ -435,6 +435,7 @@ static struct mm_struct * mm_init(struct
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
+	mm->oom_adj = current->mm->oom_adj;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
