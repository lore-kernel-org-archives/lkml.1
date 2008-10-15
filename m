Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYJOWyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYJOWyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYJOWyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:54:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbYJOWyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:54:08 -0400
Date: Wed, 15 Oct 2008 15:53:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: is the weeks before -rc1 the time to really be working on
 -next?
Message-Id: <20081015155353.f15a996e.akpm@linux-foundation.org>
In-Reply-To: <20081015233607.54c1d6b8@lxorguk.ukuu.org.uk>
References: <20081015174015.GB8663@kroah.com>
	<20081015145606.2af3baf1.akpm@linux-foundation.org>
	<20081015233607.54c1d6b8@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 23:36:07 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > first.  So everyone who has been changing stuff which is outside their
> > area of responsibility and breaking other people's stuff would get to
> > see the consequences of their actions instead of Stephen and I bearing
> > the brunt of it all the time.
> > 
> > 
> > I fear we've reached the stage now where people are merrily merging
> > bright-and-shiny things into their local trees without giving much
> > thought at all to the consequences for others.
> 
> Its not that simple. There are areas where the tree divides don't fit the
> coding divides. ttydev was horribly entwined with USB and there really
> wasn't a way to break that up at the time in question. Because -next
> tries to assemble all the trees based on Linus tree it can't cope with
> that case well at all and in fact there was some neccessary rule bending
> to make next work out where some of the ttydev work was done with ttydev
> on top of other subtrees.

Yes, sometimes there are nasty special cases and I of course understand
that and I did allow for it in making that assertion.  There's quite a
lot of gratuitous lazy stuff happening too.

> So at times it would be very helpful with -next to be able to do limited
> tree ordering. If I could have flagged tty as requiring USB first for
> example there would have been a lot less pain involved.

Well there's an alternative here: you base the ttydev tree on top of
linux-next.  That way we spread the load around a bit.

But the problem here is that once linux-next merges your patches, you
no longer have a tree on which to base your patches!  You need to get
your hands on "linux-next without my stuff" to maintain them.


I'm in the same situation with -mm and I do have a scheme planned for
that, but it'll involve asking Stephen to add a "mm starts here" tag,
so I can extract "linux-next without my stuff".  (I still haven't got
around to making this happen - I've become a fulltime reject fixer).


But the problem with that scheme is that it'd be hard to generalise for
other trees.  Or maybe not - we can just say "Alan goes first, then
-mm".  Then you piggyback on top of the infrastructure which I use.


Then again, the ttydev problem was hopefully a once-off, so we don't
need to do anything now.

