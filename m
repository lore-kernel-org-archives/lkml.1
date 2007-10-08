Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXJHMdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXJHMdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbXJHMdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:33:38 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47062 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbXJHMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:33:37 -0400
Message-id: <21044149499772302@pripojeni.net>
Subject: [PATCH 1/3] V4L: w9968cf, remove bad usage of ERESTARTSYS
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <luca.risolia@studio.unibo.it>
Cc: <mchehab@infradead.org>
Cc: <video4linux-list@redhat.com>
Date: Mon, 8 Oct 2007 08:33:37 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

w9968cf, remove bad usage of ERESTARTSYS

down_read_trylock can't be interrupted and so ERESTARTSYS would reach
userspace, which is not permitted. Change it to EAGAIN

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit db38c559d37219c32b179ae005ca7e489336ec94
tree f2d606165e6ef2daa6e1a2860f87521222eeecd2
parent 6e42c2183befe136d85e6a8708ee4eabc543774b
author Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:14:03 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:14:03 +0200

 drivers/media/video/w9968cf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/w9968cf.c b/drivers/media/video/w9968cf.c
index 77599f2..5a1b5f5 100644
--- a/drivers/media/video/w9968cf.c
+++ b/drivers/media/video/w9968cf.c
@@ -2679,7 +2679,7 @@ static int w9968cf_open(struct inode* inode, struct file* filp)
 
 	/* This the only safe way to prevent race conditions with disconnect */
 	if (!down_read_trylock(&w9968cf_disconnect))
-		return -ERESTARTSYS;
+		return -EAGAIN;
 
 	cam = (struct w9968cf_device*)video_get_drvdata(video_devdata(filp));
 
