Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYAWIvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYAWIvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYAWIvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:51:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51590 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYAWIva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:51:30 -0500
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in
	sys_msync()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, miklos@szeredi.hu, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <1201078035.6341.45.camel@lappy>
References: <12010440803930-git-send-email-salikhmetov@gmail.com>
	 <1201044083504-git-send-email-salikhmetov@gmail.com>
	 <1201078035.6341.45.camel@lappy>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 09:51:18 +0100
Message-Id: <1201078278.6341.47.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 09:47 +0100, Peter Zijlstra wrote:
> On Wed, 2008-01-23 at 02:21 +0300, Anton Salikhmetov wrote:

> > +static void vma_wrprotect(struct vm_area_struct *vma)
> > +{
> > +	unsigned long addr = vma->vm_start;
> > +	pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
> > +
> > +	while (addr < vma->vm_end) {
> > +		unsigned long next = pgd_addr_end(addr, vma->vm_end);
> > +
> > +		if (!pgd_none_or_clear_bad(pgd))
> > +			vma_wrprotect_pgd_range(vma, pgd, addr, next);
> > +
> > +		++pgd;
> > +		addr = next;
> > +	}
> > +}
> 
> I think you want to pass start, end here too, you might not need to
> sweep the whole vma.

Also, it still doesn't make sense to me why we'd not need to walk the
rmap, it is all the same file after all.

