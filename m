Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbXKTN4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbXKTN4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 08:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXKTN4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 08:56:11 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4006 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752181AbXKTN4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 08:56:10 -0500
Date: Tue, 20 Nov 2007 21:56:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [KERNEL]: Avoid divide in IS_ALIGN
Message-ID: <20071120135607.GA18346@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

[KERNEL]: Avoid divide in IS_ALIGN

I was happy to discover the brand new IS_ALIGN macro and quickly
used it in my code.  To my dismay I found that the generated code
used division to perform the test.

This patch fixes it by changing the % test to an &.  This avoids
the division.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..39b3fa6 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -35,7 +35,7 @@ extern const char linux_proc_banner[];
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x,a)		(((x) % ((typeof(x))(a))) == 0)
+#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
