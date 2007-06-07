Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbXFGLkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbXFGLkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXFGLkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:40:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:59783 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbXFGLkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s/DhU5DsUaD/LNliGyDfQspTi1cSlPO6WAYJBe0tZp1xhRaPJy8rokByBrN3GHwNYVbiiz0qNm7aVwAyrULxkf3+aAF410RM0lC+yx33nsckNauioDHWPCM+r2XclcYDplRYLB/nTlMuDmqb1h8DSa8qtHiXqe2+oDpqedzgT8E=
Message-ID: <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com>
Date: Thu, 7 Jun 2007 17:09:59 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain>
	 <4667EC18.4080904@yahoo.com.au>
	 <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Thu, 7 Jun 2007, Nick Piggin wrote:
>
> > Robert P. J. Day wrote:
> > >   probably making a fool of myself here, but what is the purpose of
> > > that single argument to the macro "ZERO_PAGE"?
> > >
> > > $ grep -r "define ZERO_PAGE" include
> > > include/asm-frv/pgtable.h:#define ZERO_PAGE(vaddr)      ({ BUG(); NULL; })
> > > include/asm-frv/pgtable.h:#define ZERO_PAGE(vaddr)
> > > virt_to_page(empty_zero_page)
> > > include/asm-v850/pgtable.h:#define ZERO_PAGE(vaddr)     ((void *)0x87654321)
> > > include/asm-mips/pgtable.h:#define ZERO_PAGE(vaddr) \
> > > include/asm-blackfin/pgtable.h:#define ZERO_PAGE(vaddr) (virt_to_page(0))
> > > include/asm-parisc/pgtable.h:#define ZERO_PAGE(vaddr)
> > > (virt_to_page(empty_zero_page))
> > > include/asm-alpha/pgtable.h:#define ZERO_PAGE(vaddr)
> > > (virt_to_page(ZERO_PGE))
> > > ...
> > >
> > >   AFAICT, there are no definitions of that macro that actually use
> > > that argument.  is that some kind of historical cruft?
> >
> > MIPS?
>
> argh. that would be the *one* definition whose output got chopped
> because of line continuation, and it would be only one that actually
> uses the argument:
>
> #define ZERO_PAGE(vaddr) \
>         (virt_to_page((void *)(empty_zero_page + (((unsigned long)(vaddr)) & zero_page_mask))))
>
>
> but it still leaves the question -- if ZERO_PAGE is meant to represent
> a single, global shared page that is always zero, why would it *ever*
> need to take an argument?  and what's so special about MIPS that it
> differs from all the rest?

The comment above empty_zero_page and zero_page_mask
declarations at arch/mips/mm/init.c:508 sheds light on this ...
