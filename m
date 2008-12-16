Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYLPT6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYLPT6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbYLPT5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:57:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756695AbYLPT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:57:52 -0500
Date: Tue, 16 Dec 2008 11:57:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, npiggin@suse.de,
       hugh@veritas.com, rdreier@cisco.com, jbarnes@virtuousgeek.org,
       jeremy@goop.org, arjan@infradead.org, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com
Subject: Re: [patch 4/8] x86 PAT: hooks in generic vm code to help archs to
 track pfnmap regions
Message-Id: <20081216115717.9f7082c7.akpm@linux-foundation.org>
In-Reply-To: <20081112212900.436502000@intel.com>
References: <20081112212647.259698000@intel.com>
	<20081112212900.436502000@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 13:26:51 -0800
Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> --- tip.orig/mm/memory.c	2008-11-11 10:10:11.000000000 -0800
> +++ tip/mm/memory.c	2008-11-11 12:10:18.000000000 -0800
> @@ -99,6 +99,28 @@ int randomize_va_space __read_mostly =
>  					2;
>  #endif
>  
> +#ifndef track_pfn_vma_new
> +int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
> +			unsigned long pfn, unsigned long size)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#ifndef track_pfn_vma_copy
> +int track_pfn_vma_copy(struct vm_area_struct *vma)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#ifndef untrack_pfn_vma
> +void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
> +			unsigned long size)
> +{
> +}
> +#endif

Using __weak would provide a somewhat neater result here.
