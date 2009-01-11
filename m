Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbZAKB3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbZAKB3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZAKB3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:29:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37220 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZAKB3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:29:02 -0500
Date: Sun, 11 Jan 2009 02:28:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, sam@ravnborg.org,
       Dave Anderson <anderson@redhat.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
	measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Message-ID: <20090111012811.GG12885@elte.hu>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com> <20090110153446.GA13976@elte.hu> <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mike Snitzer <snitzer@gmail.com> wrote:

> On Sat, Jan 10, 2009 at 10:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Mike Snitzer <snitzer@gmail.com> wrote:
> >
> >> Yes, especially from someone who lacks the ability to properly 
> >> configure kdump.  I'm fairly surprised others are giving you a free 
> >> pass when you keep asserting how broken kdump is with such hollow 
> >> criticism.  I rely heavily on kdump and it works quite well (kvm 
> >> integration was lacking but has improved).
> >
> > hm, you say you rely heavily on kdump ... for what exactly, and how 
> > does it help the upstream Linux kernel?
> >
> > I see a single fix from you in the whole repository:
> >
> >  ffc41cf: nbd: prevent sock_xmit from attempting to use a NULL socket
> >
> > ... and that single fix is a NULL pointer dereference that ought to have
> > been quite debuggable from a plain oops alone.
> 
> I've reported various bugs and helped with prototypes for fixes (e.g. 
> a0da84f3).  But by all means belittle me... must be fun.

I really did not want to belittle you - but in hindsight it really reads 
that way ... sorry about that and how insensitive it was from me! :(

I just wanted to point out that if kdump is useful it must be _visible_. 
Ask commit logs to include "this was debugged via kdump" lines, etc. The 
upstream kernel must feel that it all matters.

The upstream kernel really has to be ruthless about such things and must 
react to how things are not to how things are wished to be - one of the 
most critical things is that keeps Linux ticking is people like you who 
report and debug problems.

Note, back when kdump was added to the kernel many moons ago i strongly 
supported it and helped out with the patches, etc. I still think it might 
have the potential to become big - but it needs a ton of tech and care to 
reach that level of convenience.

'kdump light' perhaps that dumps the most important data structures like 
registers of all CPUs, task struct and the symbol tables, the current task 
itself including the kernel stack plus the surrounding 4K of all pointers 
that are in current registers and that point into kernel memory - maybe 
straight to kerneloops.org [if the user agrees] - or something like that.

	Ingo
