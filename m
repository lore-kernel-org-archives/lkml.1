Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbXJLGAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbXJLGAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbXJLGA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:00:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48696 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724AbXJLGA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:00:26 -0400
Date: Fri, 12 Oct 2007 07:00:19 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: axboe@kernel.dk, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] missed bio_endio() in axonram
Message-ID: <20071012060019.GY8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ab037a3..46fd9c6 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -117,7 +117,7 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 	transfered = 0;
 	bio_for_each_segment(vec, bio, idx) {
 		if (unlikely(phys_mem + vec->bv_len > phys_end)) {
-			bio_io_error(bio, bio->bi_size);
+			bio_io_error(bio);
 			rc = -ERANGE;
 			break;
 		}
@@ -131,7 +131,7 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 		phys_mem += vec->bv_len;
 		transfered += vec->bv_len;
 	}
-	bio_endio(bio, transfered, 0);
+	bio_endio(bio, 0);
 
 	return rc;
 }
