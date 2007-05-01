Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXEAWaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXEAWaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXEAWaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:30:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61367 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbXEAWaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:30:05 -0400
Date: Tue, 1 May 2007 15:29:22 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Bill Irwin <bill.irwin@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
Message-ID: <20070501222922.GS26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Ulrich Drepper <drepper@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
References: <20070404172931.GM2986@holomorphy.com> <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com> <20070501172937.GQ26598@holomorphy.com> <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com> <20070501202456.GR26598@holomorphy.com> <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Bill Irwin <bill.irwin@oracle.com> wrote:
>> The basic
>> idea is to try to do it similarly to how everyone else does so userspace
>> (I suppose this would include glibc) don't have to bend over backward to
>> accommodate it. Or basically to do what everyone expects.

On Tue, May 01, 2007 at 03:10:40PM -0700, Ulrich Drepper wrote:
> I think beside RUSAGE_THREAD you'll find no precedence.  It's all new,
> you have to tread the path.  The RUSAGE_THREAD interface is not
> sufficient, actually.  First, if a thread terminates we don't have to
> keep it stick around until a wait call can be issued.  We terminate
> threads right away and the synchronization with waiters is done
> independently.  Seond, the thread ID (aka kernel process ID) is not
> exported nor should it.  This is easy to solve, though: introduce a
> pthread_getrusage interface.

Sounds reasonable enough. I can follow directions. I'd not be concerned
if you happen to write it yourself, though I'll get around to it if you
don't.


On Tue, May 01, 2007 at 03:10:40PM -0700, Ulrich Drepper wrote:
> To solve the first problem the terminating thread should write out the
> data before it is gone.  Automatically.  After registration.  So, you
> could have a syscall to register a structure in the user address space
> which is filled with the data.  If the data structure is the same as
> rusage you're done.  If you use a different data structure yo need to
> introduce a getrusage-equivalent syscall.
> With this infrastructure in place we could have
>  int pthread_getrusage(pthread_t, struct ruage *);
> and
>  int pthread_join4(pthread_t, void ** valueptr, struct rusage *);
> pthread_join4 is a joke, we need a better name, but you get the drift.

This addresses further missing pieces in the API beyond what the
getrusage() flag did. I'll follow this precisely for any patch posted
for merging, and Cc: you on such.


-- wli
