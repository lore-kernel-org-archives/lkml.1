Return-Path: <linux-kernel-owner+w=401wt.eu-S936530AbZLQSj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936530AbZLQSj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935665AbZLQSjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:39:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47096 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935588AbZLQSjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:39:53 -0500
Date: Thu, 17 Dec 2009 18:39:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2
Message-ID: <20091217183952.GC18217@ZenIV.linux.org.uk>
References: <20091217162454.GA18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912170831030.15740@localhost.localdomain> <20091217180319.GB18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912171008220.15740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912171008220.15740@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:16:08AM -0800, Linus Torvalds wrote:

> You can force git to get rid of those kinds of objects using
> 
> 	git prune --expire=now
> 
> or similar.
> 
> [ Btw, things that _look_ unreachable may also be reachable through the 
>   reflog, which is not normally something you'd have in a bare repository 
>   anyway, but since you created the bare repo by copying/moving a non-bare 
>   one, you may well have reflog entries.
> 
>   Doing
> 
> 	git reflog expire --all --expire=now
> 
>   should get rid of them, but you could also decide to just do it all the 
>   brute-force way with just "rm -rf logs" ]

reflog had been pruned already; still no effect.  Moreover, after looking
through the loose objects, I've found several commits that are definitely
reachable from master and now from your tree as well.  E.g.
objects/ea/ff8079d4f1016a12e34ab323737314f24127dd
is one of those - it's a commit and it's both in mainline *and* happens
to be tip of master.  No questions about being unreachable and AFAICS
no reasons whatsoever to leave it as a loose object...
