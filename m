Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYKQDtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYKQDtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYKQDtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:49:16 -0500
Received: from sh.osrg.net ([192.16.179.4]:50285 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbYKQDtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:49:14 -0500
Date: Mon, 17 Nov 2008 12:48:51 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com
Subject: Re: [PATCH 04 of 38] swiotlb: move some definitions to header
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <3d0746ce3c320ac694db.1226603402@abulafia.goop.org>
References: <patchbomb.1226603398@abulafia.goop.org>
	<3d0746ce3c320ac694db.1226603402@abulafia.goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081117120246K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 11:10:02 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  include/linux/swiotlb.h |   14 ++++++++++++++
>  lib/swiotlb.c           |   14 +-------------
>  2 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -7,6 +7,20 @@
>  struct dma_attrs;
>  struct scatterlist;
>  
> +/*
> + * Maximum allowable number of contiguous slabs to map,
> + * must be a power of 2.  What is the appropriate value ?
> + * The complexity of {map,unmap}_single is linearly dependent on this value.
> + */
> +#define IO_TLB_SEGSIZE	128
> +
> +
> +/*
> + * log of the size of each IO TLB slab.  The number of slabs is command line
> + * controllable.
> + */
> +#define IO_TLB_SHIFT 11
> +

Why do we need to export IO_TLB_SEGSIZE and IO_TLB_SHIFT to everyone
in include/linux?
