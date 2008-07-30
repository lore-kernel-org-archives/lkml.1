Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYG3RPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYG3RPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYG3RO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:14:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbYG3ROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:14:55 -0400
Date: Wed, 30 Jul 2008 10:14:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Message-Id: <20080730101438.e1484440.akpm@linux-foundation.org>
In-Reply-To: <20080730170939.GA28604@cs181140183.pp.htv.fi>
References: <200807301438.55941.rusty@rustcorp.com.au>
	<20080730033523.0f38f7e4.akpm@linux-foundation.org>
	<20080730154736.GC21597@cs181140183.pp.htv.fi>
	<20080730100355.f1402dcf.akpm@linux-foundation.org>
	<20080730170939.GA28604@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 20:09:39 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Jul 30, 2008 at 10:03:55AM -0700, Andrew Morton wrote:
> > On Wed, 30 Jul 2008 18:47:36 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Wed, Jul 30, 2008 at 03:35:23AM -0700, Andrew Morton wrote:
> > > > On Wed, 30 Jul 2008 14:38:55 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > > 
> > > > > After all, it was made for lguest wasn't it?  Still think it should be
> > > > > called get_current_pages() though.
> > > > > 
> > > > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > > > ---
> > > > >  arch/x86/mm/gup.c |    2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > > 
> > > > > diff -r cb465381f6d5 arch/x86/mm/gup.c
> > > > > --- a/arch/x86/mm/gup.c	Wed Jul 30 10:18:44 2008 +1000
> > > > > +++ b/arch/x86/mm/gup.c	Wed Jul 30 14:22:53 2008 +1000
> > > > > @@ -8,6 +8,7 @@
> > > > >  #include <linux/mm.h>
> > > > >  #include <linux/vmstat.h>
> > > > >  #include <linux/highmem.h>
> > > > > +#include <linux/module.h>
> > > > >  
> > > > >  #include <asm/pgtable.h>
> > > > >  
> > > > > @@ -296,3 +303,4 @@ slow_irqon:
> > > > >  		return ret;
> > > > >  	}
> > > > >  }
> > > > > +EXPORT_SYMBOL_GPL(get_user_pages_fast);
> > > > 
> > > > A regularly-occurring problem with an export like this is that someone
> > > > writes a driver and tests it on x86, then the driver explodes on an
> > > > architecture which didn't export the same symbol.
> > > > 
> > > > So a better implementation might be to put
> > > > 
> > > > #ifdef CONFIG_HAVE_GET_USER_PAGES_FAST
> > > > EXPORT_SYMBOL_GPL(get_user_pages_fast);
> > > > #endif
> > > > 
> > > > into generic code somewhere.
> > > 
> > > How would that help?
> > 
> > It would fix the problem which I described.
> 
> The export would still only be available on x86 since no other arch 
> would define CONFIG_HAVE_GET_USER_PAGES_FAST.
> 

That's presently true in Linus mainline.  The powerpc implementation is
in -mm, but apprarently needs a bit more work.
