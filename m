Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZDYHQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZDYHQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 03:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZDYHQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 03:16:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58791 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZDYHQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 03:16:37 -0400
Date: Sat, 25 Apr 2009 08:16:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090425071632.GZ8633@ZenIV.linux.org.uk>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu> <20090424135821.GJ8633@ZenIV.linux.org.uk> <20090424221910.GB6403@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424221910.GB6403@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 12:19:10AM +0200, Ingo Molnar wrote:

> As i pointed it out in the first mail: our immediate concern is NFS 
> (nfs_get_sb() in particular), where we can reproduce real and easy 
> deadlocks with BKL-as-a-mutex. So if you could push this patch to 
> Linus (or just not NAK me cherry-picking your precise commit) that 
> would be enough to continue here.

I've no problems whatsoever with either variant.  If Linus is OK with
that for -rc4, there it goes.  However, that's not going to end there,
is it?  We have other methods, after all.  And several series of patches
that'll go near that one.  That's what I'm concerned about; I'm absolutely
fine with cherry-picks of something we can declare stable into any
exprimental trees.  As long as everyone agrees that this commit is in the
final form, that's it.

> Anyway - regarding this commit, doing it via a branch would have 
> been the most Git-ish way to solve it - and that's what i'm using in 
> equivalent situations - but if you rebase your tree often as 
> Christoph Hellwig suggests i can imagine that causing problems.
> 
> In fact, you do seem to have rebased a lot of commits just a couple 
> of days ago:

[snip]

picking the stuff for mainline merge out of it, pushing it to Linus,
reordering the rest and folding a fix into earlier changeset, IIRC.

> So yes, a branch with a stable commit is not possible for you to do. 

It is - I can merge from it into one being cherry-picked to hell and back
just fine.  The question is, how much will end up in that branch?

> Would you mind to describe the workflow that leads to such frequent 
> rebasing? The commit dates are nicely apart:

[snip]

> so these are not commits developed in the same minute as the 
> commit-date suggests. I.e. the whole tree got rebased at Apr 21 
> 17:55.

See above.  And if you'll look at the changeset dates, you'll see that
a lot of those had been done while on LSF2009 and grown fixes and fixes
to fixes since then.  It sat in #untested for a while, then fixes got
folded into patches and some reordering had been done.

It's not that I can't use "here's the branch that only grows" kind of
workflow, but
	a) there's a lot of things many people tend to use quilt for; I'm
using git + bunch of scripts to do the same.
	b) I separate development history from logical progression of patches
and on the short-term scale I'm much more interested in the latter.
	c) I really prefer see as few intertwined branches as possible.
Graph topology should be possible to understand...

I _can_ put out an unchanged branch just fine, and I understand the uses
for such animal.  If I'm willing to say that changeset is in final form -
sure, there it can go.  Useful when it acts as a base for other folks'
work, etc.  But for development work I've no problem whatsoever to do
reordering and folding.  Preferably in batches, but that's it.

IOW, my workflow probably would map on quilt, but I'd started with home-grown
set of scripts around diff+cp -rl+patch and with git I'd been able to do the
same thing even more conveniently.  Plain git is usable that way just fine;
I know about stgit et.al., but I hadn't seen a need for those...

And yes, I've heard Linus' "if you put a branch in public, never reorder it".
Fine, modulo s/public/& and not make it clear that it's not stable that way/.
