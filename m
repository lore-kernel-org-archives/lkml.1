Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbYBMEwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbYBMEwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYBMEwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:52:39 -0500
Received: from mail.fieldses.org ([66.93.2.214]:45121 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbYBMEwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:52:37 -0500
Date: Tue, 12 Feb 2008 23:52:19 -0500
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, jeff@garzik.org, arjan@infradead.org,
       greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213045219.GC9766@fieldses.org>
References: <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org> <20080212.172051.58554658.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.172051.58554658.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 05:20:51PM -0800, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 12 Feb 2008 16:44:47 -0800 (PST)
> 
> > 	gitk --merge
>  ...
> > This is something where I actually think git could and should do better: 
> > git has the capability to act as more of a "quilt replacement", but 
> > because it wasn't part of the original design, we never actualy exposed 
> > the simple queue management commands to do this (stgit does things like 
> > that, though).
> > 
> > So if you haven't pushed out, right now you'd have to do this stupid 
> > thing:
> 
> Thanks for all the useful info.
> 
> But as soon as I've applied any patches to my tree I've "pushed out".
> So this scheme doesn't work for me.  The first thing I do when I have
> changes to apply is clone a tree locally and on master.kernel.org,
> then I apply that first patch locally and push it out to master.
> 
> What would be really cool is if you could do the rebase thing, push
> that to a remote tree you were already pushing into and others could
> pull from that and all the right things happen.
> 
> A rebase is just a series of events, and those could propagate to
> people who are pulling from the tree.  I'm pretty sure GIT could
> support this.

	git checkout -b new-tree old-tree
	# hack on new-tree: rebase, drop bad commits, whatever
	git merge -s ours old-tree
	git push your-public-repo new-tree:public-tree

Now public-tree has a merge commit on the top with two parents,
public-tree^1 and public-tree^2.  public-tree^1 is the tip of the new
cleaned-up history, and public-tree^2 points to the old stuff.

I sometimes use that privately as a way to keep track of the history of
a patch-series, but I assume Linus would shoot anyone that tried to
submit such a monstrosity upstream....

--b.
