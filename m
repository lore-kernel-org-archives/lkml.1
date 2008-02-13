Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbYBMBsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbYBMBsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYBMBsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:48:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365AbYBMBs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:48:28 -0500
Date: Tue, 12 Feb 2008 17:46:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-Id: <20080212174645.09db0e6b.akpm@linux-foundation.org>
In-Reply-To: <20080212.171603.14132226.davem@davemloft.net>
References: <47B1CB08.4020101@garzik.org>
	<20080212.155853.193190548.davem@davemloft.net>
	<20080212163742.c9e778e6.akpm@linux-foundation.org>
	<20080212.171603.14132226.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 17:16:03 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 12 Feb 2008 16:37:42 -0800
> 
> > Well there's a case in point.  rcupdate.h is not a part of networking, and
> > it is random tree-wandering like this which causes me problems and which
> > will cause Stephen problems.
> > 
> > Now, I don't know which tree "owns" rcupdate.h but it ain't networking. 
> > Probably git-sched.
> > 
> > Nothing in networking depends upon that change (which has a typo in the
> > comment, btw) hence it can and should have gone through
> > whichever-tree-owns-that-file.
> > 
> > For Stephen's sake: please.
> 
> At least thie time I did make sure that change got posted to
> linux-kernel and got properly reviewed by the de-facto maintainer
> (Paul McKenney). :-)

Ah, thanks for that - I'm behind in my lkml reading.  Again.

> I'll toss it.

While I was there I spotted a howling bug in rcu_assign_pointer(): a
double-touch of the second arg.  Nobody has done

	rcu_assign_pointer(p, something_with_side_effects);

before?  That would be surpising...

Paul has been informed ;)

> But how do I do that using GIT without rebasing and without
> having this ugly changeset and revert in there?

Who, me?  umm, get git changed?  It seems pretty clear that it isn't
matching legitimate kernel development workflow.  And it is a tool's job to
do that, rather than forcing humans to change there practices.

> That's the thing I want answered, and although Al claims it does,
> git cherry-pick does not seem to do what I want either.
