Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbYABVL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbYABVL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbYABVLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:11:04 -0500
Received: from hs-out-0708.google.com ([64.233.178.245]:14958 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756053AbYABVLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:11:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ai7Dzd3NOAZLR8sxywwKnGoCXwSNzJh2Epyute5XMsVU6dyyLujJDWwYvC042CiSIG9mnCOm2KOhas9cnXDD6t3Bk8oYTVXpHP8V8oS9L5GeksFJs+Jt2C3WUkbZ65/1patnqmGI+LwW5Hch/po215iVHIUiBJ2diAr6x6xzODo=
Message-ID: <64bb37e0801021310o3a443cc0xc8bb6f06d2c53251@mail.gmail.com>
Date: Wed, 2 Jan 2008 22:10:59 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>, "Jan Blunck" <jblunck@suse.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <Pine.LNX.4.64.0801021249560.21526@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <473DA608.1020804@linux.vnet.ibm.com>
	 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	 <20071117180946.GA14055@elte.hu> <20071117230049.GA25905@dyad>
	 <64bb37e0801021043l26e33aafpa08265b44f0f4c82@mail.gmail.com>
	 <Pine.LNX.4.64.0801021249560.21526@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2008 9:51 PM, Christoph Lameter <clameter@sgi.com> wrote:
> On Wed, 2 Jan 2008, Torsten Kaiser wrote:
>
> > I just tested something with vanilla 2.6.24-rc6 and had the same problem.
> > Should this patch, or something similar be included for 2.6.24?
>
> Such a patch is in Andrew's tree.
>
> 2.6.24-rc6-mm1:
>
> tatic struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
>                                                            int node)
> {
>         struct page *page;
>         struct kmem_cache_node *n;
>         unsigned long flags;
> ...
>
>     /*
>
>          * lockdep requires consistent irq usage for each lock
>          * so even though there cannot be a race this early in
>          * the boot sequence, we still disable irqs.
>          */
>         local_irq_save(flags);
>         add_partial(kmalloc_caches, page, 0);
>         local_irq_restore(flags);
>         return n;
> }
>

from 2.6.24-rc6-mm1 patch-series file:
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch

It seems it got lumped into some other slub patches, but the bug does
not seem to be introduced by them, as I can see it in mainline
2.6.24-rc6.

Should this patch made a candidate for the merge-before-2.6.24-final-queue?

Torsten
