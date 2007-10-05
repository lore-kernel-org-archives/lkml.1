Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbXJETrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbXJETrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXJETr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:47:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41968 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759106AbXJETr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:47:27 -0400
Date: Fri, 5 Oct 2007 12:47:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, muli@il.ibm.com,
       satyam@infradead.org, amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
Message-Id: <20071005124705.6584e2f9.akpm@linux-foundation.org>
In-Reply-To: <20070918194647.GA23800@gollum.tnic>
References: <20070918194647.GA23800@gollum.tnic>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 21:46:47 +0200
Borislav Petkov <bbpetkov@yahoo.de> wrote:

> These patches remove redundant DMA_..BIT_MASK definitions across two
> drivers. The computation of the majority of the bitmasks is done by the
> compiler. The initial split of the patch touching each a different file got
> removed due to possible git bisect breakage.
> 
> Andrew, can you please apply this patch for it touches drivers maintained by
> different people and i there might be responsibility issues, imho.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Muli Ben-Yehuda <muli@il.ibm.com>
> 
>  drivers/net/netxen/netxen_nic_main.c |    3 ---
>  drivers/scsi/gdth.c                  |    5 -----
>  include/linux/dma-mapping.h          |   23 +++++++++++++----------
>  3 files changed, 13 insertions(+), 18 deletions(-)
> 
> ...
>
> -#define DMA_64BIT_MASK	0xffffffffffffffffULL
> -#define DMA_48BIT_MASK	0x0000ffffffffffffULL
> -#define DMA_40BIT_MASK	0x000000ffffffffffULL
> -#define DMA_39BIT_MASK	0x0000007fffffffffULL
> -#define DMA_32BIT_MASK	0x00000000ffffffffULL
> -#define DMA_31BIT_MASK	0x000000007fffffffULL
> -#define DMA_30BIT_MASK	0x000000003fffffffULL
> -#define DMA_29BIT_MASK	0x000000001fffffffULL
> -#define DMA_28BIT_MASK	0x000000000fffffffULL
> -#define DMA_24BIT_MASK	0x0000000000ffffffULL
> +#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
> +
> +#define DMA_64BIT_MASK	(~0ULL)
> +#define DMA_48BIT_MASK	DMA_BIT_MASK(48)
> +#define DMA_40BIT_MASK	DMA_BIT_MASK(40)
> +#define DMA_39BIT_MASK	DMA_BIT_MASK(39)
> +#define DMA_35BIT_MASK	DMA_BIT_MASK(35)
> +#define DMA_32BIT_MASK	DMA_BIT_MASK(32)
> +#define DMA_31BIT_MASK	DMA_BIT_MASK(31)
> +#define DMA_30BIT_MASK	DMA_BIT_MASK(30)
> +#define DMA_29BIT_MASK	DMA_BIT_MASK(29)
> +#define DMA_28BIT_MASK	DMA_BIT_MASK(28)
> +#define DMA_24BIT_MASK	DMA_BIT_MASK(24)
>  

Now that you've done this, those DMA_xxBIT_MASK macros are pointless and
stupid and we should aim to get rid of them.


From: Andrew Morton <akpm@linux-foundation.org>

Now that we have DMA_BIT_MASK(), these macros are pointless.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/dma-mapping.h~a include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~a
+++ a/include/linux/dma-mapping.h
@@ -15,6 +15,12 @@ enum dma_data_direction {
 
 #define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
 
+/*
+ * NOTE: do not use the below macros in new code and do not add new definitions
+ * here.
+ *
+ * Instead, just open-code DMA_BIT_MASK(n) within your driver
+ */
 #define DMA_64BIT_MASK	(~0ULL)
 #define DMA_48BIT_MASK	DMA_BIT_MASK(48)
 #define DMA_47BIT_MASK	DMA_BIT_MASK(47)
_

