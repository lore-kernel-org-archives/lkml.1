Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYIVQQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYIVQQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYIVQQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:16:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:58664 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYIVQQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:16:43 -0400
Date: Tue, 23 Sep 2008 01:15:10 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com, muli@il.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export iommu_area_reserve helper funciton
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080922144849.GB27956@elte.hu>
References: <20080922223353K.fujita.tomonori@lab.ntt.co.jp>
	<20080922144849.GB27956@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080923011448M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 16:48:49 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] export iommu_area_reserve helper funciton
> > 
> > x86 has set_bit_string() that does the exact same thing that
> > set_bit_area() in lib/iommu-helper.c does.
> > 
> > This patch exports set_bit_area() in lib/iommu-helper.c as
> > iommu_area_reserve(), converts GART, Calgary, and AMD IOMMU to use it.
> 
> applied the patch below to tip/x86/iommu, thanks.
> 
> > x86's set_bit_string() is used by only the above IOMMUs so this patch 
> > also removes set_bit_string. We can put it back easily when it 
> > necessary.
> 
> could you please send this as a separate patch?

Sure, no problem.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: remove unused set_bit_string

"export iommu_area_reserve helper funciton" patch converted all the
users of set_bit_string, GART, Calgary and AMD IOMMU drivers, to use
iommu_area_reserve helper function. Now we can remove unused
set_bit_string function.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-x86/bitops.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 61989b9..451a747 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -424,16 +424,6 @@ static inline int fls(int x)
 
 #undef ADDR
 
-static inline void set_bit_string(unsigned long *bitmap,
-		unsigned long i, int len)
-{
-	unsigned long end = i + len;
-	while (i < end) {
-		__set_bit(i, bitmap);
-		i++;
-	}
-}
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
-- 
1.5.5.GIT

