Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915Ab0AWMsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0AWMsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 07:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916Ab0AWMsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 07:48:19 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:60731 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0AWMsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 07:48:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ioKSJIFVIg97HJpNF6JQW8mX/xMn15owq/+i73AYaN7Z9jIlbHeGBe/PGLj1ODFqjl
         erfV8Hi3nc6vbb/YS9BG40XRbznUWSjpEqaABtlA/MYlp9gxAf7WsJOH8yJuLtYVSv1J
         qichV8f12EsZmJWm8G08SNCv49dC+Dts9j8lI=
Date: Sat, 23 Jan 2010 15:45:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] drbd: null dereference bug
Message-ID: <20100123124522.GA3061@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Ellenberg <drbd-dev@lists.linbit.com>,
	drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

epoch is always NULL here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This patch has only been compile tested.  Sorry.  :/

--- orig/drivers/block/drbd/drbd_receiver.c	2010-01-23 10:53:13.000000000 +0300
+++ devel/drivers/block/drbd/drbd_receiver.c	2010-01-23 10:54:19.000000000 +0300
@@ -1224,7 +1224,7 @@ static int receive_Barrier(struct drbd_c
 	epoch = kmalloc(sizeof(struct drbd_epoch), GFP_NOIO);
 	if (!epoch) {
 		dev_warn(DEV, "Allocation of an epoch failed, slowing down\n");
-		issue_flush = !test_and_set_bit(DE_BARRIER_IN_NEXT_EPOCH_ISSUED, &epoch->flags);
+		issue_flush = !test_and_set_bit(DE_BARRIER_IN_NEXT_EPOCH_ISSUED, &mdev->current_epoch->flags);
 		drbd_wait_ee_list_empty(mdev, &mdev->active_ee);
 		if (issue_flush) {
 			rv = drbd_flush_after_epoch(mdev, mdev->current_epoch);
