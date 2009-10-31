Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbZJaVox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbZJaVox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933282AbZJaVox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:44:53 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:1073 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273AbZJaVow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:44:52 -0400
X-Greylist: delayed 1556 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Oct 2009 17:44:52 EDT
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Do not __always_inline bvec_kmap_irq() and bvec_kunmap_irq()
Date: Sat, 31 Oct 2009 18:21:00 -0300
Message-Id: <1257024060-23039-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.5.2.250.g2bd30
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
index 5be93f1..474792b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -450,11 +450,8 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
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
 
@@ -470,8 +467,7 @@ static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
 	return (char *) addr + bvec->bv_offset;
 }
 
-static __always_inline void bvec_kunmap_irq(char *buffer,
-		unsigned long *flags)
+static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
 
-- 
1.6.5.2.250.g2bd30

