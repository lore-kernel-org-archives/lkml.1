Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbXJKHFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbXJKHFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbXJKHE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:04:58 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:14127 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbXJKHE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VnGYV3mEGkc55+aA1eVLTjLzsUDwPRmH8B/k6cv6xMk0zL59q2Ukm2mYlOBZbtn7Hto9tu2eUrZReOXe4r+QgGZJhofSzrMhBgKqaQkRyk9iBofEqZsZrVufWjBCO1ptmLeVqDKJpflNJ8fzJYCpRYM9r4LJ2JgvnF5d7nYD84Q=
Message-ID: <19f34abd0710110004k78d103fate87558822fb631a3@mail.gmail.com>
Date: Thu, 11 Oct 2007 09:04:57 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Fix printk format strings
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Hugh Dickins" <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071010235306.c71afe66.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192085221.26648.31.camel@grianne>
	 <20071010235306.c71afe66.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 11 Oct 2007 08:47:01 +0200 Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
> > This makes sure printk format strings contain no more than a single
> > line.
> >
> > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> > ---
> >  mm/page_alloc.c |   20 +++++++++++---------
> >  1 files changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 1a8c595..96f0b33 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -198,13 +198,15 @@ static inline int bad_range(struct zone *zone, struct page *page)
> >
> >  static void bad_page(struct page *page)
> >  {
> > -     printk(KERN_EMERG "Bad page state in process '%s'\n"
> > -             KERN_EMERG "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n"
> > -             KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
> > -             KERN_EMERG "Backtrace:\n",
> > -             current->comm, page, (int)(2*sizeof(unsigned long)),
> > -             (unsigned long)page->flags, page->mapping,
> > +     printk(KERN_EMERG "Bad page state in process '%s'\n", current->comm);
> > +     printk(KERN_EMERG
> > +             "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n",
> > +             page, (int) (2 * sizeof(unsigned long)),
> > +             (unsigned long) page->flags, page->mapping,
> >               page_mapcount(page), page_count(page));
> > +     printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
> > +     printk(KERN_EMERG "Backtrace:\n");
> > +
> >       dump_stack();
> >       page->flags &= ~(1 << PG_lru    |
> >                       1 << PG_private |
> > @@ -1575,13 +1577,13 @@ void show_free_areas(void)
> >               }
> >       }
> >
> > -     printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
> > -             " free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> > +     printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n",
> >               global_page_state(NR_ACTIVE),
> >               global_page_state(NR_INACTIVE),
> >               global_page_state(NR_FILE_DIRTY),
> >               global_page_state(NR_WRITEBACK),
> > -             global_page_state(NR_UNSTABLE_NFS),
> > +             global_page_state(NR_UNSTABLE_NFS));
> > +     printk(" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> >               global_page_state(NR_FREE_PAGES),
> >               global_page_state(NR_SLAB_RECLAIMABLE) +
> >                       global_page_state(NR_SLAB_UNRECLAIMABLE),
>
> I don't understand the reason for this change.

I'm sorry :). It helps to make one line per call only, since this
allows changing the printk internals for the better by reducing some
complexity. I believe this is a good thing. I have a patch that
changes printk, but it assumes that each format string only contains a
single line. Is this a very bad assumption to make? Or maybe I should
have sent that change first and made a reference to it?

But don't you also agree, on the grounds of principle, that a single
line per call is better style?

Vegard
