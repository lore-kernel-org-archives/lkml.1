Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYJ0Jo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYJ0Jo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYJ0Jos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:44:48 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:44986 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYJ0Jor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:44:47 -0400
Subject: [PATCH 1/3] block: add queue flag for paravirt frontend drivers
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
Date: Mon, 27 Oct 2008 18:44:46 +0900
Message-Id: <1225100686.7370.79.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As is the case with SSD devices, we do not want to idle in AS/CFQ when
the block device is a paravirt front-end driver. This patch adds a flag
(QUEUE_FLAG_VIRT) which should be used by front-end drivers such as
virtio_blk and xen-blkfront to indicate a paravirtualized device.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.28-rc2-orig/include/linux/blkdev.h linux-2.6.28-rc2/include/linux/blkdev.h
--- linux-2.6.28-rc2-orig/include/linux/blkdev.h	2008-10-27 17:41:58.000000000 +0900
+++ linux-2.6.28-rc2/include/linux/blkdev.h	2008-10-27 17:34:49.000000000 +0900
@@ -449,6 +449,7 @@ struct request_queue
 #define QUEUE_FLAG_FAIL_IO     12	/* fake timeout */
 #define QUEUE_FLAG_STACKABLE   13	/* supports request stacking */
 #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
+#define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 
 static inline int queue_is_locked(struct request_queue *q)
 {


