Return-Path: <linux-kernel-owner+w=401wt.eu-S939022AbYCSXo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939022AbYCSXo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938797AbYCSWLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:11:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933835AbYCSWLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:11:32 -0400
Date: Wed, 19 Mar 2008 18:11:53 -0500 (EST)
Message-Id: <20080319.181153.66055860.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com,
       linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [RFC PATCH 12/13] dm-mpath: add hw-handler interface
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a hw-handler interface for request-based dm-multipath.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-hw-handler.h |    1 +
 1 files changed, 1 insertion(+)

Index: 2.6.25-rc5/drivers/md/dm-hw-handler.h
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm-hw-handler.h
+++ 2.6.25-rc5/drivers/md/dm-hw-handler.h
@@ -35,6 +35,7 @@ struct hw_handler_type {
 	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,
 			 struct dm_path *path);
 	unsigned (*error) (struct hw_handler *hwh, struct bio *bio);
+	unsigned (*error_rq) (struct hw_handler *hwh, struct request *rq);
 	int (*status) (struct hw_handler *hwh, status_type_t type,
 		       char *result, unsigned int maxlen);
 };
