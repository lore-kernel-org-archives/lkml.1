Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYFRNES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYFRNES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYFRNEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:04:06 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:23019 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYFRNEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:04:05 -0400
Message-Id: <4858CF88.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 18 Jun 2008 07:04:08 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi-suse@firstfloor.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Marin Mitov" <mitov@issp.bas.bg>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, <akpm@osdl.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-rt-users" <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
References: <200805252108.25011.mitov@issp.bas.bg>
 <1213791416.16944.222.camel@twins> <4858C68C.BA47.005A.0@novell.com>
 <200806182242.49245.nickpiggin@yahoo.com.au>
In-Reply-To: <200806182242.49245.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Jun 18, 2008 at  8:42 AM, in message
<200806182242.49245.nickpiggin@yahoo.com.au>, Nick Piggin
<nickpiggin@yahoo.com.au> wrote: 
> On Wednesday 18 June 2008 22:25, Gregory Haskins wrote:
>> >>> On Wed, Jun 18, 2008 at  8:16 AM, in message
> 
>> > Yeah - migrate_disable() has been proposed several times. The reason I
>> > don't like it is that is creates scheduling artefacts like latencies by
>> > not being able to load-balance (and thereby complicates all that, and
>> > you know we don't need more complication there).
>>
>> True, and good point.  But this concept would certainly be useful to avoid
>> the heavyweight (w.r.t. latency) preempt-disable() in quite a few different
>> areas, so if we can make it work with reasonable visibility, it might be
>> nice to have.
> 
> It just seems like pretty worthless bloat to me.
> 
> There are _some_ cases where it can be used, but nobody has been
> able to come up with compelling uses really.

Well, I have some ongoing R&D which (I believe) *would* make compelling use of a
migration-disable feature.  But to date it is not ready to see the light of day.  As 
far as existing uses, I think I mostly agree with you.  The one argument to the
contrary would be to clean up the handful of places that implement an ad-hoc
migration-disable by messing with cpus_allowed in a similar manner.  But perhaps
those could be solved with a preempt-disable() as well.

>I don't think this
> case is helped very much either because the logic in there using
> preempt-disable is fine, isn't it?

You are probably right.  In my own defense, I was just responding to the
question about manipulating the cpus_allowed.  If you are going to do that
you are better off with my patch (IMO).  Changing cpus_allowed to prevent
migration is racy, among other things.  Whether this tsc code is optimal with
migration disabled or preemption-disabled is a separate matter which
I did not address.

> 
> Except that it should also have a cond_resched in it. Seems like
> an ideal place to put cond_resched because it is not a fastpath.

Seems reasonable to me.  Thanks Nick.

-Greg


