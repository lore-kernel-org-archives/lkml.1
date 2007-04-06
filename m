Return-Path: <linux-kernel-owner+w=401wt.eu-S1767481AbXDFB3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767481AbXDFB3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767482AbXDFB3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:29:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767481AbXDFB3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:29:31 -0400
Date: Thu, 5 Apr 2007 18:29:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Snook <csnook@redhat.com>
cc: Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <46159987.6090006@redhat.com>
Message-ID: <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
 <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
 <46159987.6090006@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Apr 2007, Chris Snook wrote:

> Linus Torvalds wrote:
>
> > Another thing we could do is to just make sure that kernel threads simply
> > don't end up as children of init. That whole thing is silly, they're really
> > not children of the user-space init anyway. Comments?
> 
> Does anyone remember why we started doing this in the first place?  I'm sure
> there are some tools that expect a process tree, rather than a forest, and
> making it a forest could make them unhappy.

I'm not sure anybody would really be unhappy with pptr pointing to some 
magic and special task that has pid 0 (which makes it clear to everybody 
that the parent is something special), and that has SIGCHLD set to SIG_IGN 
(which should make the exit case not even go through the zombie phase).

I can't even imagine *how* you'd make a tool unhappy with that, since even 
tools like "ps" (and even more "pstree" won't read all the process states 
atomically, so they invariably will see parent pointers that don't even 
exist any more, because by the time they get to the parent, it has exited 
already.

> The support angel on my shoulder says we should just put all the kernel
> threads under a kthread subtree to shorten init's child list and minimize
> impact.

A number are already there, of course, since they use the kthread 
infrastructure to get there. 

		Linus
