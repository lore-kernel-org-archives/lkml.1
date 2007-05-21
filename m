Return-Path: <linux-kernel-owner+w=401wt.eu-S1765396AbXEUKWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765396AbXEUKWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765710AbXEUKVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:21:04 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:58223
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765053AbXEUKVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:21:01 -0400
Date: Mon, 21 May 2007 03:19:46 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521101946.GC4593@gnuppy.monkey.org>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu> <20070521091848.GB4593@gnuppy.monkey.org> <20070521093639.GA29025@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521093639.GA29025@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 11:36:39AM +0200, Ingo Molnar wrote:
> you got the history wrong i think: the first version of lockdep was 
> released to lkml a year ago (May 2006), while the first time you 
> mentioned your lock contention patch was November 2006 and you released 
> it to lkml in December 2006 - so it was _you_ who was "replicating the 
> same work", not lockdep :-) And this was pointed out to you very early 
> on, many months ago.

Yeah, and where do we disagree here again ? So I take it you're disagreeing
with my agreement with you that lockdep came first ? Geez, think about that
one for a bit. (chuckle) :)

I'd like to remind you that I mapped out the lock hierarchy for a fully
preemptive -rt kernel while you and *others* were wanking around with
voluntary preempt remember ? :) Keep in mind, I'm single obsessed with -rt.

[back to the topic]

> and regarding C99 style lock initializers: the -rt project has been 
> removing a whole heap of them in the past 2.5 years, since Oct 2004 or 
> so, and regularly cleansed the upstream kernel for old-style 
> initializers ever since then - so i'm not sure what you are referring 
> to.

Don't worry about it. I did the same work only to realize that there wasn't
much left to convert over.

> btw., you dont even need CONFIG_DEBUG_INFO to get usable symbol names, 
> CONFIG_KALLSYMS alone will do it too. (It's only if you really cannot 
> tell from the lock symbol name and the function name what the entry is 
> about - which is very rare - that you need to look at any debug-info)

I'm anal about these things. I thought that you can do more magic than that
from your previous email, but it just confirms my understanding of how
symbols work already, unless there was a meltdown of the universal physical
laws here or something. That's why I made the choices I did.

The inode initialization code is ambiguous which is why having a specific
line number was very useful. It showed that one of the locks protecting a
tree was heavily hit. There was multipule places in which it could have
been if I hadn't had this information.

Sleep time...

bill

