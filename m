Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXF2O7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXF2O7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXF2O7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:59:14 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:27260 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759563AbXF2O7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:59:13 -0400
Date: Fri, 29 Jun 2007 18:58:22 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: fix fallout from "remove sched.h from mm.h" patch
Message-ID: <20070629145821.GA7003@localhost.sw.ru>
References: <20070628140921.GA9753@localhost.sw.ru> <20070628151257.7a03e81b.akpm@linux-foundation.org> <Pine.LNX.4.64.0706290904420.13877@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706290904420.13877@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 09:10:52AM -0400, Robert P. J. Day wrote:
> On Thu, 28 Jun 2007, Andrew Morton wrote:
> > On Thu, 28 Jun 2007 18:09:21 +0400
> > Alexey Dobriyan <adobriyan@sw.ru> wrote:
> >
> > > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> > > ---
> > >
> > >  include/asm-frv/pgtable.h |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > --- a/include/asm-frv/pgtable.h
> > > +++ b/include/asm-frv/pgtable.h
> > > @@ -25,7 +25,7 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/list.h>
> > >  #include <linux/spinlock.h>
> > > -struct mm_struct;
> > > +#include <linux/sched.h>
> > >  struct vm_area_struct;
> > >  #endif
> > >
> >
> > Please provide changelogs.
> >
> > I assume this patch fixes some build error or something.
>
>   i actually asked about this on either the janitors or newbies list
> the other day -- one of the early examples from the LDD3 device
> drivers book which built fine all this time suddenly stopped building,
> until i explicitly included <linux/sched.h> to be able to dereference
> a pointer to "task_struct":
>
> /home/rpjday/AMD/k/topics/0_hi/hi1.c:15: error: dereferencing pointer to incomplete type
> /home/rpjday/AMD/k/topics/0_hi/hi1.c:16: error: dereferencing pointer to incomplete type
>
>   clearly, until now, that header file was being picked up
> *somewhere*,

from include/linux/mm.h , yes

> but not now.

dammit!

> so i'm guessing there's going to be code
> all over the place that suddenly needs to add that inclusion of
> sched.h.

this is the last known to me bit of compile breakage that was caused by
commit e8edc6e03a5c8562dc70a6d969f732bdb355a7e7 aka
"[PATCH] Detach sched.h from mm.h"

And after you'll check diffstat and build current kernel for different archs
yourself, I hope you'll take that "all over the place" back.

P.S.: Al may know more because he is building different set of configs, but I
      was larted about frv only.

