Return-Path: <linux-kernel-owner+w=401wt.eu-S965630AbXAXC4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965630AbXAXC4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXAXC4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:56:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45026 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbXAXC4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:56:43 -0500
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: V4L-DVB Maintainers <v4l-dvb-maintainer@linuxtv.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/1] V4L/DVB (5123): Buf_qbuf: fix: videobuf_queue->stream
	corruption and lockup
Date: Wed, 24 Jan 2007 00:54:05 -0200
Message-id: <20070124025405.PS0573700001@infradead.org>
In-Reply-To: <20070124024701.PS2866700000@infradead.org>
References: <20070124024701.PS2866700000@infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Oleg Nesterov <oleg@tv-sign.ru>

We are doing ->buf_prepare(buf) before adding buf to q->stream list. This
means that videobuf_qbuf() should not try to re-add a STATE_PREPARED buffer.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
---

 drivers/media/video/video-buf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/video-buf.c b/drivers/media/video/video-buf.c
index 635d102..6504a58 100644
--- a/drivers/media/video/video-buf.c
+++ b/drivers/media/video/video-buf.c
@@ -700,6 +700,7 @@ videobuf_qbuf(struct videobuf_queue *q,
 		goto done;
 	}
 	if (buf->state == STATE_QUEUED ||
+	    buf->state == STATE_PREPARED ||
 	    buf->state == STATE_ACTIVE) {
 		dprintk(1,"qbuf: buffer is already queued or active.\n");
 		goto done;

