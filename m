Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZAKCJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZAKCJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZAKCJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:09:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34502 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZAKCJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:09:36 -0500
Date: Sun, 11 Jan 2009 03:09:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Brad Parker <brad@heeltoe.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: copy_{to,from}_user
Message-ID: <20090111020923.GC29153@elte.hu>
References: <4056.1231523557@mini> <1231538061.29452.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231538061.29452.8.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-01-09 at 12:52 -0500, Brad Parker wrote:
> > I have a question about copy_{to,from}_user.  
> > 
> > Most implementations I've seen do in-order copies and notice when an
> > exception occurs and report back the progress.  This is straight
> > forward.
> > 
> > (but to be honest, I have suspicions about how just how accurate those
> > reports are i.e. +/- 1-3 bytes on some architectures)
> > 
> > On some cpu's it is advantageous to do an out-of-order copy to take
> > advantage of various cache fill mechanisms.
> > 
> > The problem is that the out-of-order copy makes it impossible to know
> > where the exception occurred (in terms of progress).
> > 
> > Would it be permissible to have a version of copy_{to,from}_user which
> > does an out-of-order copy and when an exception occurs, restarts the
> > copy from the beginning using a simple in-order copy, to make it
> > possible to identify where the exception occurs?
> > 
> > The idea is that exceptions are rare and so the performance hit of doing
> > the "recopy" would be minimal and would provide the required accuracy.
> 
> x86_64 already does some unrolling and is inaccurate as to where exactly
> it happens. The only thing that is very important is that you _never_
> say you copied more than you actually did.
> 
> That was the source of a data corruption bug a while ago, the code did 
> something like sequences: read 8 words, write 8 words. And reported the 
> number of bytes read, instead of bytes written, which is an 
> over-estimation.

you sure must have meant 'write 7 words' or something like that?

	Ingo
