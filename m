Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0BYDK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:10:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37312 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab0BYDK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:10:26 -0500
Date: Thu, 25 Feb 2010 14:10:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20100225141022.c5b3b7ce.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
include/linux/blkdev.h between commit
79da0644a8e0838522828f106e4049639eea6baf ("Revert "block: improve
queue_should_plug() by looking at IO depths"") from Linus' tree and
commit 488991e28e55b4fbca8067edf0259f69d1a6f92c ("block: Added in
stricter no merge semantics for block I/O") from the block tree.

Context changes - I have fixed it up (see below) and can carry the fix
for a while.  I suspect that you were expecting this. :-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/blkdev.h
index 1896e86,f71f5c5..0000000
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@@ -461,7 -461,9 +461,8 @@@ struct request_queu
  #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
  #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
  #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
 -#define QUEUE_FLAG_CQ	       16	/* hardware does queuing */
 -#define QUEUE_FLAG_DISCARD     17	/* supports DISCARD */
 -#define QUEUE_FLAG_NOXMERGES   18	/* No extended merges */
 +#define QUEUE_FLAG_DISCARD     16	/* supports DISCARD */
++#define QUEUE_FLAG_NOXMERGES   17	/* No extended merges */
  
  #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
  				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@@ -585,8 -587,11 +586,10 @@@ enum 
  
  #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
  #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 -#define blk_queue_queuing(q)	test_bit(QUEUE_FLAG_CQ, &(q)->queue_flags)
  #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
  #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
+ #define blk_queue_noxmerges(q)	\
+ 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
  #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
  #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
  #define blk_queue_flushing(q)	((q)->ordseq)
