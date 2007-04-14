Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXDNHUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXDNHUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 03:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161143AbXDNHUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 03:20:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50936 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139AbXDNHUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 03:20:40 -0400
Date: Sat, 14 Apr 2007 00:21:06 -0700
From: Greg KH <greg@kroah.com>
To: Junio C Hamano <junkio@cox.net>
Cc: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Subject: Re: GIT and the current -stable
Message-ID: <20070414072106.GA6344@kroah.com>
References: <46206842.80203@gmail.com> <7vfy73bhik.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vfy73bhik.fsf@assigned-by-dhcp.cox.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 11:24:19PM -0700, Junio C Hamano wrote:
> Rene Herman <rene.herman@gmail.com> writes:
> 
> > Stumbling around with git here. I'd like to use git to efficiently
> > track the current -stable as well as -current. Say, my local tree is a
> > clone of Linus current:
> >
> > git clone \
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > local
> >
> > I then branch off a 2.6.20 branch:
> >
> > cd local
> > git checkout -b v2.6.20 v2.6.20
> >
> > to now update to the current -stable I could do:
> >
> > git pull \
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
> 
> I think adding these lines to .git/config would do the trick,
> after you have done the "checkout -b v2.6.20 v2.6.20" step:
> 
> [branch "v2.6.20"]
> 	remote = stable
> 	merge = refs/heads/master
> [remote "stable"]
> 	url = git://git.kernel.org/.../stable/linux-2.6.20.y.git
> 	fetch = refs/heads/master
> 
> provided if stable team forks v2.6.20.y history off of Linus's
> v2.6.20.

Yes, we do branch off Linus's tree for each of the different .y
releases.

Some people have asked us to keep all of the different .y branches in
the same git tree, but for now we have been using different repositories
on kernel.org to keep things simpler for the majority of people who do
not fully understand how to use the branching features of git (myself
included in that category at times, I've messed up merging to different
branches too many times...)

> With the above configuration, anytime you say "git pull" while
> on your v2.6.20 branch will fetch from "stable" and merge their
> 'master' branch in your current branch (i.e. v2.6.20 branch).

That's really cool, thanks for pointing out how to do it.

thanks,

greg k-h
