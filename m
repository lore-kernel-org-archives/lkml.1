Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbXIZFOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbXIZFOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 01:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXIZFOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 01:14:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10230 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbXIZFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 01:14:07 -0400
Date: Tue, 25 Sep 2007 22:13:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akepner@sgi.com
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, jejb <james.bottomley@steeleye.com>
Subject: Re: [PATCH 1/4] dma: add dma_flags_set_dmaflush() to dma interface
Message-Id: <20070925221333.bb722dc4.randy.dunlap@oracle.com>
In-Reply-To: <20070926000057.GL30013@sgi.com>
References: <20070926000057.GL30013@sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 17:00:57 -0700 akepner@sgi.com wrote:

[adding James Bottomley to cc: since I think he's interested in
all of these patches]


> Introduce the dma_flags_set_dmaflush() interface and give it
> a default no-op implementation.
> 
> Signed-off-by: Arthur Kepner <akepner@sgi.com>
> -- 
> 
>  dma-mapping.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 2dc21cb..a0f27b9 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -99,4 +99,11 @@ static inline void dmam_release_declared_memory(struct device *dev)
>  }
>  #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
>  
> +#ifndef ARCH_CAN_REORDER_DMA
> +static inline int
> +dma_flags_set_dmaflush(int dir) {
> +	return (dir);
> +}
> +#endif /* ARCH_CAN_REORDER_DMA */
> +
>  #endif


1.  Function signature should be on one line if possible (and it is).
Aw crud, I looked at dma-mapping.h and it uses this format sometimes.
Well, it's undesirable, so please don't propagate it.

2.  No parens on return: it's not a function.

static inline int dma_flags_set_dmaflush(int dir)
{
	return dir;
}


Similar comments for patch 2/4: sn-ia64.

---
~Randy
Phaedrus says that Quality is about caring.
