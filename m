Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbZHRQoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbZHRQoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbZHRQoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:44:03 -0400
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:38617 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759325AbZHRQoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:44:02 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] aio.c: move EXPORT* macros to line after function
Date: Tue, 18 Aug 2009 12:44:00 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901BEA23B@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio.c: move EXPORT* macros to line after function
Thread-Index: AcogIxYcthgj37CjS7ydAJ2ZMvYRaA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-aio@kvack.org>, <linux-fsdevel@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Aug 2009 16:44:01.0146 (UTC) FILETIME=[16C565A0:01CA2023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in Documentation/CodingStyle, move EXPORT* macro's
to the line immediately after the closing function brace line.

Also, move the __initcall() similarly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/fs/aio.c b/fs/aio.c
index d065b2c..0892729 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -78,6 +78,7 @@ static int __init aio_setup(void)
 
 	return 0;
 }
+__initcall(aio_setup);
 
 static void aio_free_ring(struct kioctx *ctx)
 {
@@ -380,6 +381,7 @@ ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
 	__set_current_state(TASK_RUNNING);
 	return iocb->ki_user_data;
 }
+EXPORT_SYMBOL(wait_on_sync_kiocb);
 
 /* exit_aio: called when the last user of mm goes away.  At this point, 
  * there is no way for any new requests to be submited or any of the 
@@ -573,6 +575,7 @@ int aio_put_req(struct kiocb *req)
 	spin_unlock_irq(&ctx->ctx_lock);
 	return ret;
 }
+EXPORT_SYMBOL(aio_put_req);
 
 static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
@@ -1037,6 +1040,7 @@ put_rq:
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(aio_complete);
 
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
@@ -1825,9 +1829,3 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 	asmlinkage_protect(5, ret, ctx_id, min_nr, nr, events, timeout);
 	return ret;
 }
-
-__initcall(aio_setup);
-
-EXPORT_SYMBOL(aio_complete);
-EXPORT_SYMBOL(aio_put_req);
-EXPORT_SYMBOL(wait_on_sync_kiocb); 
