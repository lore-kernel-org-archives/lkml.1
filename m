Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbZBMQje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbZBMQje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbZBMQj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:39:26 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33869 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbZBMQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:39:25 -0500
Date: Fri, 13 Feb 2009 11:39:24 -0500
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Junio C Hamano <gitster@pobox.com>,
       L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
Message-ID: <20090213163923.GE15809@csclub.uwaterloo.ca>
References: <1234451714.10603.22.camel@laptop> <20090212192104.GD15809@csclub.uwaterloo.ca> <1234477025.10603.38.camel@laptop> <200902131034.05814.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902131034.05814.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 10:34:05AM +0100, Ingo Oeser wrote:
> On Thursday 12 February 2009, Peter Zijlstra wrote:
> > > foobar patch 0 (usually a summary/overview)
> > > +-foobar patch 1
> > > +-foobar patch 2
> > > +-foobar patch 3
> > > +-foobar patch 4
> > > +-foobar patch 5
> > > 
> > > is much nicer than
> > > 
> > > foobar patch 0
> > > +-foobar patch 1
> > >   +-foobar patch 2
> > >     +-foobar patch 3
> > >       +-foobar patch 4
> > >         +-foobar patch 5
> > > 
> > > which seems to be what git does itself.
> > 
> > Which happens to be exactly what my suggestion would accomplish.
> 
> Ok, then I take back my reservations and support this idea.
> 
> Lennart: Thanks for visualizing what Peter meant :-)

Just in case anyone cares here are some statistics.  I grabbed lkml
traffic from early january to early feburary, and looked at all the
multi message patches and split them into the 3 categories split,
shallow and deep.  That means:

  Split: (multiple seperate threads)
  foobar patch 1
  +-comment on patch 1
  foobar patch 2
  foobar patch 3
  +-comment on patch 3
  foobar patch 4
  foobar patch 5

  Shallow: (A tree of patches, with all patches linked from a single start message)
  foobar patch 0 (usually a summary/overview)
  +-foobar patch 1
  | +-comment on patch 1
  +-foobar patch 2
  +-foobar patch 3
  | +-comment on patch 3
  +-foobar patch 4
  +-foobar patch 5

  Deep: (One long chain of patches)
  foobar patch 0
  +-foobar patch 1
    +-foobar patch 2
    | +-foobar patch 3
    |   +-foobar patch 4
    |   | +-foobar patch 5
    |   +-comment on patch 3
    +-comment on patch 1

So the results were that people had used:
Split: 25 patch sets.
Shallow: 56 patch sets.
Deep: 6 patch sets.

It certainly looks like the shallow threaded mode is by far the most
prefered style by kernel developers, and should perhaps be the default
in GIT, especially given it makes it harder to follow the thread (later
patches are seen before comments on a patch, and the thread gets very
wide on the screen.  I suspect almost all if not all of the users of the
default deep method, do it because its the default and not by choice.  I
doubt whoever implemented the feature in git had even though about what
would happen when someone did a 50 part patch set that way.  It may even
be that some people use the split style because they don't like the deep
style and git doesn't support doing the shalow style that most people
prefer.

Fortunately the people responsible for posting the largest patch sets
(such as stable reviews and the like) are doing it with shallow stule
already, however they manage to do that.  Yay!

Oh well, back to doing actual useful work again...

-- 
Len Sorensen
