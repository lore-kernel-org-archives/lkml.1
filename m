Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbZJSHxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbZJSHxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZJSHxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:53:52 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:46167 "EHLO cmpxchg.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZJSHxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:53:51 -0400
Date: Mon, 19 Oct 2009 09:53:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Earl Chew <earl_chew@agilent.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Arithmetic overflow in may_expand_vm()
Message-ID: <20091019075350.GA1769@cmpxchg.org>
References: <4AD75AE3.80803@agilent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD75AE3.80803@agilent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 15, 2009 at 10:24:51AM -0700, Earl Chew wrote:
> This code currently reads:
> 
> >int may_expand_vm(struct mm_struct *mm, unsigned long npages)
> >{
> >        unsigned long cur = mm->total_vm;       /* pages */
> >        unsigned long lim;
> >
> >        lim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
> >
> >        if (cur + npages > lim)
> >                return 0;
> >        return 1;
> >}
> 
> If npages is stupendously large, the failure predicate may
> return a false negative due to (cur + npages) overflowing and
> wrapping.

Can this really happen?

npages always originates in a value of byte granularity, giving a
theoretical maximum of ~0UL >> PAGE_SHIFT (checking for more than the
number of addressable bytes just makes no sense).

And mm->total_vm is always PAGE_SIZE times smaller than total user
address space (which in turn is always less than ~0UL).

So I can not see this overflow being possible with PAGE_SHIFT > 0.
