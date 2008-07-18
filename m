Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYGRJa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYGRJa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYGRJaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:30:12 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:57414 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbYGRJaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=Xez7sAN5FqOzBzq4bj6889ALPkU2SVFuGsrXDMuPim9XLjaUd+h52m/Uzv0xXICAVw
         iXawDVVS0GNXXTocA1IlO0tl7zRb1IJED0C+AyBmENF7WH/XzKaKurtw3rkRGeixREW7
         m2C5bfnrF+7SUjU5rS0okZN+J3lLfeVn5RO8w=
Date: Fri, 18 Jul 2008 13:29:57 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] Generic dma-coherent: fix DMA_MEMORY_EXCLUSIVE
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718092810.GA2423@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Message-ID: <488062a0.1d624e0a.3289.09b9@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't rewrite successfull allocation return values
in case the memory was marked with DMA_MEMORY_EXCLUSIVE.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 kernel/dma-coherent.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
index 89a554c..56dff5c 100644
--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -105,8 +105,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
 			*ret = mem->virt_base + (page << PAGE_SHIFT);
 			memset(*ret, 0, size);
-		}
-		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
+		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE)
 			*ret = NULL;
 	}
 	return (mem != NULL);
-- 
1.5.6.2


-- 
With best wishes
Dmitry

