Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbYBWIK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbYBWIK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765463AbYBWIIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:34 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765428AbYBWIIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:32 -0500
Date: Sat, 23 Feb 2008 00:05:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]iova-lockdep-false-alarm-fix.
Message-Id: <20080223000512.0c2e469c.akpm@linux-foundation.org>
In-Reply-To: <20080221003528.GA5566@linux.intel.com>
References: <20080221003528.GA5566@linux.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH]iova-lockdep-false-alarm-fix.

Nice English titles, please...

On Wed, 20 Feb 2008 16:35:28 -0800 mark gross <mgross@linux.intel.com> wrote:

> lockdep goes off on the iova copy_reserved_iova because it and a
> function it calls grabs locks in the from, and the to of the copy
> operation.
> 
> This patch gives the reserved_ioval_list locks special lockdep classes.
> 
> 

Confused.  Why not fix the ranking inconsistency instead?

Your changelog doesn't tell us why this isn't a real bug?

> Index: linux-2.6.24-mm1/drivers/pci/intel-iommu.c
> ===================================================================
> --- linux-2.6.24-mm1.orig/drivers/pci/intel-iommu.c	2008-02-20 15:52:23.000000000 -0800
> +++ linux-2.6.24-mm1/drivers/pci/intel-iommu.c	2008-02-20 16:08:27.000000000 -0800
> @@ -1127,6 +1127,8 @@
>  }
>  
>  static struct iova_domain reserved_iova_list;
> +static struct lock_class_key reserved_alloc_key;
> +static struct lock_class_key reserved_rbtree_key;
>  
>  static void dmar_init_reserved_ranges(void)
>  {
> @@ -1137,6 +1139,11 @@
>  
>  	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
>  
> +	lockdep_set_class(&reserved_iova_list.iova_alloc_lock,
> +		&reserved_alloc_key);
> +	lockdep_set_class(&reserved_iova_list.iova_rbtree_lock,
> +		&reserved_rbtree_key);
> +
>  	/* IOAPIC ranges shouldn't be accessed by DMA */
>  	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
>  		IOVA_PFN(IOAPIC_RANGE_END));
