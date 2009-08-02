Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZHBRfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZHBRfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZHBRfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:35:47 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:46611 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZHBRfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Emu18XsTFYZJ50JoP7j+iSAk34VetQ3awHCxVpZ4RZtphuNBbAZ7lCntIorPe5uFsX
         PDkFokIym6b+7YjCGsv/LeToSKq9t7VWq9IJE7mihlG6TyyLPDTikHeYyqNZKX/td15t
         QLFstdroBDqkIz6iyQQKLJdJucpqgv2NuAtbk=
Date: Sun, 2 Aug 2009 20:36:43 +0300
From: Pekka Paalanen <pq@iki.fi>
To: dri-devel@lists.sourceforge.net
Cc: Thomas Hellstrom <thellstrom@vmware.com>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@gmail.com>
Subject: [PATCH] ttm: Fix a potential comparison of structs.
Message-ID: <20090802203643.5b638eb6@iki.fi>
In-Reply-To: <1249030071-17763-1-git-send-email-thellstrom@vmware.com>
References: <1249030071-17763-1-git-send-email-thellstrom@vmware.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5e2851952729b287a82efa002b28a2095404d44d Mon Sep 17 00:00:00 2001
From: Thomas Hellstrom <thellstrom@vmware.com>
Date: Fri, 31 Jul 2009 10:47:51 +0200
Subject: [PATCH] ttm: Fix a potential comparison of structs.

On some architectures the comparison may cause a compilation failure.

Original partial fix Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

Thomas, you forgot two more of these :-)
Here's a patch that actually compiles on x86_64.

 drivers/gpu/drm/ttm/ttm_bo_util.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index f4e2eba..999fbe7 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -151,7 +151,7 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
 #ifdef CONFIG_X86
 	dst = kmap_atomic_prot(d, KM_USER0, prot);
 #else
-	if (prot != PAGE_KERNEL)
+	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		dst = vmap(&d, 1, 0, prot);
 	else
 		dst = kmap(d);
@@ -164,7 +164,7 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
 #ifdef CONFIG_X86
 	kunmap_atomic(dst, KM_USER0);
 #else
-	if (prot != PAGE_KERNEL)
+	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		vunmap(dst);
 	else
 		kunmap(d);
@@ -187,7 +187,7 @@ static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
 #ifdef CONFIG_X86
 	src = kmap_atomic_prot(s, KM_USER0, prot);
 #else
-	if (prot != PAGE_KERNEL)
+	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		src = vmap(&s, 1, 0, prot);
 	else
 		src = kmap(s);
@@ -200,7 +200,7 @@ static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
 #ifdef CONFIG_X86
 	kunmap_atomic(src, KM_USER0);
 #else
-	if (prot != PAGE_KERNEL)
+	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
 		vunmap(src);
 	else
 		kunmap(s);
-- 
1.6.3.3

