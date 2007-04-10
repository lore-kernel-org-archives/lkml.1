Return-Path: <linux-kernel-owner+w=401wt.eu-S1030933AbXDJPzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030933AbXDJPzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030935AbXDJPzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:55:04 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:3834 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030933AbXDJPzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:55:02 -0400
Subject: [Patch] statistics: fix cpu hot unplug related memory leak
From: Martin Peschke <mp3@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Date: Tue, 10 Apr 2007 17:54:59 +0200
Message-Id: <1176220499.5572.19.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In case of CPU hotunplug statistics might have leaked some memory
(lists of struct statistic_entry_sparse, about 32 byte each, freed
by statistic_sparse_reset()).

Patch is against 2.6.21-rc6-mm1.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 statistic.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/lib/statistic.c
===================================================================
--- linux.orig/lib/statistic.c
+++ linux/lib/statistic.c
@@ -308,6 +308,7 @@ static int _statistic_hotcpu(struct stat
 		src = percpu_ptr(stat->data, cpu);
 		disc->merge(stat, dst, src);
 		local_irq_restore(flags);
+		disc->reset(stat, src);
 		percpu_depopulate(stat->data, cpu);
 		break;
 	}


