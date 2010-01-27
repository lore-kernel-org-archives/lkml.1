Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209Ab0A0OJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0A0OJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174Ab0A0OJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:09:52 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49058 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755090Ab0A0OJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:09:40 -0500
Date: Wed, 27 Jan 2010 17:09:38 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Josh Boyer <jwboyer@gmail.com>,
       Stefani Seibold <stefani@seibold.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 3/3] kfifo: Don't use integer as NULL pointer
Message-ID: <20100127140938.GC31608@oksana.dev.rtsoft.ru>
References: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following sparse warnings:

include/linux/kfifo.h:127:25: warning: Using plain integer as NULL pointer
kernel/kfifo.c:83:21: warning: Using plain integer as NULL pointer

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 include/linux/kfifo.h |    2 +-
 kernel/kfifo.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 6f6c5f3..bc0fc79 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -124,7 +124,7 @@ extern __must_check unsigned int kfifo_out_peek(struct kfifo *fifo,
  */
 static inline bool kfifo_initialized(struct kfifo *fifo)
 {
-	return fifo->buffer != 0;
+	return fifo->buffer != NULL;
 }
 
 /**
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 3b00bf8..6d58e1a 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -80,7 +80,7 @@ int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask)
 
 	buffer = kmalloc(size, gfp_mask);
 	if (!buffer) {
-		_kfifo_init(fifo, 0, 0);
+		_kfifo_init(fifo, NULL, 0);
 		return -ENOMEM;
 	}
 
-- 
1.6.5.7
