Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYBHWUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYBHWUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYBHWUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:20:00 -0500
Received: from waste.org ([66.93.16.53]:52091 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbYBHWT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:19:59 -0500
Subject: Re: [PATCH] stub out is_swap_pte for !MMU
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vapier@gentoo.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080208140555.01d3832f.akpm@linux-foundation.org>
References: <1202500959-2727-1-git-send-email-vapier@gentoo.org>
	 <1202503750.17934.639.camel@cinder.waste.org>
	 <200802081625.12893.vapier@gentoo.org>
	 <1202506903.17934.653.camel@cinder.waste.org>
	 <20080208140555.01d3832f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 16:19:39 -0600
Message-Id: <1202509179.17934.663.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 14:05 -0800, Andrew Morton wrote:
> On Fri, 08 Feb 2008 15:41:42 -0600
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > Fix compile error on nommu for is_swap_pte
> > 
> > Does it ever make sense to ask "is this pte a swap entry?" on a machine
> > with no MMU? Presumably this also means it has no ptes too, right? In
> > which case, it's better to comment the whole function out. Then when
> > someone tries to ask the above meaningless question, they get a compile
> > error rather than a meaningless answer.
> > 
> > Signed-off-by: Matt Mackall <mpm@selenic.com>
> > 
> > diff -r 50a6e531a9f2 include/linux/swapops.h
> > --- a/include/linux/swapops.h	Mon Feb 04 20:23:02 2008 -0600
> > +++ b/include/linux/swapops.h	Fri Feb 08 15:38:01 2008 -0600
> > @@ -42,11 +42,13 @@
> >  	return entry.val & SWP_OFFSET_MASK(entry);
> >  }
> >  
> > +#ifdef CONFIG_MMU
> >  /* check whether a pte points to a swap entry */
> >  static inline int is_swap_pte(pte_t pte)
> >  {
> >  	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
> >  }
> > +#endif
> >  
> 
> Seems contradictory.  Is there _really_ a compilation error at present? 
> The changelog seems to imply otherwise and no compiler error output is
> quoted and it all compiled OK for me on nommu superh.

Sorry, here's the compile error from the original thread (where the
original copy of the above patch was posted).

...
  CC      mm/vmscan.o
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'
make[2]: *** [mm/vmscan.o] Error 1

-- 
Mathematics is the supreme nostalgia of our time.

