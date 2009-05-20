Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZETT6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZETT6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 15:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZETT6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 15:58:06 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3713 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZETT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 15:58:05 -0400
X-Greylist: delayed 3092 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 15:58:04 EDT
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH 3/4] Do not __always_inline bvec_kmap_irq() and bvec_kunmap_irq()
Date: Wed, 20 May 2009 16:05:06 -0300
Message-Id: <1242846306-1346-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.2.2.646.gb214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03 2009, Andrew Morton wrote:
> The comment is wrong - this was a sparc requirement, long since removed.

So remove both the comment and the inline requirement, going back to the
inline hint.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 include/linux/bio.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7b214fd..df8fef0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -452,11 +452,8 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
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
 
@@ -472,8 +469,7 @@ static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
 	return (char *) addr + bvec->bv_offset;
 }
 
-static __always_inline void bvec_kunmap_irq(char *buffer,
-		unsigned long *flags)
+static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
 
-- 
1.6.2.2.646.gb214

