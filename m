Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbZDXN6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbZDXN6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZDXN6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:58:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45142 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbZDXN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:58:29 -0400
Date: Fri, 24 Apr 2009 14:58:21 +0100
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
Message-ID: <20090424135821.GJ8633@ZenIV.linux.org.uk>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424080634.GG24912@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 10:06:34AM +0200, Ingo Molnar wrote:

> You've not replied to my request (attached below) to put these 
> trivial BKL-pushdown bits into a separate branch/tree and not into 
> the VFS tree. You've now mixed that commit with other VFS changes.
> 
> Had it been in a separate branch, and had we tested it, Linus could 
> have pulled the trivial BKL pushdown bits out of normal merge order 
> as well. That is not possible now.
> 
> Furthermore, by doing this you are also hindering the 
> tip:kill-the-BKL effort (which has been ongoing for a year chipping 
> away at various BKL details) which facilitated these changes. 
> Alessio did these fixes to fix bugs he can trigger in that tree.
> 
> You've also not explained why you have done it this way. It would 
> cost you almost nothing to apply these bits into a separate branch 
> and merge that branch into your main tree. Lots of other maintainer 
> are doing that.
> 
> So if you've done this by mistake, i'd like to ask you to reconsider 
> and put these bits into a separate, stable-commit-ID branch. If 
> you've done this intentionally, i'd like you to explain the reasons 
> for it, instead of just doing it silently without explanation.
> 
> Anwyay, if there's no resolution, i'll apply Alessio's fixes with a 
> different commit ID, to not hold up the rather useful work that is 
> going on in the kill-the-BKL tree. Later on i'll have to rebase that 
> portion of the tree to avoid duplicate commit IDs. I just wanted to 
> put it on the record why i have to do that rebase.


Good grief...  You have the commit ID, git fetch + git-cherry-pick would
take two lines to type instead of more than a screenful.

This patch is certainly trivial enough to go into the mainline at any point.
Including "right now".  However, the stuff to follow it might get more
convoluted and I wouldn't argue for pushing it before the next merge window.
It's not just the "push BKL down there" - that I could simply do right
now and ACK pushing it to Linus/push myself.  Unless I'm mistaken, you
want to pull the subsequent "remove BKL in foofs" bits as well and those
are almost certainly going to get entangled with other stuff.

I'm not particulary against a separate branch for all that stuff (including
the remount changes that'll be needed, etc.).  The question is, what merge
time are you aiming for and how much VFS stuff are you willing to tolerate
in that branch?

Details, please...
