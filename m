Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbXJKHNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbXJKHNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbXJKHNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:13:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325AbXJKHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:13:06 -0400
Date: Thu, 11 Oct 2007 00:13:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Hugh Dickins" <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix printk format strings
Message-Id: <20071011001300.7682a93b.akpm@linux-foundation.org>
In-Reply-To: <19f34abd0710110004k78d103fate87558822fb631a3@mail.gmail.com>
References: <1192085221.26648.31.camel@grianne>
	<20071010235306.c71afe66.akpm@linux-foundation.org>
	<19f34abd0710110004k78d103fate87558822fb631a3@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 09:04:57 +0200 "Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> > > -     printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
> > > -             " free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> > > +     printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n",
> > >               global_page_state(NR_ACTIVE),
> > >               global_page_state(NR_INACTIVE),
> > >               global_page_state(NR_FILE_DIRTY),
> > >               global_page_state(NR_WRITEBACK),
> > > -             global_page_state(NR_UNSTABLE_NFS),
> > > +             global_page_state(NR_UNSTABLE_NFS));
> > > +     printk(" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> > >               global_page_state(NR_FREE_PAGES),
> > >               global_page_state(NR_SLAB_RECLAIMABLE) +
> > >                       global_page_state(NR_SLAB_UNRECLAIMABLE),
> >
> > I don't understand the reason for this change.
> 
> I'm sorry :). It helps to make one line per call only, since this
> allows changing the printk internals for the better by reducing some
> complexity. I believe this is a good thing. I have a patch that
> changes printk, but it assumes that each format string only contains a
> single line. Is this a very bad assumption to make? Or maybe I should
> have sent that change first and made a reference to it?
> 
> But don't you also agree, on the grounds of principle, that a single
> line per call is better style?

Well we do multiple-lines-per-printk in rather a lot of places and it has
two advantages:

- less text size (I expect)

- the printk is "atomic" in that the logically-connected output lines
  won't get tangled up with an intervening printk from another CPU, or from
  an interrupt handler on this CPU.

Those are pretty modest advantages and I guess we could live without them
if we got a significant gain from doing so.  But it'd take quite some
effort hunting down all the callsites, and preventing new ones from
occuring.

