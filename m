Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYHZMsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYHZMsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYHZMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:48:16 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53968 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYHZMsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:48:16 -0400
Subject: [PATCH] virtio_blk: use noop elevator by default
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Tue, 26 Aug 2008 21:48:14 +0900
Message-Id: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Would it make sense to use noop by default? After all we do not know
what is behind the backend driver and the hypervisor is likely to do its
own scheduling anyway. I guess this is the reason the Xen guys took this
approach.

What do you think about the patch below?

- Fernando

---

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Subject: [PATCH] virtio_blk: use noop elevator by default

Using the noop elevator by default seems to be safest bet because we do
not know what is behind the backend driver and the hypervisor is likely
to do its own scheduling anyway.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.27-rc4/drivers/block/virtio_blk.c linux-2.6.27-rc4-fixes/drivers/block/virtio_blk.c
--- linux-2.6.27-rc4/drivers/block/virtio_blk.c	2008-08-26 21:26:01.000000000 +0900
+++ linux-2.6.27-rc4-fixes/drivers/block/virtio_blk.c	2008-08-26 21:22:03.000000000 +0900
@@ -237,6 +237,8 @@ static int virtblk_probe(struct virtio_d
 		goto out_put_disk;
 	}
 
+	elevator_init(rq, "noop");
+
 	if (index < 26) {
 		sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
 	} else if (index < (26 + 1) * 26) {


