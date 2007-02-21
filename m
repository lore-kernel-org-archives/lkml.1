Return-Path: <linux-kernel-owner+w=401wt.eu-S1751050AbXBUBir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbXBUBir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXBUBir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:38:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:42216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbXBUBiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:38:25 -0500
Date: Tue, 20 Feb 2007 17:37:03 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 05/21] V4L: buf_qbuf: fix videobuf_queue->stream corruption and lockup
Message-ID: <20070221013703.GF30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="V4L-buf_qbuf-fix-videobuf_queue-stream-corruption-and-lockup.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
We are doing ->buf_prepare(buf) before adding buf to q->stream list. This
means that videobuf_qbuf() should not try to re-add a STATE_PREPARED buffer.

(cherry picked from commit 419dd8378dfa32985672ab7927b4bc827f33b332)

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/video-buf.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.19.4.orig/drivers/media/video/video-buf.c
+++ linux-2.6.19.4/drivers/media/video/video-buf.c
@@ -700,6 +700,7 @@ videobuf_qbuf(struct videobuf_queue *q,
 		goto done;
 	}
 	if (buf->state == STATE_QUEUED ||
+	    buf->state == STATE_PREPARED ||
 	    buf->state == STATE_ACTIVE) {
 		dprintk(1,"qbuf: buffer is already queued or active.\n");
 		goto done;

--
