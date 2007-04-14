Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXDNImK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXDNImK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXDNImK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:42:10 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:33848 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbXDNImJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:42:09 -0400
Subject: [Patch] statistics: fix sorted list
From: Martin Peschke <mp3@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Date: Sat, 14 Apr 2007 10:42:05 +0200
Message-Id: <1176540125.5462.13.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The list of statistics entries maintained by type 'sparse' might have
shown unsorted entries with regard to the number of reported hits. The
reason was that new entries were always added at the tail of the list
regardless of the number of hits they came with. Unsorted lists might
suffer a performance loss.

Fix is to sort the list by hits after entry insertion, i.e. moving
entries added at the tail up the chain, which should not be required
very often (usually just when merging per-cpu lists).

Patch is against 2.6.21-rc6-mm1.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 statistic.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/lib/statistic.c
===================================================================
--- linux.orig/lib/statistic.c
+++ linux/lib/statistic.c
@@ -1113,6 +1113,7 @@ static int statistic_add_sparse_new(stru
 	entry->hits = incr;
 	slist->entries++;
 	list_add_tail(&entry->list, &slist->entry_lh);
+	statistic_sort_sparse(&slist->entry_lh, entry);
 	return 0;
 }
 


