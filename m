Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZK0Dwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZK0Dwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 22:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZK0Dwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 22:52:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39033 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZK0Dwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 22:52:50 -0500
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091126231329.GA8581@nowhere>
References: <4B0E286A.2000405@cn.fujitsu.com>
	 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
	 <1259224390.21397.87.camel@gandalf.stny.rr.com>
	 <20091126084039.GA15919@elte.hu>
	 <1259246730.21397.97.camel@gandalf.stny.rr.com>
	 <20091126175548.GC4997@nowhere> <20091126181205.GA18670@elte.hu>
	 <1259262740.21397.121.camel@gandalf.stny.rr.com>
	 <20091126192019.GA11245@elte.hu>
	 <1259264667.21397.131.camel@gandalf.stny.rr.com>
	 <20091126231329.GA8581@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 22:52:54 -0500
Message-Id: <1259293974.21397.138.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-27 at 00:13 +0100, Frederic Weisbecker wrote:

> > 
> > But I do agree with Frederic that this can be a little confusing, since
> > it makes it sound like DEFINE_EVENT is for multiple events.
> > 
> > What about saying exactly what it does?
> > 
> > DECLARE_AND_DEFINE_EVENT()
> 
> 
> It tells so much that it is confusing :)

Information overload huh? ;-)

> 
>  
> > 
> > Come to think of it, since current TRACE_EVENT is now just:
> > 
> > #define TRACE_EVENT() \
> > 	TRACE_EVENT_TEMPLATE() \
> > 	DEFINE_EVENT
> > 
> > This may make the most sense. I haven't tried it, but I believe that you
> > could even base other events off of the TRACE_EVENT. That is:
> > 
> > TRACE_EVENT(x, ...);
> > 
> > DEFINE_EVENT(x, y, ...);
> > 
> > And y would use x as its class.
> > 
> > So going back to your scheme of DECLARE_EVENT_CLASS(), it may make sense
> > to have DECLARE_AND_DEFINE_EVENT().
> > 
> > 
> > DECLARE_EVENT_CLASS(class, ...);
> > DEFINE_EVENT(class, foo, ...);
> > 
> > DECLARE_AND_DEFINE_EVENT(bar, ...);
> 
> 
> 
> Yep, or DEFINE_EVENT_NOCLASS.

Well it may not be upper class, but I wouldn't say it has no class ;-)

But seriously, that is more misleading. It is a class. Remember, that
TRACE_EVENT is both a class and a define. With the new names for
template trace_event is:

#define TRACE_EVENT(name, ...) \
	DECLARE_EVENT_CLASS(name, ...); \
	DEFINE_EVENT(name, name, ...);

So TRACE_EVENT really is a DECLARE_CLASS_AND_DEFINE_EVENT(name, ...);

-- Steve

> 
> 
> 
> > DEFINE_EVENT(bar, zoo, ...);
> > 
> > 
> > May work.
> > 
> > -- Steve
> > 
> > 
> 

