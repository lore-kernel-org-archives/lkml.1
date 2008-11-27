Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYK0MDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYK0MDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYK0MDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:03:20 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:41527 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbYK0MDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:03:20 -0500
Subject: [PATCH] mm: reorder struct bio to remove padding on 64bit
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: neilb@suse.de
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 12:03:17 +0000
Message-Id: <1227787397.3120.7.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove 8 bytes of padding from struct bio which also removes 16 bytes
from struct bio_pair to make it 248 bytes. bio_pair then fits into one
fewer cache lines & into a smaller slab.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
Hi Neil,
This compiles but hasn't had any testing, as I don't have a raid to test
it on. 
patch against 2.6.28-rc6.
regards
Richard



diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6a64209..e6789b2 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -90,10 +90,11 @@ struct bio {
 
 	unsigned int		bi_comp_cpu;	/* completion CPU */
 
+	atomic_t		bi_cnt;		/* pin count */
+
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
 	bio_end_io_t		*bi_end_io;
-	atomic_t		bi_cnt;		/* pin count */
 
 	void			*bi_private;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)


