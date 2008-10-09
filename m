Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYJIMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYJIMd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbYJIMdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:33:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56105 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757440AbYJIMdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:33:31 -0400
Date: Thu, 9 Oct 2008 14:23:19 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
	arch
Message-ID: <20081009122319.GC1623@ucw.cz>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net> <200810081335.44576.nickpiggin@yahoo.com.au> <20081008025209.GO25780@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008025209.GO25780@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-07 20:52:09, Matthew Wilcox wrote:
> On Wed, Oct 08, 2008 at 01:35:44PM +1100, Nick Piggin wrote:
> > Right you are. That's the fundamental question. The actual details of
> > the fix and how likely the race is don't really matter until we
> > answer the first question (except to say that the "fix" is never going
> > to be free).
> > 
> > We've lasted this long with the current semantics. So the natural
> > reaction to anything that strengthens the semantics now is "why?". If
> > we do that then we can basically never return to the weaker semantics.
> > So there had better be a really good reason.
> 
> And it's worth saying that letter-of-the-standard arguments aren't
> necessarily enough.  Linux does not honour the POSIX guarantee that
> writes are atomic (if they cross page boundaries, it's not certain).
> This seems like even more of a corner case to me.

We have append-only files, and normal users should not be able to work
around that restriction.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
