Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbXKDS1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbXKDS1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXKDS07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:26:59 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:55389 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbXKDS06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:26:58 -0500
Date: Sun, 4 Nov 2007 22:32:21 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Nick <gentuu@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cfq: fix IOPRIO_CLASS_IDLE accounting
Message-ID: <20071104193221.GA12373@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(untested, needs an ack from maintainer)

Spotted by Nick <gentuu@gmail.com>, hopefully can explain the second trace in
http://bugzilla.kernel.org/show_bug.cgi?id=9180.

If ->async_idle_cfqq != NULL cfq_put_async_queues() puts it IOPRIO_BE_NR times
in a loop. Fix this.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- cfq/block/cfq-iosched.c~	2007-08-09 19:59:26.000000000 +0400
+++ cfq/block/cfq-iosched.c	2007-11-04 22:23:42.000000000 +0300
@@ -2065,9 +2065,10 @@ static void cfq_put_async_queues(struct 
 			cfq_put_queue(cfqd->async_cfqq[0][i]);
 		if (cfqd->async_cfqq[1][i])
 			cfq_put_queue(cfqd->async_cfqq[1][i]);
-		if (cfqd->async_idle_cfqq)
-			cfq_put_queue(cfqd->async_idle_cfqq);
 	}
+
+	if (cfqd->async_idle_cfqq)
+		cfq_put_queue(cfqd->async_idle_cfqq);
 }
 
 static void cfq_exit_queue(elevator_t *e)

