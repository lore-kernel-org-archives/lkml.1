Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZADSWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZADSWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZADSWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:22:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZADSW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:22:29 -0500
Subject: Re: Btrfs for mainline
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20090103191706.GA2002@parisc-linux.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Jan 2009 19:21:50 +0100
Message-Id: <1231093310.27690.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-03 at 12:17 -0700, Matthew Wilcox wrote:
> > - locking.c needs a lot of cleanup.
> > If combination spinlocks/mutexes are really a win they should be 
> > in the generic mutex framework. And I'm still dubious on the
> hardcoded 
> > numbers.
> 
> I don't think this needs to be cleaned up before merge.  I've spent
> an hour or two looking at it, and while we can do a somewhat better
> job as part of the generic mutex framework, it's quite tricky (due to
> the different <asm/mutex.h> implementations).  It has the potential to
> introduce some hard-to-hit bugs in the generic mutexes, and there's some
> API discussions to have.

I'm really opposed to having this in some filesystem. Please remove it
before merging it.

The -rt tree has adaptive spin patches for the rtmutex code, its really
not all that hard to do -- the rtmutex code is way more tricky than the
regular mutexes due to all the PI fluff.

For kernel only locking the simple rule: spin iff the lock holder is
running proved to be simple enough. Any added heuristics like max spin
count etc. only made things worse. The whole idea though did make sense
and certainly improved performance.

We've also been looking at doing adaptive spins for futexes, although
that does get a little more complex, furthermore, we've never gotten
around to actually doing any code on that.

