Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZKZTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZKZTMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZKZTMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:12:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZKZTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:12:16 -0500
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091126181205.GA18670@elte.hu>
References: <4B0E286A.2000405@cn.fujitsu.com>
	 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
	 <1259224390.21397.87.camel@gandalf.stny.rr.com>
	 <20091126084039.GA15919@elte.hu>
	 <1259246730.21397.97.camel@gandalf.stny.rr.com>
	 <20091126175548.GC4997@nowhere>  <20091126181205.GA18670@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 14:12:20 -0500
Message-Id: <1259262740.21397.121.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added Christoph since he was the one to recommend the template
creation)

On Thu, 2009-11-26 at 19:12 +0100, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:

> DECLARE_EVENT_CLASS() doesnt really define an event visible to the user 
> yet though. It defines functions internally (to be used by the real 
> definition of the event) - but not visible externally really.
> 
> So the real 'definition' of an event happens with DEFINE_EVENT() - in 
> the logical model of this.
> 
> So the logical model is clear:
> 
>    DECLARE_EVENT_CLASS(class);
> 
>     DEFINE_EVENT(class, event1);
>     DEFINE_EVENT(class, event2);
>     DEFINE_EVENT(class, event3);
>     ...
> 
>   # later:
>   # DEFINE_STANDALONE_EVENT(event)

I think that name sounds even uglier than DEFINE_SINGLE_EVENT :-/

I'm fine with the DECLARE_EVENT_CLASS and DEFINE_EVENT, but I'm unsure
what to rename TRACE_EVENT as. I know its still pretty new, but it's
being used quite a bit. So it should take some extra thought.

I guess DEFINE_EVENT_CLASS is probably not good, although this would be
the combination of DECLARE_EVENT_CLASS and DEFINE_EVENT which it
actually is.

DECLARE_DEFINE_EVENT?  *naw*

DEFINE_DECLARED_EVENT?

Or we could go with DECLARE_EVENT(), DECLARE_EVENT_CLASS() and
DEFINE_EVENT_CLASS_INSTANCE()?


> 
> And the logical model is what matters: that's what developers will use. 
> They'll use these constructs based on the logical model, nobody sane 
> will look into the CPP magic ;-)
> 
> And yes, we occasionally have to revisit our naming choices - especially 
> when mistakes/misnomers become apparent.

Agreed, but lets discuss it before we commit it to a non-rebase branch.

-- Steve


