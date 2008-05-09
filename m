Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYEIVKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYEIVKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYEIVKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:10:23 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:32267 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399AbYEIVKW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:10:22 -0400
Date: Fri, 9 May 2008 22:10:17 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GIT bisection range errors
Message-ID: <20080509211017.GA15926@deepthought>
References: <48237CA0.4080001@keyaccess.nl> <20080508222545.GH22887@cs181133002.pp.htv.fi> <48238087.7000509@keyaccess.nl> <20080508225645.GA24725@deepthought> <adave1oqslr.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <adave1oqslr.fsf@cisco.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 04:33:04PM -0700, Roland Dreier wrote:
>  > > $ git checkout -b rc v2.6.26-rc1
>  > > $ git bisect start
>  > > $ git bisect bad
>  > > $ git bisect good v2.6.25
>  > >
>  > > Yet, during this I'm finding myself at 2.6.25-rc6 and 2.6.25-rc8
>  > > as the last two results (both good...).
> 
>  >  I reported a similar thing at the beginning of April
>  > http://lkml.org/lkml/2008/4/2/390 - 2.6.25-rc1 bad, 2.6.24 good, git
>  > dropped me back at 2.6.24-rc4 (again, according to the top level
>  > Makefile).
> 
> This is normal and expected, due to the distributed nature of git and
> the fact that git-bisect operates on the full topology of history and
> not just a linear sequence of commits.
> 
> Imagine history like:
> 
>     A---B---C---D
>      \         /
>       \       /
>        \     /
>         E---F
> 
> where B is good and D is bad.  Now, when you bisect, there is no way to
> know whether, say, E is good or bad and hence the bisect process may
> present E as a tree to try.
> 
> Now, if B is the 2.6.25 release, then since E branched off before B, it
> will have a Makefile that says 2.6.25-rcX.  Which is exactly the
> behavior you are seeing.
> 
> In short, everything looks fine and is behaving as expected.
> 
>  - R.

 But, surely those of us who bisect against linus' tree only
care about the commits which made it into his tree, and in the
context of whatever else was in _his_ tree at the time ?

 Maybe I'm under a misapprehension about changesets and merges.  I
thought a merge was just pulling in a series of changesets, and that
each changeset only contains related items (comment, changed lines,
added files, deleted files).

 Whatever else may be in tree E, I don't expect it to have a commit
which changes $EXTRAVERSION, purely because tree E is not Linus'
tree.  To me, that field is somewhat special - it indicates where I am
(e.g. if bisecting across multiple rcs, or even across multiple
releases) and it determines where the modules will go.

 I see from Linus' reply to the original mail that this is indeed
normal.  That certainly isn't the word I would choose to use : we
give things names to describe them and in this case the EXTRAVERSION
appears to inhabit a parrallel universe to the pre-existing usage
of "2.6.24 good, 2.6.25-rc1 bad".   Colour me more confused than ever.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
