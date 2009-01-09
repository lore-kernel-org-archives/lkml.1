Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZAIRGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZAIRGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZAIRGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:06:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52249 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZAIRGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:06:02 -0500
Date: Fri, 9 Jan 2009 18:20:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dirk Hohndel <hohndel@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       jim owens <jowens@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Message-ID: <20090109172011.GD26290@one.firstfloor.org>
References: <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109084620.3c711aad@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 08:46:20AM -0800, Dirk Hohndel wrote:
> On Fri, 09 Jan 2009 08:34:57 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> > 
> > As far as naming is concerned, gcc effectively supports four levels,
> > which *currently* map onto macros as follows:
> > 
> > __always_inline		Inline unconditionally
> > inline			Inlining hint
> > <nothing>		Standard heuristics
> > noinline		Uninline unconditionally
> > 
> > A lot of noise is being made about the naming of the levels (and I
> > personally believe we should have a different annotation for "inline
> > unconditionally for correctness" and "inline unconditionally for
> > performance", as a documentation issue), but those are the four we
> > get.
> 
> Does gcc actually follow the "promise"? If that's the case (and if it's
> considered a bug when it doesn't), then we can get what Linus wants by
> annotating EVERY function with either __always_inline or noinline.

There's also one alternative: gcc's inlining algorithms are extensibly
tunable with --param. We might be able to find a set of numbers that
make it roughly work like we want it by default.

Disadvantage: the whole thing will be compiler version
dependent so we might need to have different numbers
for different compiler versions and it will be an 
area that will need constant maintenance in the future.

I'm not sure that's really a good path to walk down to.

Also cc Honza in case he has comments (you might want
to review more of the thread in the archives) 

-Andi

-- 
ak@linux.intel.com
