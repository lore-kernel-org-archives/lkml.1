Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYJ0Jpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYJ0Jpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYJ0JpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:45:20 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45042 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYJ0JpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:45:18 -0400
Subject: [PATCH 2/3] virtio_blk: set queue paravirt flag
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
Date: Mon, 27 Oct 2008 18:45:15 +0900
Message-Id: <1225100715.7370.80.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a paravirt front-end driver, virtio_blk is not a rotational device so
we want do avoid idling in AS/CFQ. Tell the block layer about this.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.28-rc2-orig/drivers/block/virtio_blk.c linux-2.6.28-rc2/drivers/block/virtio_blk.c
--- linux-2.6.28-rc2-orig/drivers/block/virtio_blk.c	2008-10-27 17:41:53.000000000 +0900
+++ linux-2.6.28-rc2/drivers/block/virtio_blk.c	2008-10-27 17:34:32.000000000 +0900
@@ -237,6 +237,8 @@ static int virtblk_probe(struct virtio_d
 		goto out_put_disk;
 	}
 
+	queue_flag_set_unlocked(QUEUE_FLAG_VIRT, vblk->disk->queue);
+
 	if (index < 26) {
 		sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
 	} else if (index < (26 + 1) * 26) {


