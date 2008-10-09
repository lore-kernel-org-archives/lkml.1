Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYJIMdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYJIMdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757633AbYJIMdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:33:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58518 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756780AbYJIMda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:33:30 -0400
Date: Thu, 9 Oct 2008 14:16:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
	arch
Message-ID: <20081009121630.GB1623@ucw.cz>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <6.0.0.20.2.20081007183452.0f052210@172.19.0.2> <20081007102942.GE20740@one.firstfloor.org> <200810080327.44530.nickpiggin@yahoo.com.au> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-07 20:59:23, Peter Zijlstra wrote:
> On Tue, 2008-10-07 at 10:50 -0700, Andrew Morton wrote:
> > On Wed, 8 Oct 2008 03:27:44 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > > So.. is everyone agreed that corrupting f_pos is a bad thing? (serious
> > > question) If so, then we should get something like this merged sooner
> > > rather than later.
> > 
> > - two threads/processes sharing the same fd
> > 
> > - both appending the same fd
> > 
> > - both hit the small race window right around the time when the file
> >   flips over a multiple of 4G.
> > 
> > It's pretty damn improbable, and I think we can afford to spend the
> > time to get this right in 2.6.29.
> 
> The whole point is that such usage is outside the specification and thus
> we don't strictly need to fix this.
> 
> So the question Nick is asking is, do we want to slow down the kernel
> for a few broken user-space applications. Esp. since the race doesn't
> affect anybody else except the broken users of the file descriptor.

Why is it outside spec?

> IMHO not worth fixing..

I believe we even have append-only flag, similar to immutable, which
is used for security...??


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
