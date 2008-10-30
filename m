Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYJ3TEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYJ3TEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYJ3TEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:04:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbYJ3TEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:04:37 -0400
Date: Thu, 30 Oct 2008 12:04:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: merging other repos into linux-2.6
In-Reply-To: <20081030054944.GA19035@kroah.com>
Message-ID: <alpine.LFD.2.00.0810301152230.3505@nehalem.linux-foundation.org>
References: <20081030054944.GA19035@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Oct 2008, Greg KH wrote:
> 
> In working with some of the current out-of-tree drivers, some of them
> are asking if they could keep their past development history when
> merging the code into the main kernel tree.
> 
> Now normally we don't do this for new drivers, just dropping them in in
> one big patch, or sometimes multiple patches to get it through email
> filters.

I'd suggest you talk to Chris Mason about his btrfs import.

I'd _like_ for old history to be merged, but quite frankly, bisectability 
is a fairly big deal, and while we often have cases where a _few_ commits 
don't build and make bisecting hard, if you import the past development 
history badly, you can easily end up with _hundreds_ of commits that 
simply don't build as a kernel at all.

And at some point the "nice to have" history is suddenly "more pain than 
it is worth".

> The comedi group (data acquisition subsystem for Linux) have their whole
> history going back to 2000 in a git tree (well, a cvs->git repo.)
> 
> I was wondering if it would be acceptable to graft their tree into the
> linux-2.6 tree (after moving the files to the proper location) to keep
> their whole old history alive.

If you mean "graft" in the git technical sense, where you actually use a 
grafts file to fake ancestry, then the answer is "Hell no".

If you mean "graft" in the sense of merging a unrelated tree, the same way 
git itself merged the gitk tree, then the answer is "yes, we can do that, 
but bisectability is really important".

And quite frankly, if you don't spend time looking at it and doing it 
well, it's probably not worth doing at all. Are you ready to really try to 
do a good job?

That's why I'd suggest you talk to Chris - because he did an import from 
an external mercurial repo that wasn't even a full kernel, and with some 
help from me got a really good history in his git tree by using a number 
of tricks, notably using "git filter-branch" to create a new tree with the 
whole history as part of a whole tree, and nicely bisectable too.

(See the result at

	http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary

if you want to).

Anyway, I'll happily help with any cleanup and/or git questions, but Chris 
can talk about the issues he had - he did all the actual work.

In contrast, if what you just want to do is to take some nasty straight 
CVS import, and just do a git merge, and not try to make it bisect sanely, 
at that point I'd say that the history is absolutely _not_ worth it.

			Linus
