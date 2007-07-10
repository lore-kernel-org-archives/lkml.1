Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbXGJJ2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbXGJJ2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760827AbXGJJ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:28:32 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:47424 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbXGJJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:28:31 -0400
Message-Id: <20070710093041.472843538@de.ibm.com>
References: <20070710092935.896013926@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 11:29:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 01/16] vmcp cleanup
Content-Disposition: inline; filename=001-vmcp-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@mindspring.com>

No need to use the "&" prefix and, since you're calling nonseekable_open(),
there is no need to use no_llseek().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmcp.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: quilt-2.6/drivers/s390/char/vmcp.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmcp.c
+++ quilt-2.6/drivers/s390/char/vmcp.c
@@ -175,13 +175,12 @@ static long vmcp_ioctl(struct file *file
 
 static const struct file_operations vmcp_fops = {
 	.owner		= THIS_MODULE,
-	.open		= &vmcp_open,
-	.release	= &vmcp_release,
-	.read		= &vmcp_read,
-	.llseek		= &no_llseek,
-	.write		= &vmcp_write,
-	.unlocked_ioctl	= &vmcp_ioctl,
-	.compat_ioctl	= &vmcp_ioctl
+	.open		= vmcp_open,
+	.release	= vmcp_release,
+	.read		= vmcp_read,
+	.write		= vmcp_write,
+	.unlocked_ioctl	= vmcp_ioctl,
+	.compat_ioctl	= vmcp_ioctl
 };
 
 static struct miscdevice vmcp_dev = {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

