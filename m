Return-Path: <linux-kernel-owner+w=401wt.eu-S1764251AbZBDTHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764251AbZBDTHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761519AbZBDSuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:50:11 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:36897 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760541AbZBDSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:50:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=w6SUpVvHvAZPt8g+A70SpPRGQquQuMLBMFzj14s4L2XIPwGrifUzoo9rbp4LlPj96f
         KIXSBOpgN331uO2lUFkWTHLCV9AhqzxwFvzGqIlP20yaMN62EyBm15B50BpguvuYe56D
         uJ5ldJ4n84SkbxnNMnblNxtUqEzMXiajyTjgw=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Do not __always_inline bvec_kmap_irq() and bvec_kunmap_irq()
Date: Wed,  4 Feb 2009 16:49:55 -0200
Message-Id: <1233773395-13251-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.1.1.363.g2a3bd
In-Reply-To: <1233773102-12903-1-git-send-email-albertito@blitiri.com.ar>
References: <1233773102-12903-1-git-send-email-albertito@blitiri.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03 2009, Andrew Morton wrote:
> The comment is wrong - this was a sparc requirement, long since removed.

So remove both the comment and the inline requirement, going back to the
inline hint.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---

This is the same patch as before, except it's properly indented because
everything fits < 80 columns or so.

 include/linux/bio.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 713ec6e..972a0e4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -442,11 +442,8 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
 /*
  * remember never ever reenable interrupts between a bvec_kmap_irq and
  * bvec_kunmap_irq!
- *
- * This function MUST be inlined - it plays with the CPU interrupt flags.
  */
-static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
-		unsigned long *flags)
+static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 {
 	unsigned long addr;
 
@@ -462,8 +459,7 @@ static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
 	return (char *) addr + bvec->bv_offset;
 }
 
-static __always_inline void bvec_kunmap_irq(char *buffer,
-		unsigned long *flags)
+static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
 
-- 
1.6.1.1.363.g2a3bd

