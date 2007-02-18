Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbXBRVoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbXBRVoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 16:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXBRVoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 16:44:30 -0500
Received: from mail.screens.ru ([213.234.233.54]:56915 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXBRVoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 16:44:14 -0500
Date: Mon, 19 Feb 2007 00:44:15 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drivers/media/video/cpia_pp.c: don't use _WORK_NAR
Message-ID: <20070218214415.GA4232@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pp_cam_entry->cb_task need not to be _NOAUTOREL ... because in fact it is
never used ???

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- WQ/drivers/media/video/cpia_pp.c~3_cpia_pp	2006-12-17 19:06:40.000000000 +0300
+++ WQ/drivers/media/video/cpia_pp.c	2007-02-19 00:27:41.000000000 +0300
@@ -141,7 +141,6 @@ static void cpia_pp_run_callback(struct 
 	cam = container_of(work, struct pp_cam_entry, cb_task);
 	cb_func = cam->cb_func;
 	cb_data = cam->cb_data;
-	work_release(work);
 
 	cb_func(cb_data);
 }
@@ -682,7 +681,7 @@ static int cpia_pp_registerCallback(void
 	if(cam->port->irq != PARPORT_IRQ_NONE) {
 		cam->cb_func = cb;
 		cam->cb_data = cbdata;
-		INIT_WORK_NAR(&cam->cb_task, cpia_pp_run_callback);
+		INIT_WORK(&cam->cb_task, cpia_pp_run_callback);
 	} else {
 		retval = -1;
 	}

