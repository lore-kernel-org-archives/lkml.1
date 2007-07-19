Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbXGTAAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbXGTAAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934283AbXGSX7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:59:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:30334 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768AbXGSX7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mais9dBFvPy9A7uJDu/eBSm8o1mVJ7Rybe8GTVtT+3AS+LDisDBCIR2tei5DUn2YPK3V9i+JtKDCpcyyA4bhXPv2hu6HOzLBScYdjYcGhl/1FyTcKRgVf5jph4oJ+Qz8XBJUSIOExP0ableqeU2LTCmYK9RT2OU08oDIuALnPec=
Message-ID: <ab18d8520707191659l3c176429iee35d00817778711@mail.gmail.com>
Date: Fri, 20 Jul 2007 07:59:53 +0800
From: "Fengwei Yin" <yfw.kernel@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: About get_page for compound page
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1184881172.20032.160.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab18d8520707190854v50216497mcc2be291d1a99ab2@mail.gmail.com>
	 <1184881172.20032.160.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2007-07-19 at 23:54 +0800, Fengwei Yin wrote:
> > Hi,
> > In get_page(), the parameter page is changed by
> >          page = compound_head(page);
> > if the page is not the first page of compound pages.
> >
> > My question: is this behavior correct?
>
> Yes it is, in general the page state of a compound page is kept in the
> first page of the set.
>
Yes. I know this. But
static inline void get_page(struct page *page)
                                                     ~~~~~~ changed by
this function.
{
         page = compound_head(page);
                    ~~~~~~~~~~~~~~~~~~~~~~~
         VM_BUG_ON(atomic_read(&page->_count) == 0);
         atomic_inc(&page->_count);
}

As I understand, just need update the first page reference count.
Or the caller aware of this bahavior?

Or change it to
static inline void get_page(struct page *page)
{
         struct page *head_page = compound_head(page);
         VM_BUG_ON(atomic_read(&head_page->_count) == 0);
         atomic_inc(&head_page->_count);
}

Regards
Yin, Fengwei
