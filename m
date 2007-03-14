Return-Path: <linux-kernel-owner+w=401wt.eu-S1030695AbXCNJEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030695AbXCNJEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030698AbXCNJEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:04:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57602 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030695AbXCNJEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:04:42 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 3/13] appldata build fix
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPPV-0001rc-OR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:04:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


PGALLOC_DMA is defined only if we have CONFIG_ZONE_DMA

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/appldata/appldata_mem.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/s390/appldata/appldata_mem.c b/arch/s390/appldata/appldata_mem.c
index 4ca6157..697eb30 100644
--- a/arch/s390/appldata/appldata_mem.c
+++ b/arch/s390/appldata/appldata_mem.c
@@ -117,7 +117,10 @@ static void appldata_get_mem_data(void *data)
 	mem_data->pgpgout    = ev[PGPGOUT] >> 1;
 	mem_data->pswpin     = ev[PSWPIN];
 	mem_data->pswpout    = ev[PSWPOUT];
-	mem_data->pgalloc    = ev[PGALLOC_NORMAL] + ev[PGALLOC_DMA];
+	mem_data->pgalloc    = ev[PGALLOC_NORMAL];
+#ifdef CONFIG_ZONE_DMA
+	mem_data->pgalloc    += ev[PGALLOC_DMA];
+#endif
 	mem_data->pgfault    = ev[PGFAULT];
 	mem_data->pgmajfault = ev[PGMAJFAULT];
 
-- 
1.5.0-rc2.GIT


