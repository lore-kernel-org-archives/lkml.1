Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbYG1Uhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbYG1Uhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYG1Uhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:37:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39130 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYG1Uhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:37:42 -0400
Subject: Re: [PATCH 4/5 V2] Build hugetlb backed process stacks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric Munson <ebmunson@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
In-Reply-To: <34bf5c7a2116bc6bd16b4235bc1cf84395ee561e.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	 <34bf5c7a2116bc6bd16b4235bc1cf84395ee561e.1216928613.git.ebmunson@us.ibm.com>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 13:37:38 -0700
Message-Id: <1217277458.23502.39.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 12:17 -0700, Eric Munson wrote:
> 
> +static int move_to_huge_pages(struct linux_binprm *bprm,
> +                               struct vm_area_struct *vma, unsigned
> long shift)
> +{
> +       struct mm_struct *mm = vma->vm_mm;
> +       struct vm_area_struct *new_vma;
> +       unsigned long old_end = vma->vm_end;
> +       unsigned long old_start = vma->vm_start;
> +       unsigned long new_end = old_end - shift;
> +       unsigned long new_start, length;
> +       unsigned long arg_size = new_end - bprm->p;
> +       unsigned long flags = vma->vm_flags;
> +       struct file *hugefile = NULL;
> +       unsigned int stack_hpages = 0;
> +       struct page **from_pages = NULL;
> +       struct page **to_pages = NULL;
> +       unsigned long num_pages = (arg_size / PAGE_SIZE) + 1;
> +       int ret;
> +       int i;
> +
> +#ifdef CONFIG_STACK_GROWSUP

Why do you have the #ifdef for the CONFIG_STACK_GROWSUP=y case in that
first patch if you don't support CONFIG_STACK_GROWSUP=y?

I think it might be worth some time to break this up a wee little bit.
16 local variables is a big on the beefy side. :)

-- Dave

