Return-Path: <linux-kernel-owner+w=401wt.eu-S943071AbYCSXi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943071AbYCSXi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764665AbYCSWJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:09:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939713AbYCSWJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:09:06 -0400
Date: Wed, 19 Mar 2008 18:09:19 -0500 (EST)
Message-Id: <20080319.180919.118947998.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com,
       linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [RFC PATCH 04/13] block: export blk_register_queue
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

blk_register_queue() is called through add_disk().

Request-based dm defers queue allocation/initialization until
a mapping table is loaded, since the way to initialize queue
is different between bio-based mapping and request-based mapping.
So request-based dm needs to call add_disk() and blk_register_queue()
separately.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-sysfs.c |    1 +
 1 files changed, 1 insertion(+)

Index: 2.6.25-rc5/block/blk-sysfs.c
===================================================================
--- 2.6.25-rc5.orig/block/blk-sysfs.c
+++ 2.6.25-rc5/block/blk-sysfs.c
@@ -295,6 +295,7 @@ int blk_register_queue(struct gendisk *d
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_register_queue);
 
 void blk_unregister_queue(struct gendisk *disk)
 {
