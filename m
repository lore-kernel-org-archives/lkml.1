Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbXC1WhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbXC1WhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933814AbXC1WhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:37:19 -0400
Received: from holomorphy.com ([66.93.40.71]:47496 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933648AbXC1WhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:37:18 -0400
Date: Wed, 28 Mar 2007 15:33:27 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org, zach@vmware.com
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070328223327.GG2986@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328222656.GS6602@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328222656.GS6602@sequoia.sous-sol.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
>> +#ifdef CONFIG_HIGHMEM64G
>> +#define __pgd_alloc()		kmem_cache_alloc(pgd_cache, GFP_KERNEL|__GFP_REPEAT)
>> +#define __pgd_free(pgd)		kmem_cache_free(pgd_cache, pgd)

On Wed, Mar 28, 2007 at 03:26:56PM -0700, Chris Wright wrote:
> I must've glazed over something, I thought this was removal of slabs?

The pgd slab is not fully removable in the PAE case because a dedicated
slab is the only way to enforce alignment for allocations as small as
PAE PGD's.


On Wed, Mar 28, 2007 at 03:26:56PM -0700, Chris Wright wrote:
> BTW, this will interact shared_kernel_pmd patch that Jeremy's posted a
> few times (I know at least wli has looked over that one).  We need to
> make sure that PAE under at least Xen hypervisor has a page-sized pgd,
> although the mmlist chaining looks nice to me.

That, not to mention the total lack of verification of the pageattr.c
code, are among the reasons I didn't want it posted.


* Christoph Lameter (clameter@sgi.com) wrote:
>> +	memcpy(&pgd[USER_PTRS_PER_PGD], &swapper_pg_dir[USER_PTRS_PER_PGD],
>> +						KERNEL_PGD_PTRS*sizeof(pgd_t));

On Wed, Mar 28, 2007 at 03:26:56PM -0700, Chris Wright wrote:
> clone_pgd_range() for consistency?  and it seems we lost a
> paravirt_alloc_pd_clone() in there somewhere.

Yes, another reason why it shouldn't have been posted as-is. It was not
intended to for anything more than comparative benchmarking on systems
without graphics running on the bare metal as opposed to Xen/etc. guests.


-- wli
