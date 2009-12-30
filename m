Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbZL3XaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbZL3XaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZL3XaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:30:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbZL3XaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:30:03 -0500
Date: Wed, 30 Dec 2009 15:29:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] hugetlb: Fix section mismatch warning in hugetlb.c
Message-Id: <20091230152958.9b6e174e.akpm@linux-foundation.org>
In-Reply-To: <b9df5fa10912231905t69502923gee5aaf1c1b2efa6a@mail.gmail.com>
References: <b9df5fa10912231905t69502923gee5aaf1c1b2efa6a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Dec 2009 09:05:48 +0600
Rakib Mullick <rakib.mullick@gmail.com> wrote:

>     The patch titled hugetlb-add-per-node-hstate-attributes.patch introduces
>  the following section mismatch warning, due to a reference form non-init
> function hugetlb_register_node to a init function hugetlb_sysfs_add_hstate.
> 
> LD      mm/built-in.o
> WARNING: mm/built-in.o(.text+0x5396d): Section mismatch in reference
> from the function hugetlb_register_node() to the function
> .init.text:hugetlb_sysfs_add_hstate()
> The function hugetlb_register_node() references
> the function __init hugetlb_sysfs_add_hstate().
> This is often because hugetlb_register_node lacks a __init
> annotation or the annotation of hugetlb_sysfs_add_hstate is wrong.
> 
> ---
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linus/mm/hugetlb.c	2009-12-18 15:52:35.000000000 +0600
> +++ rakib/mm/hugetlb.c	2009-12-23 20:37:16.000000000 +0600
> @@ -1515,7 +1515,7 @@ static struct attribute_group hstate_att
>  	.attrs = hstate_attrs,
>  };
> 
> -static int __init hugetlb_sysfs_add_hstate(struct hstate *h,
> +static int hugetlb_sysfs_add_hstate(struct hstate *h,
>  				struct kobject *parent,
>  				struct kobject **hstate_kobjs,
>  				struct attribute_group *hstate_attr_group)

I would be better to fix it the other way.  AFACIT,
hugetlb_register_node() and both versions of
hugetlb_register_all_nodes() should be marked __init.

