Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZFKAzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZFKAzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZFKAy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:54:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44891 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbZFKAyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:54:55 -0400
Date: Thu, 11 Jun 2009 02:54:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
Message-ID: <20090611005411.GB24065@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <4A3017D1.5010708@cs.helsinki.fi> <20090610204318.GA8147@elte.hu> <84144f020906101347y3e250f4bme2d1c60dd5993ffc@mail.gmail.com> <20090610205026.GC8147@elte.hu> <20090610205749.GA9321@elte.hu> <4A302075.7060501@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A302075.7060501@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
>
> Ingo Molnar wrote:
>>>>> What kind of conflicts are there against -tip? The diffstat  
>>>>> suggests it's mostly in-SLAB code, right? There shouldnt be much 
>>>>> to conflict, except kmemcheck - which has more or less trivial 
>>>>> callbacks there.
>>>> The conflicting bits are the patches that remove bootmem allocator 
>>>> uses in arch/x86 and kernel/sched.c.
>>> Give me an hour and i'll get some minimal testing done.
>>
>> This tree doesnt conflict (not even with kmecheck) - and the older  
>> bits you sent against the scheduler and against x86 doesnt apply  
>> anymore - but they do look scary.
>
> Btw, yeah, it doesn't conflict because I dropped the problematic patches  
> and did the bootmem fallback instead.
>
> But now you know why I tried to push all this to -tip. Your tree 
> is moving so fast that it's difficult to generate patches that 
> apply to both, -tip and mainline, in this particular area :-).

Hey, i'd agree normally, but the scheduler tree was very quiet in 
this cycle, for a change :-)

The main "problem" here really is the multi-tree impact of such 
broad changes. Those are best kept in a tree like -mm, which goes on 
top of all other trees and is thus basically the only tree that can 
do tree-wide changes.

Anyway, if you rebase to latest -git it should be fine - Linus 
pulled the scheduler and x86 bits.

	Ingo
