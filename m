Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbYBLGRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbYBLGRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYBLGRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:17:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbYBLGRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:17:37 -0500
Date: Mon, 11 Feb 2008 22:15:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080211221535.bc0dc9cf.akpm@linux-foundation.org>
In-Reply-To: <20080212051136.GA12802@mit.edu>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080212042133.GA4625@kroah.com>
	<20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<1202791555.20739.6.camel@heimdal.trondhjem.org>
	<20080212051136.GA12802@mit.edu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 00:11:36 -0500 Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Feb 11, 2008 at 11:45:55PM -0500, Trond Myklebust wrote:
> > It would be very nice to have a separate tree with _only_ API changes
> > that could be frozen well before Linus' merge window opens. It should be
> > a requirement that maintainers use this tree as a basis for testing API
> > changes and even test that their own changesets were properly integrated
> > with the changed APIs.
> 
> The other way that might work in some circumstances would be if we
> tried a little harder to avoid API changes that don't involve an
> interface naming change.  That is, instead of adding a new parameter
> to a function, and then having to sweep through all of the trees to
> catch all of the users of siad function, we could instead add a new a
> new interface, __deprecate the old one, and then give enough time for
> trees to adapt, you can avoid needing to do flag day transitions.

yup, in many cases that's pretty easy to do.  But people dive straight
for the end result, which of course provides the cleanest outcome but
isn't really very real-wordly.

Another thing we could do when these things happen is all gang up on Linus
and ask him to merge the API change into mainline.  Because often the
change can be done in two stages: 1) change the interface then 2) add the code
in the callee which _uses_ that changed interface.  Part 1 is an obviously-safe
do-nothing change and fixes the merge problems.  Part 2 is at a single site
and can be merged in 2.6.x+1.

There are lots of well-known things we can do to simplify Stephen's life. 
But first we have to have the motivation to do that thing.  If linux-next
proves to be useful and developers are seeing good testing and
bug-reporting coming out of it then I expect people will be happy to make
such accommodations.  Let's see if we can get to that stage first.


A fully running and successful linux-next won't change outcomes a lot, I
expect.  It will help to pick up on obvious bugs and build errors and
bisection breakages prior to them hitting mainline.  But we fix those
things by -rc1 or -rc2 anyway.  So it's just a time-shift, causing no great
change in the final 2.6.x.

linux-next will do little to solve our (IMO) largest problem: unfixed
regressions and bugs.  otoh it will free up a lot of my time and
hair-tearing, so I can devote more attention to the bugs.  (where
"attention" usually= "sending irritiating emails")

