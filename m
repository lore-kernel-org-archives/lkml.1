Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYJHCwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYJHCwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYJHCwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:52:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38435 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbYJHCwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:52:12 -0400
Date: Tue, 7 Oct 2008 20:52:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Message-ID: <20081008025209.GO25780@parisc-linux.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net> <200810081335.44576.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810081335.44576.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 01:35:44PM +1100, Nick Piggin wrote:
> Right you are. That's the fundamental question. The actual details of
> the fix and how likely the race is don't really matter until we
> answer the first question (except to say that the "fix" is never going
> to be free).
> 
> We've lasted this long with the current semantics. So the natural
> reaction to anything that strengthens the semantics now is "why?". If
> we do that then we can basically never return to the weaker semantics.
> So there had better be a really good reason.

And it's worth saying that letter-of-the-standard arguments aren't
necessarily enough.  Linux does not honour the POSIX guarantee that
writes are atomic (if they cross page boundaries, it's not certain).
This seems like even more of a corner case to me.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
