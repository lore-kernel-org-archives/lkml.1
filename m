Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbYJ0JqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbYJ0JqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYJ0Jp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:45:56 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45059 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYJ0Jpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:45:55 -0400
Subject: [PATCH 3/3] xen-blkfront: set queue paravirt flag
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, jeremy@xensource.com
In-Reply-To: <1219814047.18991.52.camel@sebastian.kern.oss.ntt.co.jp>
References: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <20080826143900.GM20055@kernel.dk>
	 <1219814047.18991.52.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 27 Oct 2008 18:45:54 +0900
Message-Id: <1225100754.7370.81.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen's blkfront sets noop as the default I/O scheduler at initialization
time to avoid elevator overheads such as idling, but with the advent of
basic disk profiling capabilities this is not necessary anymore. We
should just tell the block layer that we are a paravirt front-end driver
and the elevator will automatically make the necessary adjustments.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.28-rc2-orig/drivers/block/xen-blkfront.c linux-2.6.28-rc2/drivers/block/xen-blkfront.c
--- linux-2.6.28-rc2-orig/drivers/block/xen-blkfront.c	2008-10-27 17:41:53.000000000 +0900
+++ linux-2.6.28-rc2/drivers/block/xen-blkfront.c	2008-10-27 17:38:59.000000000 +0900
@@ -343,7 +343,7 @@ static int xlvbd_init_blk_queue(struct g
 	if (rq == NULL)
 		return -1;
 
-	elevator_init(rq, "noop");
+	queue_flag_set_unlocked(QUEUE_FLAG_VIRT, rq);
 
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
 	blk_queue_hardsect_size(rq, sector_size);


