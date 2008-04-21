Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbYDUUup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbYDUUup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYDUUug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:50:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49601 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYDUUug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:50:36 -0400
Subject: Re: [patch 01/17] hugetlb: modular state
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
To: npiggin@suse.de
Cc: akpm@linux-foundation.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, pj@sgi.com,
       andi@firstfloor.org, kniht@linux.vnet.ibm.com
In-Reply-To: <20080410171100.425293000@nick.local0.net>
References: <20080410170232.015351000@nick.local0.net>
	 <20080410171100.425293000@nick.local0.net>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 15:51:24 -0500
Message-Id: <1208811084.11866.10.camel@skynet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-11 at 03:02 +1000, npiggin@suse.de wrote:

<snip>

> Index: linux-2.6/include/linux/hugetlb.h
> ===================================================================
> --- linux-2.6.orig/include/linux/hugetlb.h
> +++ linux-2.6/include/linux/hugetlb.h
> @@ -40,7 +40,7 @@ extern int sysctl_hugetlb_shm_group;
> 
>  /* arch callbacks */
> 
> -pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr);
> +pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr, int sz);

<snip>

The sz here needs to be a long to handle sizes such as 16G on powerpc.

There are other places in hugetlb.c where the size also needs to be a
long, but this one affects the arch code too since it is public.

Jon
Tollefson


