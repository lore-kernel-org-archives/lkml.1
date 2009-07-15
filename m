Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbZGOCNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbZGOCNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZGOCNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:13:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55953 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZGOCNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:13:18 -0400
Date: Tue, 14 Jul 2009 22:12:35 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rientjes@google.com, mel@csn.ul.ie, npiggin@suse.de
Subject: [PATCH -mm] copy over oom_adj value at fork time (v2)
Message-ID: <20090714221235.4a2383ea@bree.surriel.com>
In-Reply-To: <20090715104920.39A4.A69D9226@jp.fujitsu.com>
References: <20090714210557.0f983c37@bree.surriel.com>
	<6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
	<20090715104920.39A4.A69D9226@jp.fujitsu.com>
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
v2: test for current->mm before dereferencing it (Kosaki Motohiro)

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

Index: mmotm/kernel/fork.c
===================================================================
--- mmotm.orig/kernel/fork.c	2009-07-14 20:58:01.000000000 -0400
+++ mmotm/kernel/fork.c	2009-07-14 22:09:23.000000000 -0400
@@ -435,6 +435,7 @@ static struct mm_struct * mm_init(struct
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
+	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);

