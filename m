Return-Path: <linux-kernel-owner+w=401wt.eu-S933592AbYDVN6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbYDVN6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762982AbYDVN60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:58:26 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57213 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761161AbYDVN6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:58:25 -0400
Date: Tue, 22 Apr 2008 22:58:23 +0900 (JST)
Message-Id: <20080422.225823.95333470.taka@valinux.co.jp>
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 8/10] I/O context inheritance
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The crypt module will duplicate a given bio in its own way, so the newly
allocated bio should inherit the the io_context from the original one.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/drivers/md/dm-crypt.c	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/drivers/md/dm-crypt.c	2008-04-22 15:53:28.000000000 +0900
@@ -581,6 +581,7 @@ static void clone_init(struct dm_crypt_i
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
+	clone->bi_io_context = ioc_object_link(io->base_bio->bi_io_context);
 	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 

