Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbZDIIz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbZDIIz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbZDIIyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:54:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:34731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbZDIIyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:54:22 -0400
Message-Id: <20090409085524.338620360@chello.nl>
References: <20090409085342.799915215@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 10:53:43 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] perf_counter: fix off-by-one on the string lengths
Content-Disposition: inline; filename=perf_counter-fix-strings.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strlen() does _not_ include the terminating \0.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1989,7 +1989,7 @@ static void perf_counter_comm_event(stru
 	unsigned int size;
 	char *comm = comm_event->task->comm;
 
-	size = ALIGN(strlen(comm), sizeof(u64));
+	size = ALIGN(strlen(comm)+1, sizeof(u64));
 
 	comm_event->comm = comm;
 	comm_event->comm_size = size;
@@ -2109,7 +2109,7 @@ static void perf_counter_mmap_event(stru
 	}
 
 got_name:
-	size = ALIGN(strlen(name), sizeof(u64));
+	size = ALIGN(strlen(name)+1, sizeof(u64));
 
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;

-- 

