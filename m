Return-Path: <linux-kernel-owner+w=401wt.eu-S1765490AbXHARvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765490AbXHARvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761573AbXHARv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:51:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764916AbXHARv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:51:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] BLOCK: Hide the contents of linux/bio.h if CONFIG_BLOCK=n
	[try #2]
To: torvalds@osdl.org, akpm@osdl.org, James.Bottomley@SteelEye.com,
       jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 01 Aug 2007 18:50:46 +0100
Message-ID: <20070801175046.15956.89679.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Hide the contents of linux/bio.h if CONFIG_BLOCK=n as there shouldn't be
compiled that uses it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/bio.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4d85262..1ddef34 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -24,6 +24,8 @@
 #include <linux/mempool.h>
 #include <linux/ioprio.h>
 
+#ifdef CONFIG_BLOCK
+
 /* Platforms may set this to teach the BIO layer about IOMMU hardware. */
 #include <asm/io.h>
 
@@ -361,4 +363,5 @@ static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
 	__bio_kmap_irq((bio), (bio)->bi_idx, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
+#endif /* CONFIG_BLOCK */
 #endif /* __LINUX_BIO_H */

