Return-Path: <linux-kernel-owner+w=401wt.eu-S934187AbYD3WVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187AbYD3WVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764784AbYD3WUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:20:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765577AbYD3WUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:20:35 -0400
Date: Wed, 30 Apr 2008 15:19:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       mingo@elte.hu
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080430151007.0ace4fa2.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804301513350.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org>
 <4818E7E3.7080705@gmail.com> <20080430151007.0ace4fa2.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Andrew Morton wrote:
> > For busy (or lazy) people like myself, the big problem with linux-next are
> > the frequent merge breakages, when pulling the tree stops with "you are in
> > the middle of a merge conflict".
> 
> Really?  Doesn't Stephen handle all those problems?  It should be a clean
> fetch each time?

It should indeed be a clean fetch, but I wonder if Dmitri perhaps does a 
"git pull" - which will do the fetch, but then try to _merge_ that fetched 
state into whatever the last base Dmitri happened to have.

Dmitry: you cannot just "git pull" on linux-next, because each version of 
linux-next is independent of the next one. What you should do is basically

	# Set this up just once..
	git remote add linux-next git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

and then after that, you keep on just doing

	git fetch linux-next
	git checkout linux-next/master

which will get you the actual objects and check out the state of that 
remote (and then you'll normally never be on a local branch on that tree, 
git will end up using a so-called "detached head" for this).

IOW, you should never need to do any merges, because Stephen did all those 
in linux-next already.

			Linus
