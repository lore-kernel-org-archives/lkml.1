Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbYHFVWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbYHFVWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbYHFVN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:13:29 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59677 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760844AbYHFVN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:13:28 -0400
Date: Thu, 7 Aug 2008 00:11:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] parisc/lib/: make code static
Message-ID: <20080806211159.GW1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- iomap.c: struct iomap_ops[]
- memcpy.c: pa_memcpy()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 15 Jun 2008

 arch/parisc/lib/iomap.c  |    2 +-
 arch/parisc/lib/memcpy.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

45e7cd0b2c678dda4f5ba4ac6d0ed628df9381bd diff --git a/arch/parisc/lib/iomap.c b/arch/parisc/lib/iomap.c
index 9abed07..5069e8b 100644
--- a/arch/parisc/lib/iomap.c
+++ b/arch/parisc/lib/iomap.c
@@ -261,7 +261,7 @@ static const struct iomap_ops iomem_ops = {
 	iomem_write32r,
 };
 
-const struct iomap_ops *iomap_ops[8] = {
+static const struct iomap_ops *iomap_ops[8] = {
 	[0] = &ioport_ops,
 	[7] = &iomem_ops
 };
diff --git a/arch/parisc/lib/memcpy.c b/arch/parisc/lib/memcpy.c
index 2d68431..bbda909 100644
--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -275,7 +275,7 @@ handle_store_error:
 
 
 /* Returns 0 for success, otherwise, returns number of bytes not transferred. */
-unsigned long pa_memcpy(void *dstp, const void *srcp, unsigned long len)
+static unsigned long pa_memcpy(void *dstp, const void *srcp, unsigned long len)
 {
 	register unsigned long src, dst, t1, t2, t3;
 	register unsigned char *pcs, *pcd;

