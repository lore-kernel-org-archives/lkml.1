Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbYD3WJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbYD3WJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbYD3WJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:09:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbYD3WJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:09:08 -0400
Date: Wed, 30 Apr 2008 15:08:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, Dan Noe <dpn@isomerica.net>,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200804302330.21743.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0804301439330.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <4818DAC4.0@isomerica.net> <20080430135938.82e46e67.akpm@linux-foundation.org> <200804302330.21743.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Rafael J. Wysocki wrote:
> 
> How bisectable is linux-next, BTW?

Each _individual_ release will be entirely bisectable, since it's all git 
trees, and at no point does anything collapse individual commits together 
like -mm does.

HOWEVER. 

Due to the way linux-next works, each individual release will be basically 
unrelated to the previous one, so it gets a bit more exciting indeed when 
you say "the last linux-next version worked for me, but the current one 
does not".

Git can actually do this - you can make the previous (good) linux-next 
version be one branch, and the not-directly-related next linux-next build 
be another, and then "git bisect" will _technically_ work, but:

 - it will not necessarily be as efficient (because the linux-next trees 
   will have re-done all the merges, so there will be new commits and 
   patterns in between them)

 - but much more distressingly, if the individual git trees that got 
   merged into linux-next were also using rebasing etc, now even all the 
   *base* commits will be different, and saying that the old release was 
   good tells you almost nothing about the new release!

   (The good news is that if only a couple of trees do that, the bisection 
   information from the other trees that don't do it will still be valid 
   and useful and help bisection)

 - also, while it's very easy for somebody who knows and understands git 
   branches, it's technically still quite a bit more challenging than just 
   following a single tree that never rebases (ie mine) and just bisecting 
   within that one.

So yes, git bisect will work in linux-next, and the fundamental nature of 
git-bisect will not change at all, but it's going to be a bit weaker 
"between different versions" of linux-next than it would be for the normal 
git tree that doesn't do the "merge different trees all over again" thing 
that linux-next does.

		Linus
