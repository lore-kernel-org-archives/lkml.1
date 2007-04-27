Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbXD0OMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbXD0OMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbXD0OG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:06:56 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:21541 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbXD0OFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:05:00 -0400
Message-Id: <20070427140518.672178916@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Ursula Braun <braunu@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 29/38] vmlogrdr: stop IUCV connection in vmlogrdr_release.
Content-Disposition: inline; filename=132-vmlogrdr-iucv.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ursula Braun <braunu@de.ibm.com>

Reopen of /dev/account failed. The IUCV path has to be terminated
in vmlogrdr_release.

Signed-off-by: Ursula Braun <braunu@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmlogrdr.c |    3 +++
 1 files changed, 3 insertions(+)

Index: quilt-2.6/drivers/s390/char/vmlogrdr.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmlogrdr.c	2007-04-27 16:01:49.000000000 +0200
+++ quilt-2.6/drivers/s390/char/vmlogrdr.c	2007-04-27 16:04:59.000000000 +0200
@@ -385,6 +385,9 @@
 
 	struct vmlogrdr_priv_t * logptr = filp->private_data;
 
+	iucv_path_sever(logptr->path, NULL);
+	kfree(logptr->path);
+	logptr->path = NULL;
 	if (logptr->autorecording) {
 		ret = vmlogrdr_recording(logptr,0,logptr->autopurge);
 		if (ret)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

