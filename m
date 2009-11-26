Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbZKZToh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbZKZToh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZKZTo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:44:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZKZToW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:44:22 -0500
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091126192019.GA11245@elte.hu>
References: <4B0E286A.2000405@cn.fujitsu.com>
	 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
	 <1259224390.21397.87.camel@gandalf.stny.rr.com>
	 <20091126084039.GA15919@elte.hu>
	 <1259246730.21397.97.camel@gandalf.stny.rr.com>
	 <20091126175548.GC4997@nowhere> <20091126181205.GA18670@elte.hu>
	 <1259262740.21397.121.camel@gandalf.stny.rr.com>
	 <20091126192019.GA11245@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 14:44:27 -0500
Message-Id: <1259264667.21397.131.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 20:20 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> > DECLARE_DEFINE_EVENT?  *naw*
> > 
> > DEFINE_DECLARED_EVENT?
> > 
> > Or we could go with DECLARE_EVENT(), DECLARE_EVENT_CLASS() and 
> > DEFINE_EVENT_CLASS_INSTANCE()?
> 
> I think the most common one should be the shortest, and the most common 
> one will be DEFINE_EVENT() - that's short enough already IMO.

The above were ideas for replacing TRACE_EVENT, not the current
DEFINE_EVENT.

> 
> I think we generally want to encourage the creation of classes of 
> events, not myriads of standalone events, each with their own call 
> signature, record format and printouts.
> 
> In that sense making the TRACE_EVENT() one longer would achieve that 
> goal of discouraging its over-use: DEFINE_SINGLE_EVENT() tells the 
> developer that it's an event of it's kind.

But I do agree with Frederic that this can be a little confusing, since
it makes it sound like DEFINE_EVENT is for multiple events.

What about saying exactly what it does?

DECLARE_AND_DEFINE_EVENT()


Come to think of it, since current TRACE_EVENT is now just:

#define TRACE_EVENT() \
	TRACE_EVENT_TEMPLATE() \
	DEFINE_EVENT

This may make the most sense. I haven't tried it, but I believe that you
could even base other events off of the TRACE_EVENT. That is:

TRACE_EVENT(x, ...);

DEFINE_EVENT(x, y, ...);

And y would use x as its class.

So going back to your scheme of DECLARE_EVENT_CLASS(), it may make sense
to have DECLARE_AND_DEFINE_EVENT().


DECLARE_EVENT_CLASS(class, ...);
DEFINE_EVENT(class, foo, ...);

DECLARE_AND_DEFINE_EVENT(bar, ...);

DEFINE_EVENT(bar, zoo, ...);


May work.

-- Steve


