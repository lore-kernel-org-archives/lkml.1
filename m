Return-Path: <linux-kernel-owner+w=401wt.eu-S937101AbXG0Lep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937101AbXG0Lep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934656AbXG0LdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:33:09 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49031 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246AbXG0LdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:33:07 -0400
Message-Id: <20070727113610.218646624@de.ibm.com>
References: <20070727113348.413110503@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jul 2007 13:33:52 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 4/6] cio: Make CIO_* macros safe if dbfs are not available.
Content-Disposition: inline; filename=013-cio-dbf.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/cio_debug.h |    2 ++
 1 file changed, 2 insertions(+)

Index: quilt-2.6/drivers/s390/cio/cio_debug.h
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/cio_debug.h
+++ quilt-2.6/drivers/s390/cio/cio_debug.h
@@ -23,6 +23,8 @@ extern debug_info_t *cio_debug_crw_id;
 static inline void
 CIO_HEX_EVENT(int level, void *data, int length)
 {
+	if (unlikely(!cio_debug_trace_id))
+		return;
 	while (length > 0) {
 		debug_event(cio_debug_trace_id, level, data, length);
 		length -= cio_debug_trace_id->buf_size;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

