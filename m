Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbYB2Qpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbYB2Qpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYB2Qpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:45:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39449 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbYB2Qpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:45:30 -0500
Date: Fri, 29 Feb 2008 17:45:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
Message-ID: <20080229164510.GA6850@elte.hu>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080229155207.GC27248@elte.hu> <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > > The code to restart syscalls after signals depends on checking for a 
> > > negative orig_ax, and for particular negative -ERESTART* values in ax. 
> > > These fields are 64 bits and for a 32-bit task they get zero-extended. 
> > > The syscall restart behavior is lost, a regression from a native 
> > > 32-bit kernel and from 64-bit tasks' behavior.  This patch fixes the 
> > > problem by doing sign-extension where it matters.  For orig_ax, the 
> > > only time the value should be -1 but winds up as 0x0ffffffff is via a 
> > > 32-bit ptrace call.  So the patch changes ptrace to sign-extend the 
> > > 32-bit orig_eax value when it's stored; it doesn't change the checks 
> > > on orig_ax, though it uses the new current_syscall() inline to better 
> > > document the subtle importance of the used of signedness there.  The 
> > > ax value is stored a lot of ways and it seems hard to get them all 
> > > sign-extended at their origins.  So for that, we use the 
> > > current_syscall_ret() to sign-extend it only for 32-bit tasks at the 
> > > time of the -ERESTART* comparisons.
> > 
> > thanks, applied.
> 
> Btw, can we please try to keep commit log messages readable?

yeah - the minute i added the patch i pinged Roland about that offline.

> Yeah, maybe it's just me, but I like my whitespace. 
> Ihaveareallyhardtime 
> readingtextthatdoesn'thavethepropermarkersforwhereconceptsstartandbegin, 
> andthatreallydoesincludetheverticalwhitespacetoo.

heh :)

> Now, the only reason I mention this is that normally I would probably 
> just have fixed this up myself without even a comment (because it's 
> such a tiny detail that it's not not worth one), but when Ingo merges 
> it I'll now get it through git and it will be fixed.

currently the reality is that i have to fix over 90% of the commit 
messages that go towards you :-/

While i'd like that proportion to be a lot lower, it's really hard for 
people to write good commit messages for fixes: people tend to send 
their fixes the minute they find the problem (being happy about having 
found and fixed a problem!), so the commit message gets little 
attention.

another effect is that kernel generalist people like Roland have a very 
large list of todo items so when they write up the commit message they 
might be thinking about the next unsolved problem already - and the 
commit message becomes a quick, unstructured and semi-automatic 
brain-dump of all details in essence :-/

Also, who am i to complain about the commit message - i'm often the one 
who has put the bug in to begin with! [ So i'm perfectly happy with you 
volunteering to take over that role ;-) ]

But yes, it's easier for me too to sort and prioritize patches if their 
description has good structure, so i regularly try to remind high-volume 
patch submitters about that. ( With little success i have to say - 
commit messages seem to be suffering from the same curse of inattention 
as other types of documentation do :-/ )

	Ingo
