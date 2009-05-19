Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZESXw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZESXw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 19:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZESXwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 19:52:51 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46601 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbZESXwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 19:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fhNLMlxz7T+g1u4g4O34T8QXGQilfTLva8uK0vTYEwSKXAR3xcYzFnyWyoBr341ZhZ
         kSsFzvyHeuND0Jc0AYrCsZxUehz9XSs+hBinCklwehGI7WhOSSVp3dStTVD6boDwEl2j
         qZkY3TW+RwtRquY160Bzu28K4vlPp/Czyl0wg=
Date: Wed, 20 May 2009 01:52:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
Message-ID: <20090519235245.GD6066@nowhere>
References: <cover.1242763826.git.jbaron@redhat.com> <20090519211704.GA3325@Krystal> <alpine.DEB.2.00.0905191826031.7816@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905191826031.7816@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 06:36:56PM -0400, Steven Rostedt wrote:
> 
> [ added Christoph ]
> 
> On Tue, 19 May 2009, Mathieu Desnoyers wrote:
> 
> > * Jason Baron (jbaron@redhat.com) wrote:
> > > hi,
> > > 
> > > After disassembling some of the tracepoints, I've noticed that arguments that
> > > are passed as macros or that perform  dereferences, evaluate prior to the
> > > tracepoint on/off check. This means that we are needlessly impacting the 
> > > off case.
> > > 
> > > I am proposing to fix this by adding a macro that first checks for on/off and
> > > then calls 'trace_##name', preserving type checking. Thus, callsites have to 
> > > move from:
> > > 
> > > trace_block_bio_complete(md->queue, bio);
> > > 
> > > to:
> > > 
> > > tracepoint_call(block_bio_complete,  md->queue, bio);
> > > 
> > 
> > I knew this limitation in the first place, but decided it was not worth
> > uglifying the tracepoint call site for it.
> > 
> > The expected use is to pass a pointer or a value as tracepoint argument
> > and dereference it in the callback attached to it.
> > 
> > Is there any _real_ added value for going through this API change pain ?
> > 
> 
> I agree with Mathieu that I don't think we want to "uglify" the callers. 
> But I also agree with Jason that we must not add any overhead to the "off" 
> state when we can avoid it.
> 
> If it comes down to the two, I would lean towards the "uglify" if it shows 
> performance benefits in the "off" case.



Yeah, I agree with you, if we have no choice, the most important goal
is to drop any overhead in tracing off-case.


 
> Perhaps I'll try to see if I can fool CPP to getting both worlds. But this 
> will be tricky :-/
> 
> When are we going to get our own C pre-processor?


It starts to be really required....


> -- Steve
> 

