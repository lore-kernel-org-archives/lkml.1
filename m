Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZAMSNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZAMSNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZAMSNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:13:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53731 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZAMSNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:13:16 -0500
Date: Tue, 13 Jan 2009 19:12:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Message-ID: <20090113181222.GA24910@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 13 Jan 2009, Peter Zijlstra wrote:
> > 
> > Ok, tested only 1, but that was the one I remember lockups from -- and
> > that seems to be good with the cmpxchg.
> > 
> > Do you fancy me sending v10 or will you make that change locally?
> 
> I'd like to get this in, but I'm not going to apply it in any case 
> without way more testing.
> 
> It missed the merge window, but I'm potentially willing to let it slip 
> in - but only if there are a fair number of people willing to do numbers 
> and some harsh testing. Preferably people who did see problems earlier, 
> ie at a minimum Chris and Ingo under the loads they used before and saw 
> issues with.

I am tracking Peter's code in tip/core/locking:

 c10b491: mutex: implement adaptive spinning, v8
 c356a7c: mutex: implement adaptive spinning, v7
 b89e5d8: mutex: implement adaptive spinning, v6
 237ac94: mutex: implement adaptive spinning

And v8 is rock solid in all my testing - and i'll give v10 a similar 
workout as well.

Would you prefer a single commit or is this kind of delta development 
history useful, with all the variants (at least the later, more promising 
ones) included?

The commits are in a tight group with no merges inbetween.

	Ingo
