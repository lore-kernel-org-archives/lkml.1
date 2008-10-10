Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYJJQsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYJJQsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759202AbYJJQsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:48:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:53411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbYJJQsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:48:24 -0400
Message-ID: <48EF86E9.8030408@kernel.org>
Date: Fri, 10 Oct 2008 09:46:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <20081010114002D.fujita.tomonori@lab.ntt.co.jp> <200810100848.09557.jbarnes@virtuousgeek.org> <86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com> <20081010163350.GF25780@parisc-linux.org>
In-Reply-To: <20081010163350.GF25780@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> 
> By the way, commit 8f286c33f1e838d631f4a3260b33efce4bc5973c is a really
> bad idea.  It is very helpful to see which bitmasks are used by real
> devices, and which ones aren't.  It should be reverted, IMO.
> 

why? did you point to wrong commit?

commit 8f286c33f1e838d631f4a3260b33efce4bc5973c
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Oct 18 03:05:07 2007 -0700

    stop using DMA_xxBIT_MASK
    
    Now that we have DMA_BIT_MASK(), these macros are pointless.
    
    Cc: Jeremy Fitzhardinge <jeremy@goop.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 29b0285..101a2d4 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -13,9 +13,15 @@ enum dma_data_direction {
 	DMA_NONE = 3,
 };
 
-#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
+#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
-#define DMA_64BIT_MASK	(~0ULL)
+/*
+ * NOTE: do not use the below macros in new code and do not add new definitions
+ * here.
+ *
+ * Instead, just open-code DMA_BIT_MASK(n) within your driver
+ */
+#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
 #define DMA_48BIT_MASK	DMA_BIT_MASK(48)
 #define DMA_47BIT_MASK	DMA_BIT_MASK(47)
 #define DMA_40BIT_MASK	DMA_BIT_MASK(40)
