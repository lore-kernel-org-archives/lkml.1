Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYKHS3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYKHS3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYKHS2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:28:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbYKHS2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:28:51 -0500
Date: Sat, 8 Nov 2008 10:28:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
In-Reply-To: <20081108170224.GA553@elte.hu>
Message-ID: <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org>
References: <20081108170224.GA553@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Nov 2008, Ingo Molnar wrote:
>
> Ingo Molnar (2):
>       sched: improve sched_clock() performance
>       sched: optimize sched_clock() a bit

Btw, why do we do that _idiotic_ rdtsc_barrier() AT ALL?

No sane user can possibly want it. If you do 'rdtsc', there's nothing you 
can do about a few cycles difference due to OoO _anyway_. Adding barriers 
is entirely meaningless - it's not going to make the return value mean 
anything else.

Can we please just remove that idiocy? Or can somebody give a _sane_ 
argument for it?

		Linus
