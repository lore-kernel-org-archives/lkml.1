Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYBDEbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYBDEbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 23:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYBDEbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 23:31:12 -0500
Received: from web36704.mail.mud.yahoo.com ([209.191.85.38]:46400 "HELO
	web36704.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751356AbYBDEbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 23:31:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dCkduZ+zgndav1D6MoOgn56bL1Mf1BLWsPEK3ndw3lv+ipooZ5tOmKI/07S2kUy9wZ8wNBH/EfPhA6Fo6qdKF+4S1MBxcy4wOtk8PxziQ5hIwe12nSLXCLIdP2j3I8P/l/NTgu7Q9F4gV8n324lalAaGFy8FlK9snJdAhpkucgQ=;
X-YMail-OSG: kDUuhTMVM1l39mFM69pPZU7r23JUAg5nL52bHo4t7gq1er.zyBpepCAuEYpXke_2_84S6a0LzNBvNjR3X7F527rh85qo3Qy4szTfTMLyCuuEXao-
Date: Sun, 3 Feb 2008 20:31:10 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: [PATCH] memstick: use __blk_end_request to complete requests
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20080202161635.fc02de0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <943786.16504.qm@web36704.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Dubov <oakad@yahoo.com>

--- mspro_block.c.orig	2008-02-04 15:25:16.000000000 +1100
+++ mspro_block.c	2008-02-04 15:26:28.226886699 +1100
@@ -668,20 +668,13 @@

 		spin_lock_irqsave(&msb->q_lock, flags);
 		if (rc >= 0)
-			chunk = end_that_request_chunk(req, 1, rc);
+			chunk = __blk_end_request(req, 0, rc);
 		else
-			chunk = end_that_request_first(req, rc,
-						       req->current_nr_sectors);
+			chunk = __blk_end_request(req, rc, 0);

 		dev_dbg(&card->dev, "end chunk %d, %d\n", rc, chunk);
-		if (!chunk) {
-			add_disk_randomness(req->rq_disk);
-			blkdev_dequeue_request(req);
-			end_that_request_last(req, rc > 0 ? 1 : rc);
-		}
 		spin_unlock_irqrestore(&msb->q_lock, flags);
 	} while (chunk);
-
 }

 static int mspro_block_has_request(struct mspro_block_data *msb)



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

