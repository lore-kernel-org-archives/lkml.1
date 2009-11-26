Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbZKZXN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbZKZXN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 18:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZKZXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 18:13:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33656 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZXN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 18:13:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YCo/jptzAGPheb7A9d6L7rwTu4dAtiqdK3QgnCeFmdAXeNN3Pu9KE0WDoPntLcJavw
         oOMfP1i6kIA3llcB5NkwUa2WThE/lz45FqS9uoHmGvIXrnLCScHk69yfU8OksUMSpT/m
         C0ISMKIir+3y2x1HHijd2FDqH2dOCxJL5dyL0=
Date: Fri, 27 Nov 2009 00:13:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
	DECLARE_EVENT_CLASS()
Message-ID: <20091126231329.GA8581@nowhere>
References: <4B0E286A.2000405@cn.fujitsu.com> <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org> <1259224390.21397.87.camel@gandalf.stny.rr.com> <20091126084039.GA15919@elte.hu> <1259246730.21397.97.camel@gandalf.stny.rr.com> <20091126175548.GC4997@nowhere> <20091126181205.GA18670@elte.hu> <1259262740.21397.121.camel@gandalf.stny.rr.com> <20091126192019.GA11245@elte.hu> <1259264667.21397.131.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259264667.21397.131.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 02:44:27PM -0500, Steven Rostedt wrote:
> On Thu, 2009-11-26 at 20:20 +0100, Ingo Molnar wrote:
> > I think we generally want to encourage the creation of classes of 
> > events, not myriads of standalone events, each with their own call 
> > signature, record format and printouts.
> > 
> > In that sense making the TRACE_EVENT() one longer would achieve that 
> > goal of discouraging its over-use: DEFINE_SINGLE_EVENT() tells the 
> > developer that it's an event of it's kind.
> 
> But I do agree with Frederic that this can be a little confusing, since
> it makes it sound like DEFINE_EVENT is for multiple events.
> 
> What about saying exactly what it does?
> 
> DECLARE_AND_DEFINE_EVENT()


It tells so much that it is confusing :)

 
> 
> Come to think of it, since current TRACE_EVENT is now just:
> 
> #define TRACE_EVENT() \
> 	TRACE_EVENT_TEMPLATE() \
> 	DEFINE_EVENT
> 
> This may make the most sense. I haven't tried it, but I believe that you
> could even base other events off of the TRACE_EVENT. That is:
> 
> TRACE_EVENT(x, ...);
> 
> DEFINE_EVENT(x, y, ...);
> 
> And y would use x as its class.
> 
> So going back to your scheme of DECLARE_EVENT_CLASS(), it may make sense
> to have DECLARE_AND_DEFINE_EVENT().
> 
> 
> DECLARE_EVENT_CLASS(class, ...);
> DEFINE_EVENT(class, foo, ...);
> 
> DECLARE_AND_DEFINE_EVENT(bar, ...);



Yep, or DEFINE_EVENT_NOCLASS.



> DEFINE_EVENT(bar, zoo, ...);
> 
> 
> May work.
> 
> -- Steve
> 
> 

