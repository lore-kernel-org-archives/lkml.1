Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZG3Vty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZG3Vty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZG3Vtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:49:53 -0400
Received: from server1.wserver.cz ([82.113.45.157]:33921 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZG3Vtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:49:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH repost2 2/2] V4L: saa7134, fix lock imbalance
Date: Thu, 30 Jul 2009 23:49:49 +0200
Message-Id: <1248990589-25005-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248990589-25005-1-git-send-email-jirislaby@gmail.com>
References: <1248990589-25005-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one superfluos (imbalanced) unlock in a poll
function. Remove it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/media/video/saa7134/saa7134-video.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 58854df..da26f47 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1444,7 +1444,6 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 			fh->cap.ops->buf_queue(&fh->cap,fh->cap.read_buf);
 			fh->cap.read_off = 0;
 		}
-		mutex_unlock(&fh->cap.vb_lock);
 		buf = fh->cap.read_buf;
 	}
 
-- 
1.6.3.3

