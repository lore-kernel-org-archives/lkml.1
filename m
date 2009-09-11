Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbZIKWky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbZIKWky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZIKWkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:40:53 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11993 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZIKWkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:40:53 -0400
Date: Sat, 12 Sep 2009 00:40:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [GIT PULL] sched/core for v2.6.32
In-Reply-To: <20090911192505.GA20006@elte.hu>
Message-ID: <alpine.LNX.2.00.0909120032270.31018@swampdragon.chaosbits.net>
References: <20090911192505.GA20006@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> Highlights:
> 
>  - Child-runs-first is now off - i.e. we run parent first.
>    [ Warning: this might trigger races in user-space. ]
[...]

Ouch. Do we dare do that?

vfork() is supposed to always run the child first.
Most people I've talked to over the years assume that using fork(), the 
child runs first (yes, I know, that's not guaranteed, but people have come 
to believe that it is so and some may even depend on it).

I must admit that I do not have the understanding of the code needed to 
see why this is done, I'm just scared that this may cause lots of problems 
for userspace programs that (for whatever reason) have come to rely on 
child-runs-first semantics.

I assume there's a very good reason to do this, I'm just not sure we want 
to do it regardless of what (I assume) performance bennefits it brings. 
Will userspace apps really bennefit from this (In the real world, not in 
some fantasy world where everyone reads standards and do things then 
"proper" way)?


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

