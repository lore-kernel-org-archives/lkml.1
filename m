Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbXJFNwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbXJFNwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 09:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXJFNwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 09:52:45 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:4358 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbXJFNwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 09:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cbmB7spf0yC2TdJQMEZ7rLhgviRBF0Oua+/d1ya450XJs7s/UIBUT2vDLBNFZhKmMMHDgz0NFjSD/5ae6ycbLnS0J/JcQYVp7aqMT4t7DIS0Q8BtywyKRjxNY4kaJGMUG5gHSCnh28xkDEvBVnNFEIc1MtOZUp0dm807u/xI19M=
Message-ID: <8b67d60710060652ha54d28bj30bdc9eec514857f@mail.gmail.com>
Date: Sat, 6 Oct 2007 14:52:43 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>
Subject: [PATCH] Fix SH4 DMAC API
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the DMA cascade by masking the correct bits.

Tested and working with Dreamcast PVR2 DMA. With this patch applied
the existing mainline code in arch/sh/drivers/dma/dma-sh.c works,
whereas before I was patching that to get round this problem.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/include/asm-sh/cpu-sh4/dma.h b/include/asm-sh/cpu-sh4/dma.h
index 36e26a9..aaf71b0 100644
--- a/include/asm-sh/cpu-sh4/dma.h
+++ b/include/asm-sh/cpu-sh4/dma.h
@@ -31,7 +31,7 @@
 #define TS_32		0x00000030
 #define TS_64		0x00000000

-#define CHCR_TS_MASK	0x30
+#define CHCR_TS_MASK	0x70
 #define CHCR_TS_SHIFT	4

 #define DMAOR_COD	0x00000008
