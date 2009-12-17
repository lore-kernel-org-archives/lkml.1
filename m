Return-Path: <linux-kernel-owner+w=401wt.eu-S935196AbZLQSQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935196AbZLQSQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934997AbZLQSQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:16:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932187AbZLQSQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:16:10 -0500
Date: Thu, 17 Dec 2009 10:16:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2
In-Reply-To: <20091217180319.GB18217@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0912171008220.15740@localhost.localdomain>
References: <20091217162454.GA18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912170831030.15740@localhost.localdomain> <20091217180319.GB18217@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Al Viro wrote:
> 
> OK...  I've edited config a bit, set HEAD to ref: refs/heads/master and
> tried to clean the things up.  What I still don't understand is why the
> hell does it have an apparently unkillable dangling commit that seems
> to be yours, despite having alternates pointing to your tree.  *And*
> a bunch of loose objects sitting around and impossible to get rid of...

Git is _very_ nervous about getting rid of old objects, because even if 
they aren't reachable, you might recover them with "git fsck" etc. By 
default there's something like a 2-month (or maybe just two weeks, I'm too 
lazy to check) expiration logic for objects that are loose and 
unreachable.

You can force git to get rid of those kinds of objects using

	git prune --expire=now

or similar.

[ Btw, things that _look_ unreachable may also be reachable through the 
  reflog, which is not normally something you'd have in a bare repository 
  anyway, but since you created the bare repo by copying/moving a non-bare 
  one, you may well have reflog entries.

  Doing

	git reflog expire --all --expire=now

  should get rid of them, but you could also decide to just do it all the 
  brute-force way with just "rm -rf logs" ]

		Linus
