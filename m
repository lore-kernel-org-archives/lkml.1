Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYICRea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYICRea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYICRd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:33:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:50097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbYICRd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:33:58 -0400
Message-ID: <48BECA2D.8000400@kernel.org>
Date: Wed, 03 Sep 2008 19:32:29 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH linux-2.6-block#for-2.6.28] block: fix duplicate headers for
 /proc/partitions
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Sep 2008 17:33:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seqf can be started multiple times for a read and the header should be
printed only for the initial one.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index ed926b7..8acaff0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -697,7 +697,7 @@ static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
 	static void *p;
 
 	p = disk_seqf_start(seqf, pos);
-	if (!IS_ERR(p) && p)
+	if (!IS_ERR(p) && p && !*pos)
 		seq_puts(seqf, "major minor  #blocks  name\n\n");
 	return p;
 }

