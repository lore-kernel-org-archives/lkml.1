Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbZATV4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbZATV4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbZATV4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:56:05 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:51634 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753AbZATV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:56:01 -0500
X-Trace: 130160455/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.170/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.170
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.2 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEALbXdUlQLLCq/2dsb2JhbACBbLgWkCyFcw
X-IronPort-AV: E=Sophos;i="4.37,296,1231113600"; 
   d="scan'208";a="130160455"
Subject: Re: [PATCH] dma: fix up broken comparison in
 dma_alloc_from_coherent
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
       dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp
In-Reply-To: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 21:55:07 +0000
Message-Id: <1232488507.6794.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 21:48 +0000, Adrian McMenamin wrote:
> Currently this code compares a size in bytes with a size in pages.
> This patch makes both sides of the comparison bytes.

Apologies, here it is without the line wrap.

Currently this comparison is made between bytes and pages. This patch
ensures it is bytes on both side of the comparison.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -118,7 +118,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 	mem = dev->dma_mem;
 	if (!mem)
 		return 0;
-	if (unlikely(size > mem->size))
+	if (unlikely(size > mem->size << PAGE_SHIFT))
  		return 0;
 
 	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);

