Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbYEUIUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbYEUIUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYEUIUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:20:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbYEUIUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:20:09 -0400
Date: Wed, 21 May 2008 01:19:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Introduce down_nowait()
Message-Id: <20080521011926.18bf8e81.akpm@linux-foundation.org>
In-Reply-To: <20080521080452.GA1305@infradead.org>
References: <200805211600.16415.rusty@rustcorp.com.au>
	<20080520232903.6756b1c1.akpm@linux-foundation.org>
	<20080521080452.GA1305@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 04:04:53 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, May 20, 2008 at 11:29:03PM -0700, Andrew Morton wrote:
> > Actually, I don't thing down_nowait() is a terribly good name, because it
> > doesn't tell the reader anything about what to expect from the return
> > value.  Does a non-zero return mean that down_wait() acquired the lock,
> > or does it not?  Something like down_try() would be better, because if
> > it returns 1 we can say "ah, the trying succeeded".
> 
> Actually, it does,

No it doesn't.  If anything, a "true" return from something called
"down_nowait()" means "I didn't wait!".  Or something.

> and the kerneldoc comment explains it in every detail
> for those who need to read it up.

Shouldn't be necessary to look it up.  By that argument we could
call it eat_at_joes() and sell the advertising space.

>  Then again semaphores and on their
> way out, and I really hate the kind of churn this thing introduces at
> this moment.  Please let all the semaphore to completion/mutex/other
> construct change settle for a while, and with a little chance this gem
> will just go away entirely.

Well, we can walk and chew gum at the same time.

The number of down_trylocks in rc3 is 51 and the number of
down_trylocks and down_nowaits in -mm is 47.  So progress is pretty
glacial.

<wonders why -mm still has seven down_trlyocks>

<oh>

./kernel/semaphore.c
./kernel/mutex.c
./include/linux/semaphore.h

Anyway, yes, I agree that the whole effort is a bit dubious and that
the time could be better directed to semaphore eliminations.
