Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbXGTGzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbXGTGzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXGTGzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:55:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35394 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbXGTGzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:55:36 -0400
Subject: Re: About get_page for compound page
From: Peter Zijlstra <peterz@infradead.org>
To: Fengwei Yin <yfw.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ab18d8520707191659l3c176429iee35d00817778711@mail.gmail.com>
References: <ab18d8520707190854v50216497mcc2be291d1a99ab2@mail.gmail.com>
	 <1184881172.20032.160.camel@twins>
	 <ab18d8520707191659l3c176429iee35d00817778711@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 08:55:33 +0200
Message-Id: <1184914533.20032.163.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 07:59 +0800, Fengwei Yin wrote:
> On 7/20/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2007-07-19 at 23:54 +0800, Fengwei Yin wrote:
> > > Hi,
> > > In get_page(), the parameter page is changed by
> > >          page = compound_head(page);
> > > if the page is not the first page of compound pages.
> > >
> > > My question: is this behavior correct?
> >
> > Yes it is, in general the page state of a compound page is kept in the
> > first page of the set.
> >
> Yes. I know this. But
> static inline void get_page(struct page *page)
>                                                      ~~~~~~ changed by
> this function.
> {
>          page = compound_head(page);
>                     ~~~~~~~~~~~~~~~~~~~~~~~
>          VM_BUG_ON(atomic_read(&page->_count) == 0);
>          atomic_inc(&page->_count);
> }
> 
> As I understand, just need update the first page reference count.
> Or the caller aware of this bahavior?
> 
> Or change it to
> static inline void get_page(struct page *page)
> {
>          struct page *head_page = compound_head(page);
>          VM_BUG_ON(atomic_read(&head_page->_count) == 0);
>          atomic_inc(&head_page->_count);
> }

Arguments are local to the function.

