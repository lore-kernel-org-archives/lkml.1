Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYEJQwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYEJQwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 12:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYEJQwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 12:52:40 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:50567 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbYEJQwj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 12:52:39 -0400
Date: Sat, 10 May 2008 17:52:21 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Roland Dreier <rdreier@cisco.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Adrian Bunk <bunk@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GIT bisection range errors
Message-ID: <20080510165220.GA3898@deepthought>
References: <48237CA0.4080001@keyaccess.nl> <20080508222545.GH22887@cs181133002.pp.htv.fi> <48238087.7000509@keyaccess.nl> <20080508225645.GA24725@deepthought> <adave1oqslr.fsf@cisco.com> <20080509211017.GA15926@deepthought> <alpine.LNX.1.00.0805091714050.19665@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0805091714050.19665@iabervon.org>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 05:45:00PM -0400, Daniel Barkalow wrote:
> On Fri, 9 May 2008, Ken Moffat wrote:
> 
> > 
> >  But, surely those of us who bisect against linus' tree only
> > care about the commits which made it into his tree, and in the
> > context of whatever else was in _his_ tree at the time ?
> > 
> >  Maybe I'm under a misapprehension about changesets and merges.  I
> > thought a merge was just pulling in a series of changesets, and that
> > each changeset only contains related items (comment, changed lines,
> > added files, deleted files).
> 
> No, git tracks states and where they came from, not changes per se. That 
> is, when you look at a commit by David Miller, you're looking at exactly 
> the file contents that David Miller had when making the commit. Some other 
> systems linearize history such that what you'd see in Linus's tree is what 
> David Miller would have had if he'd made his changes to the tree Linus had 
> before merging David's branch, but that's not the normal thing to do with 
> git in this case.

 That was the root cause of my misunderstanding - I thought it was
tracking the changes themselves.
> 
> >  Whatever else may be in tree E, I don't expect it to have a commit
> > which changes $EXTRAVERSION, purely because tree E is not Linus'
> > tree.  To me, that field is somewhat special - it indicates where I am
> > (e.g. if bisecting across multiple rcs, or even across multiple
> > releases) and it determines where the modules will go.
> 
> Tree E doesn't change versions; it's got the same version as A. But C and 
> D pick up the version change from B, which means that C and E have 
> different versions. You could also look at it like this: going back from D 
> to F changes the version, not because anybody on the lower path changed 
> it, but because Linus included the version change from his own side when 
> doing the merge.
> 
 OK, I think I understand that now.

> >  I see from Linus' reply to the original mail that this is indeed
> > normal.  That certainly isn't the word I would choose to use : we
> > give things names to describe them and in this case the EXTRAVERSION
> > appears to inhabit a parrallel universe to the pre-existing usage
> > of "2.6.24 good, 2.6.25-rc1 bad".   Colour me more confused than ever.
> 
> 2.6.26-rc1 is bad, 2.6.25 is good, vanilla 2.6.25-rc1 is good, but some 
> modified version of 2.6.25-rc1 was bad. It's like if you take 2.6.25, and 
> you leave the Makefile the same but change some driver. You can find that 
> your 2.6.25 is now broken, while the original 2.6.25 is not. What's going 
> on in this bisect run is that Rene's seeing this same situation, but from 
> the perspective of looking back from the future and looking at somebody 
> else's state.
> 
 Many thanks for taking the time to explain this in detail!

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
