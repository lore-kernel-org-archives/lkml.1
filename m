Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYJXU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYJXU7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYJXU7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:59:09 -0400
Received: from gw.goop.org ([64.81.55.164]:34156 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbYJXU7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:59:08 -0400
Message-ID: <49023717.6070604@goop.org>
Date: Fri, 24 Oct 2008 13:59:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, jens.axboe@oracle.com
Subject: [PATCH 1/2] bio: define __BIOVEC_PHYS_MERGEABLE
References: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define __BIOVEC_PHYS_MERGEABLE as the default implementation of
BIOVEC_PHYS_MERGEABLE, so that its available for reuse within an
arch-specific definition of BIOVEC_PHYS_MERGEABLE.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/bio.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

===================================================================
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -221,12 +221,16 @@
 #define __BVEC_END(bio)		bio_iovec_idx((bio), (bio)->bi_vcnt - 1)
 #define __BVEC_START(bio)	bio_iovec_idx((bio), (bio)->bi_idx)
 
+/* Default implementation of BIOVEC_PHYS_MERGEABLE */
+#define __BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
+	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
+
 /*
  * allow arch override, for eg virtualized architectures (put in asm/io.h)
  */
 #ifndef BIOVEC_PHYS_MERGEABLE
 #define BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
-	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
+	__BIOVEC_PHYS_MERGEABLE(vec1, vec2)
 #endif
 
 #define __BIO_SEG_BOUNDARY(addr1, addr2, mask) \


