Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZDGD4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZDGD4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDGDz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:55:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbZDGDz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:55:58 -0400
Date: Mon, 6 Apr 2009 20:51:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
 updates
In-Reply-To: <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Linus Torvalds wrote:
> 
> I'm not sure this is the tree that brings in the problem, but my wife's 
> Mac Mini won't boot any more, and it looks like some slub or percpu issue, 
> so regardless, roughly the right people are involved in the cc here 
> already.
> 
> I get odd NUL page faults or GP faults in either __kmalloc, 
> __kmalloc_track_caller or kmem_cache_alloc

Hmm. Bisected to Andrew's big chunk of merges on April 1st. Right now I 
have

 - bad: 527410ff7fc5d45fe41523c0ba061113dea22017 ("cirrusfb: GD5446 
   fixes")

 - good: 63cd885426872254e82dac2d9e13ea4f720c21dc ("ntfs: remove private 
   wrapper of endian helpers")

and all the commits in between are all from that same -mm series. Very 
interesting. 

Anyway, the SLUB errors and the per-cpu'ness of the thing seems to have 
been a false lead and irrelevant. 

Andrew, I'll continue to bisect. Looks like it might be the epoll changes 
(that's the only really 'core' thing there). Although I don't understand 
why those would make that Mac Mini unhappy, but not affect the other 
machines. So maybe I should just stop guessing until the bisection ends..

			Linus
