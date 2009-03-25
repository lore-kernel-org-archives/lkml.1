Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZCYDHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZCYDHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbZCYDGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:06:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:56067 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321AbZCYDGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:06:52 -0400
Date: Wed, 25 Mar 2009 11:58:23 +0900
To: beckyb@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp,
       ian.campbell@citrix.com, jeremy@goop.org
Subject: Re: [PATCH 2/5] swiotlb: fix compile warning
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org>
References: <1237930126-6741-1-git-send-email-beckyb@kernel.crashing.org>
	<1237930126-6741-2-git-send-email-beckyb@kernel.crashing.org>
	<1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090325114023S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 25 Mar 2009 11:58:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 16:28:43 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> Squash a build warning seen on 32-bit powerpc caused by calling min()
> with 2 different types.  Cast the first arg to size_t, which is the
> type of the second, and should be portable across architectures.
> 
> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> ---
>  lib/swiotlb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index f59cf30..62f5f75 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
>  		unsigned long flags;
>  
>  		while (size) {
> -			sz = min(PAGE_SIZE - offset, size);
> +			sz = min((size_t)(PAGE_SIZE - offset), size);
>  
>  			local_irq_save(flags);
>  			buffer = kmap_atomic(pfn_to_page(pfn),

?

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index f59cf30..fa62498 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 		unsigned long flags;
 
 		while (size) {
-			sz = min(PAGE_SIZE - offset, size);
+			sz = min_t(size_t, PAGE_SIZE - offset, size);
 
 			local_irq_save(flags);
 			buffer = kmap_atomic(pfn_to_page(pfn),
