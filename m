Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZALRRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZALRRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZALRQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:16:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZALRQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:16:45 -0500
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop>
	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 18:16:21 +0100
Message-Id: <1231780581.4371.193.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 08:20 -0800, Linus Torvalds wrote:
> 
> On Mon, 12 Jan 2009, Linus Torvalds wrote:
> > 
> > You made it back into the locked version.
> 
> Btw, even if you probably had some reason for this, one thing to note is 
> that I think Chris' performance testing showed that the version using a 
> lock was inferior to his local btrfs hack, while the unlocked version 
> actually beat his hack.
> 
> Maybe I misunderstood his numbers, though. But if I followed that sub-part 
> of the test right, it really means that the locked version is pointless - 
> it will never be able to replace peoples local hacks for this same thing, 
> because it just doesn't give the performance people are looking for.
> 
> Since the whole (and _only_) point of this thing is to perform well, 
> that's a big deal.

Like said in reply to Chris' email, I just wanted to see if fairness was
worth the effort, because the pure unlocked spin showed significant
unfairness (and I know some people really care about some level of
fairness).

Initial testing with the simple test-mutex thing didn't show too bad
numbers.

