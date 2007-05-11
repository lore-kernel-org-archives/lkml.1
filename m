Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXEKXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXEKXGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbXEKXGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:06:01 -0400
Received: from mail.fieldses.org ([66.93.2.214]:33467 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbXEKXGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:06:00 -0400
Date: Fri, 11 May 2007 19:05:59 -0400
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: Git Mailing List <git@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: -mm git tree
Message-ID: <20070511230559.GA29981@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The git tree at

	git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git

could be set up in a simpler way:

$ git ls-remote git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git
fc4b5be9e651d3e71b54541e0315fc82211b42b5	refs/heads/option_export
59a1fe35614c3c937a4e8cb6e4a45f1d05544d9d	refs/heads/v2.6.13-mm1
e3602088f81f66655ec6c62320d5c56839ffc02b	refs/heads/v2.6.13-mm2
...
05230bd16821e2ec80321d72e97e7a2b1a07c6f2	refs/tags/master
...
5e1302f173f63c5c57c5de8b44152c30ae2a72c4	refs/tags/v2.6.13-mm1
59a1fe35614c3c937a4e8cb6e4a45f1d05544d9d	refs/tags/v2.6.13-mm1^{}
a06c5a7b36cfb30345a9476cbaff02955483c4ca	refs/tags/v2.6.13-mm2
e3602088f81f66655ec6c62320d5c56839ffc02b	refs/tags/v2.6.13-mm2^{}
...

Would it be possible to remove the branches that exist for each
individual version, and to change the "master" tag to a branch?

Since git gives tag names priority over head names, fetching the above
tag makes "master" refer to it instead of any local branch named
"master".

(I get particularly bizarre behavior with current git; after:

	git remote add mm git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git
	git fetch mm

when I check out "master", it sets HEAD to refs/heads/master, but the
index and working tree to refs/tags/master.)

I think it may have been set up this way with the idea that a branch
should only ever move "forward" in history, whereas tags could move
around freely.

But that's not really right--for something like -mm that's continually
rewritten and rebased, it makes sense to have a "master" branch that
skips around.  The default git-remote setup on recent git is prepared to
deal with this.

And having a repository with 101 branches and counting, none of which
every change, is awkward--if nothing else it makes the output of
"git-branch -r" a little hard to read.

--b.
