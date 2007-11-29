Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXK2NYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXK2NYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 08:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbXK2NYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 08:24:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:20529 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbXK2NYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 08:24:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oNdZK0WjAr7tBlb0S2Y9xAbcHHPafMB4xRIGAk+odhcEuUGT0X0SbbUBOhFnwNu9dUOkmf3/abTNWXfegZjH/6n23Jx4hQRb5muPO84sLTy0tMrz+3Zn39eFW6xOMP/3fzEusPpg3muvPlgWO9Xcu7ZF38diSszMjdISg6kgS44=
Message-ID: <19f34abd0711290524k49628a0dja8a5a04d10253157@mail.gmail.com>
Date: Thu, 29 Nov 2007 14:24:05 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <p734pf59wf7.fsf@crumb.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <474C34CC.6060509@gmail.com> <p734pf59wf7.fsf@crumb.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Nov 2007 11:29:48 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> Vegard Nossum <vegard.nossum@gmail.com> writes:
> >
> > - We properly flush TLB entries that change. This used to not be the case, and so we
>
> For low values of "properly" @)
>
> > +     pte = lookup_address(addr);
> > +     change_page_attr(page, 1, __pgprot(pte->pte_low | _PAGE_VISIBLE));
> > +     __flush_tlb_one(addr);
>
> That's not enough, you need to flush all CPUs.
>
> Also when you don't call global_flush_tlb() eventually because c_p_a() will leak flush
> objects over time.

We don't need to flush all CPUs. This is my rationale: The debug
exception (single-step trap) will always happen on the same CPU that
the page fault occurred on. Page fault shows the page, debug exception
hides the page again. Between those two operations, nothing else can
happen that will use the TLB entry in question (unless you have some
weird race condition, but then the code is in error anyway).

What is c_p_a() and what is a flush object?

>
> -Andi
>

Vegard
