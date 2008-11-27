Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYK0Kh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYK0Kh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYK0Kcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:32:42 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:47248 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYK0KcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:20 -0500
Message-Id: <20081127103131.105079847@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:32 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/60] qdio: fix compile warning under 31 bit
Content-Disposition: inline; filename=111-qdio-warning.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jang@linux.vnet.ibm.com>

The QEBSM instructions are only available for CONFIG_64BIT, they are not
used under 31 bit. Make compiler happy about the false positive:

drivers/s390/cio/qdio_main.c: In function ?qdio_inbound_q_done?:
drivers/s390/cio/qdio_main.c:532: warning: ?state? may be used uninitialized in this function

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio_main.c    |    2 +-
 drivers/s390/cio/qdio_thinint.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/cio/qdio_main.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio_main.c
+++ quilt-2.6/drivers/s390/cio/qdio_main.c
@@ -529,7 +529,7 @@ int qdio_inbound_q_moved(struct qdio_q *
 
 static int qdio_inbound_q_done(struct qdio_q *q)
 {
-	unsigned char state;
+	unsigned char state = 0;
 #ifdef CONFIG_QDIO_DEBUG
 	char dbf_text[15];
 #endif
Index: quilt-2.6/drivers/s390/cio/qdio_thinint.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio_thinint.c
+++ quilt-2.6/drivers/s390/cio/qdio_thinint.c
@@ -125,7 +125,7 @@ void tiqdio_remove_input_queues(struct q
 
 static inline int tiqdio_inbound_q_done(struct qdio_q *q)
 {
-	unsigned char state;
+	unsigned char state = 0;
 
 	if (!atomic_read(&q->nr_buf_used))
 		return 1;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

