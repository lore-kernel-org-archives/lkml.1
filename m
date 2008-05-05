Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbYEEXqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbYEEXqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYEEXqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:46:04 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34797 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484AbYEEXqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:46:02 -0400
Date: Mon, 5 May 2008 19:45:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
	(was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505234515.GB8357@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	"Randy.Dunlap" <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
	Adrian Bunk <bunk@kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Alexander Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu> <Pine.LNX.4.64.0805051327530.27703@shark.he.net> <20080505145132.58df7e70@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505145132.58df7e70@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 02:51:32PM -0700, Arjan van de Ven wrote:
> can we do a "make patchcheck" kernel build target that would
> * run checkpatch on teh patch
> * build the kernel without the patch (in various .configs, probably
> allyesconfig / allmodconfig is enough, but we can figure this out
> later)
> * apply the patch
> * build the kernel in the same configs
> * build a kernel for install that has the 'standard debug options' on
>   (lockdep, slabpoison etc)
> then we can
> * compare if new gcc warnings got introduced
> * compare if major stack usage got introduced
> * compare if namespace_check and some of the others introduce new issues
> * compare if new sparse warnings got introduced
> and maybe even run a bloat-o-meter to show code growth/shrinkage
> [insert other useful checks here]
> 
> if all of that is just one command away, I bet quite a few people would
> use it
> (and the more useful it gets the more people will use it)

I'm not sure we could do it for every single patch (because of the
time it would take), but how about automating it so that for every
single tree which is getting pushed to linux-next, we have a build
tree which automatically builds "origin..next" (i.e., the set of
commits that are being proposed for pushing into mainline), comparing
whether the current set of changes being proposed for pushing to
mainline, for each tree.   

Ideally the maintainer would do this himself before nominating the set
of patches to linux-next, but if not, if someone were interested in
doing this work automatically, and then sending the results to the
developer and cc'ed to LKML as a service, it would probably serve a
useful "gentle nudge" towards doing the right thing.  :-)

       	       	      	      	    	      - Ted
