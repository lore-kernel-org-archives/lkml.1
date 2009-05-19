Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZESWV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZESWV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZESWVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:21:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49270 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbZESWVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:21:21 -0400
Date: Tue, 19 May 2009 18:16:26 -0400
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
Message-ID: <20090519221625.GA3205@redhat.com>
References: <cover.1242763826.git.jbaron@redhat.com> <20090519211704.GA3325@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519211704.GA3325@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 05:17:04PM -0400, Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> > hi,
> > 
> > After disassembling some of the tracepoints, I've noticed that arguments that
> > are passed as macros or that perform  dereferences, evaluate prior to the
> > tracepoint on/off check. This means that we are needlessly impacting the 
> > off case.
> > 
> > I am proposing to fix this by adding a macro that first checks for on/off and
> > then calls 'trace_##name', preserving type checking. Thus, callsites have to 
> > move from:
> > 
> > trace_block_bio_complete(md->queue, bio);
> > 
> > to:
> > 
> > tracepoint_call(block_bio_complete,  md->queue, bio);
> > 
> 
> I knew this limitation in the first place, but decided it was not worth
> uglifying the tracepoint call site for it.

hmmm...i don't think its terribly ugly.

> 
> The expected use is to pass a pointer or a value as tracepoint argument
> and dereference it in the callback attached to it.
> 

there are a lot of tracepoints that pass more than just a pointer...do
we want to be slowing up i/o paths, when tracepoints are disabled?


> Is there any _real_ added value for going through this API change pain ?
>

the value is in being able to define the tracepoint api more easily to
one's liking and not have additional instructions in the off case, where
they can easily be avoided.

thanks,

-Jason



