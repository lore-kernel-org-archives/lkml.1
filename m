Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYBOWaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYBOWaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbYBOW35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:29:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbYBOW34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:29:56 -0500
Date: Fri, 15 Feb 2008 17:30:02 -0500 (EST)
Message-Id: <20080215.173002.112288889.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [APPENDIX PATCH 03/13] block: export blk_register_queue
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports blk_register_queue().

Request-based dm and bio-based dm will coexist, since there are
some target drivers which are more fitting to bio-based dm.
dm decides the hook type for a dm device and initializes the queue,
when a table is loaded to the dm device, not device creation time.
Then, request-based dm sets q->request_fn and wants to register
the queue correctly again.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-sysfs.c |    1 +
 1 files changed, 1 insertion(+)

Index: 2.6.25-rc1/block/blk-sysfs.c
===================================================================
--- 2.6.25-rc1.orig/block/blk-sysfs.c
+++ 2.6.25-rc1/block/blk-sysfs.c
@@ -295,6 +295,7 @@ int blk_register_queue(struct gendisk *d
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_register_queue);
 
 void blk_unregister_queue(struct gendisk *disk)
 {
