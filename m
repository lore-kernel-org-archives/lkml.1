Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118Ab0AYUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0AYUnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030Ab0AYUnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:43:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029Ab0AYUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:43:14 -0500
Date: Mon, 25 Jan 2010 12:42:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Wielaard <mjw@redhat.com>
cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       utrace-devel@redhat.com
Subject: Re: linux-next: add utrace tree
In-Reply-To: <1264451453.3028.59.camel@springer.wildebeest.org>
Message-ID: <alpine.LFD.2.00.1001251236160.3574@localhost.localdomain>
References: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>  <20100122221348.GA4263@redhat.com>  <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>  <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> 
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>  <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com>  <20100123194820.GM21263@thunk.org>  <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com> 
 <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>  <20100125170254.GB22862@redhat.com>  <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain> <1264451453.3028.59.camel@springer.wildebeest.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jan 2010, Mark Wielaard wrote:
> 
> And all these users have wishes to extend the current ptrace interface
> mess. But nobody dares to extend ptrace in any direction because
> fixing/cleaning up one of these use cases might break the others in
> subtle and not so subtle ways. Which is why the utrace series of patches
> is cleaning up all this stuff first.

I call bullshit.

You can clean up ptrace without introducing odd new interfaces and trying 
to sell it as some revolutionary new kernel interface that can do 
anything.

I also call bullshit on the "ptrace() is so horribly nasty" argument. Yes, 
I've seen the code that uses ptrace in user space, and yes, it's nasty, 
but it's invariably _not_ nasty so much because ptrace itself is nasty, 
but because it's full of #ifdef so-and-so-os/so-and-so-arch, and the code 
is never cleaned up.

There are a couple of obvious cases of ptrace being uglier-than-it-needs- 
to-be. Like the traditional ptrace read/write interface being purely "word 
at a time", and that clearly is not pretty. Several architectures already 
do "copy range" kind of versions on it, though, so that's just a detail, 
and if anybody wanted to clean it up, they could have.

The more fundamental problem is the use of signals (while at the same time 
wanting to _trap_ non-ptrace signals), without any model for a "connection 
state", which is why you can have only one tracer. But again, that's 
largely a user interface issue, and apparently utrace does _nothing_ for 
that problem at all.

So I do agree that ptrace is not a great interface. However: repeating 
that statement over and over in _no_ way excuses some totally unrelated 
code that doesn't have anything what-so-ever to do with the actual 
problems of ptrace.

		Linus
