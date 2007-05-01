Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbXEAW1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbXEAW1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXEAW1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:27:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:37217 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbXEAW1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:27:53 -0400
Date: Tue, 1 May 2007 18:27:24 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Bill Irwin <bill.irwin@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
Message-ID: <20070501222724.GG26093@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ulrich Drepper <drepper@gmail.com>,
	Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
	wli@holomorphy.com
References: <20070404172931.GM2986@holomorphy.com> <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com> <20070501172937.GQ26598@holomorphy.com> <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com> <20070501202456.GR26598@holomorphy.com> <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 03:10:40PM -0700, Ulrich Drepper wrote:
> I think beside RUSAGE_THREAD you'll find no precedence.  It's all new,
> you have to tread the path.  The RUSAGE_THREAD interface is not
> sufficient, actually.  First, if a thread terminates we don't have to
> keep it stick around until a wait call can be issued.  We terminate
> threads right away and the synchronization with waiters is done
> independently.  Seond, the thread ID (aka kernel process ID) is not
> exported nor should it.  This is easy to solve, though: introduce a
> pthread_getrusage interface.

Hey Ulrich, 

	It turns out this could be useful implementing something
called "Cost Enforcement" in the Real Time Specification for Java,
which is an optional part of the specification, but which some
customers have wanted. 

	The basic idea is that the thread tells JVM how much time
(either CPU or wall clock) it will consume, and if it takes more than
the specified amount of time, the assumption is that the thread has
malfunctioned or there has been some programming error, and the thread
should get the Java equivalent of a SIGXPU.

	There are two ways of implementing this.  One is to have the
JVM periodically poll using a pthread_getrusage() interface.  A better
choice might be some kind of per-thread CPU limit, that would result
in a thread-specific SIGXCPU signal.  But there are no interfaces
today that do anything like this.

	Do you have any thoughts or preferences about how this might
be done, if we tried to about doing something like a per-thread
SIGXCPU functionality?  If not, pthread_getrusage() might be
sufficient, if not the most efficient way of doing things.

	Regards,

					- Ted
