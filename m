Return-Path: <linux-kernel-owner+w=401wt.eu-S1763028AbYCUWri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028AbYCUWri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762489AbYCUWpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:45:55 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34686 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762436AbYCUWpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:45:53 -0400
Message-Id: <20080321224346.817519507@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:10 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 20/76] drivers: fix dma_get_required_mask
Content-Disposition: inline; filename=drivers-fix-dma_get_required_mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

There's a bug in the current implementation of dma_get_required_mask()
where it ands the returned mask with the current device mask.  This
rather defeats the purpose if you're using the call to determine what
your mask should be (since you will at that time have the default
DMA_32BIT_MASK).  This bug results in any driver that uses this function
*always* getting a 32 bit mask, which is wrong.

Fix by removing the and with dev->dma_mask.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -647,7 +647,7 @@ u64 dma_get_required_mask(struct device 
 		high_totalram += high_totalram - 1;
 		mask = (((u64)high_totalram) << 32) + 0xffffffff;
 	}
-	return mask & *dev->dma_mask;
+	return mask;
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif

-- 
