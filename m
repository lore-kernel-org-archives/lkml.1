Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbXIRTtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbXIRTtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbXIRTsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:48:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47583 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039AbXIRTsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:48:51 -0400
Date: Tue, 18 Sep 2007 12:48:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: What can be done to reduce the huge number of build fixes
 required to release an MM tree?
Message-Id: <20070918124819.d16099fc.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0709180523p646024b1u43269816e5328c9f@mail.gmail.com>
References: <a44ae5cd0709180523p646024b1u43269816e5328c9f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 08:23:38 -0400
"Miles Lane" <miles.lane@gmail.com> wrote:

> Hello Andrew and all,
> 
> What can be done to reduce the huge number of build fixes required to
> release an MM tree?

My mind turns to cattle prods.

> Perhaps it would be helpful if you identified specific individuals who
> send you patches that break the build.  If necessary, we could keep a
> running total.  The main thought is that maybe we need to identify who
> regularly sends troublesome patches.  There are three metrics that
> might be good to know:  1) Who sends patches that are regularly
> broken, but sends patches rarely?  2) Who sends patches all the time,
> and once in while causes trouble?  And 3) Who is causing the most
> cumulative trouble?
> 
> Is there any possibility that we ought to refuse patches from people
> who break the build too often?
> 
> Another area that might be helpful might be how the patches break
> things.  Are there major groupings of errors that developers could be
> educated about?
> 
> 
> I am sorry you are having to work so hard to do your job, Andrew.
> 

I don't think much can be done about it, really.

See, what I do is to merge probably hundreds of patches into the -mm-only
part of the tree and then, after a few days, get down and compile-test it
all, then fix it, then runtime test it all, then fix that.  Because it is
vastly more efficient to do all this work against hundreds of patches than
it is to do it against one patch at a time, no?

And guess what?  All the other maintainers do the same thing: someone sends
you a patch, it looks good, so you commit it.  After you've committed a
decent batch of patches, get in there and test it all.

Problem is, I often will get in there and do all that testing before the
subsystem-tree owner has done his testing.

The only way in which my problem can get fixed is if all the subsystem tree
maintainers were to do a full set of compile-testing and runtime testing
before committing each change (impossibly expensive) or if they were to run
two trees: a raw/untested one, and a separate cooked/tested tree.  I then
pull the cooked/tested one.  The latter approach has quite a lot of
overhead for everyone as well.


But really, it's not worth sweating over the build errors: they're almost
always trivial to fix, and they are of course immediately apparent.

So don't worry about the build errors - they're a trivial nuisance.  It's
the runtime errors which are much, much more serious and are much more
expensive to fix and which affect our users much more seriously.

(otoh, quite a number of the build errors are really really silly ones,
where someone couldn't be assed cooking up a decent grep regexp or
didn't even compile-test the change with _any_ config.  I could name
names, but it would look like `grep @ MAINTAINERS' ;))

