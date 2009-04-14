Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZDNLMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZDNLMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZDNLKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:10:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:39733 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZDNLKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:10:05 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Subject: [PATCH 6/6] Handle possible bio_alloc failure in bounce buffer
Date: Tue, 14 Apr 2009 16:36:47 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200904141636.47759.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle possible bio_alloc failure in bounce buffer.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/mm/bounce.c
===================================================================
--- linux-2.6.orig/mm/bounce.c
+++ linux-2.6/mm/bounce.c
@@ -202,6 +202,9 @@ static void __blk_queue_bounce(struct re
 			unsigned int cnt = (*bio_orig)->bi_vcnt;
 
 			bio = bio_alloc(GFP_NOIO, cnt);
+			if (unlikely(!bio))
+				panic("Unable to allocate bios\n");
+			
 			memset(bio->bi_io_vec, 0, cnt * sizeof(struct bio_vec));
 		}
 			


