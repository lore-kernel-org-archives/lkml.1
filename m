Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYDKKep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYDKKep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbYDKKeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:34:31 -0400
Received: from mail.suse.de ([195.135.220.2]:58552 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760098AbYDKKea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:34:30 -0400
Date: Fri, 11 Apr 2008 12:34:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Message-ID: <20080411103428.GA15481@wotan.suse.de>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080411092452.GE10801@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411092452.GE10801@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 11:24:52AM +0200, Ingo Molnar wrote:
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Fri, Apr 11, 2008 at 12:05 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > >  >  Right. Then you probably want to look into any changes in arch/x86/
> > >  >  related to setting up the zonelists. I'm fairly certain this is not a
> > >  >  slab bug and I don't see any recent changes to the page allocator
> > >  >  either that would explain this.
> > >
> > >  I'd be willing to put some money on this:
> > >
> > >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b7ad149d62ffffaccb9f565dfe7e5bae739d6836
> > 
> > And I'd lose as you're 32-bit. Oh well, that's the price to pay for 
> > pretending to know x86 arch internals.
> 
> yeah, sorry - we are working hard to unify generic bits like that, but 
> it's a huge architecture.

BTW. I think I'm seeing some problems perhaps related to change page
attr stuff for DEBUG_PAGEALLOC on x86-64. And I don't know if it is the
same thing, but some general instability around either the page allocator
or slab allocator.

The debug pagealloc problems seem to be that a thread suddenly get stuck
in the kernel spinning in cpa (usually on one of the locks) and never
seems to recover. Once it seemed to be spinning in clear_page_... too,
but perhaps could it be messing up the page attributes and running so
slowly that it just appears to be hanging? I'll try to get more info here
but it is hard to reproduce.

The general instability -- I've just seen an oops or two in the page
allocation path in slub recently. Nothing reportable because I've been
running my own patches and/or been unable to reproduce... but it is a bit
unusual and I'll keep an eye out.

Anyway, I'd suggest cooking this kernel a bit longer before release...

