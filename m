Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZDNAvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZDNAvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZDNAv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:51:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:47015 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZDNAv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:51:28 -0400
Date: Tue, 14 Apr 2009 09:49:05 +0900
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, fujita.tomonori@lab.ntt.co.jp,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: pci-swiotlb.c swiotlb_dma_ops should be
 static
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <tip-49cc21f93ddc4c17c2be77d9da43a2db69acc0d3@git.kernel.org>
References: <1239558861.3938.2.camel@localhost.localdomain>
	<tip-49cc21f93ddc4c17c2be77d9da43a2db69acc0d3@git.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090414094852Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 14 Apr 2009 09:49:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 00:12:52 GMT
tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Commit-ID:  49cc21f93ddc4c17c2be77d9da43a2db69acc0d3
> Gitweb:     http://git.kernel.org/tip/49cc21f93ddc4c17c2be77d9da43a2db69acc0d3
> Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
> AuthorDate: Sun, 12 Apr 2009 23:24:21 +0530
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 14 Apr 2009 01:35:11 +0200
> 
> x86: pci-swiotlb.c swiotlb_dma_ops should be static
> 
> Impact: reduce kernel size a bit, address sparse warning
> 
> Addresses the problem pointed out by this sparse warning:
> 
>   arch/x86/kernel/pci-swiotlb.c:53:20: warning: symbol 'swiotlb_dma_ops' was not declared. Should it be static?
> 
> For x86: swiotlb_dma_ops can be static, because it's not used outside
> of pci-swiotlb.c
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> LKML-Reference: <1239558861.3938.2.camel@localhost.localdomain>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


Well, this patch is fine for now. But all the users of swiotlb uses
struct dma_map_ops now so I plan to remove the arch's dma_map_ops
swiotlb_dma_ops.

> 
> ---
>  arch/x86/kernel/pci-swiotlb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 34f12e9..221a385 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -50,7 +50,7 @@ static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
>  }
>  
> -struct dma_map_ops swiotlb_dma_ops = {
> +static struct dma_map_ops swiotlb_dma_ops = {
>  	.mapping_error = swiotlb_dma_mapping_error,
>  	.alloc_coherent = x86_swiotlb_alloc_coherent,
>  	.free_coherent = swiotlb_free_coherent,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
