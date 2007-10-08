Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbXJHMes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbXJHMes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbXJHMeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:34:15 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47075 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754304AbXJHMeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:34:14 -0400
Message-id: <11237258561195029635@pripojeni.net>
In-reply-to: <21044149499772302@pripojeni.net>
Subject: [PATCH 2/3] V4L: zc0301, remove bad usage of ERESTARTSYS
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <luca.risolia@studio.unibo.it>
Cc: <linux-usb-devel@lists.sourceforge.net>
Cc: <mchehab@infradead.org>
Cc: <video4linux-list@redhat.com>
Date: Mon, 8 Oct 2007 08:34:14 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

zc0301, remove bad usage of ERESTARTSYS

down_read_trylock can't be interrupted and so ERESTARTSYS would reach
userspace, which is not permitted. Change it to EAGAIN

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 235cf594bc65128250632a642f3e9d7e4df4975e
tree 0557746416827daeb4d829610fec2f0c9111a675
parent db38c559d37219c32b179ae005ca7e489336ec94
author Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:15:47 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:15:47 +0200

 drivers/media/video/zc0301/zc0301_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/zc0301/zc0301_core.c b/drivers/media/video/zc0301/zc0301_core.c
index 35138c5..08a93c3 100644
--- a/drivers/media/video/zc0301/zc0301_core.c
+++ b/drivers/media/video/zc0301/zc0301_core.c
@@ -655,7 +655,7 @@ static int zc0301_open(struct inode* inode, struct file* filp)
 	int err = 0;
 
 	if (!down_read_trylock(&zc0301_dev_lock))
-		return -ERESTARTSYS;
+		return -EAGAIN;
 
 	cam = video_get_drvdata(video_devdata(filp));
 
