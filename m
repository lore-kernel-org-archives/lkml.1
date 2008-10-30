Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYJ3V7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYJ3V7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYJ3V7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:59:41 -0400
Received: from kroah.org ([198.145.64.141]:34628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751984AbYJ3V7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:59:40 -0400
Date: Thu, 30 Oct 2008 14:57:34 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: merging other repos into linux-2.6
Message-ID: <20081030215734.GA18822@kroah.com>
References: <20081030054944.GA19035@kroah.com> <alpine.LFD.2.00.0810301152230.3505@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810301152230.3505@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:04:34PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 29 Oct 2008, Greg KH wrote:
> > 
> > In working with some of the current out-of-tree drivers, some of them
> > are asking if they could keep their past development history when
> > merging the code into the main kernel tree.
> > 
> > Now normally we don't do this for new drivers, just dropping them in in
> > one big patch, or sometimes multiple patches to get it through email
> > filters.
> 
> I'd suggest you talk to Chris Mason about his btrfs import.
> 
> I'd _like_ for old history to be merged, but quite frankly, bisectability 
> is a fairly big deal, and while we often have cases where a _few_ commits 
> don't build and make bisecting hard, if you import the past development 
> history badly, you can easily end up with _hundreds_ of commits that 
> simply don't build as a kernel at all.
> 
> And at some point the "nice to have" history is suddenly "more pain than 
> it is worth".
> 
> > The comedi group (data acquisition subsystem for Linux) have their whole
> > history going back to 2000 in a git tree (well, a cvs->git repo.)
> > 
> > I was wondering if it would be acceptable to graft their tree into the
> > linux-2.6 tree (after moving the files to the proper location) to keep
> > their whole old history alive.
> 
> If you mean "graft" in the git technical sense, where you actually use a 
> grafts file to fake ancestry, then the answer is "Hell no".
> 
> If you mean "graft" in the sense of merging a unrelated tree, the same way 
> git itself merged the gitk tree, then the answer is "yes, we can do that, 
> but bisectability is really important".

I ment the later, like what you did with the gitk tree and the git repo.

> And quite frankly, if you don't spend time looking at it and doing it 
> well, it's probably not worth doing at all. Are you ready to really try to 
> do a good job?
> 
> That's why I'd suggest you talk to Chris - because he did an import from 
> an external mercurial repo that wasn't even a full kernel, and with some 
> help from me got a really good history in his git tree by using a number 
> of tricks, notably using "git filter-branch" to create a new tree with the 
> whole history as part of a whole tree, and nicely bisectable too.
> 
> (See the result at
> 
> 	http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary
> 
> if you want to).

Thanks, I'll take a look at this.

But as for the 'bisectability' at one point in the merge, you will be
adding a stand-alone driver into the kernel itself.  So for anyone
traversing down that path, all you would be building would be the driver
itself, the whole rest of the kernel is "gone".  So, keeping the ability
for those points along the stand-alone driver might be nice, I can see
this confusing the heck out of people who would wonder where in the
world the kernel went away to.

> Anyway, I'll happily help with any cleanup and/or git questions, but Chris 
> can talk about the issues he had - he did all the actual work.
> 
> In contrast, if what you just want to do is to take some nasty straight 
> CVS import, and just do a git merge, and not try to make it bisect sanely, 
> at that point I'd say that the history is absolutely _not_ worth it.

Fair enough, I'll play around with the comedi git tree, look at what
Chris did with btrfs, and then see if it's even worth it.

thanks for your comments,

greg k-h
