Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbZL1JYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbZL1JYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbZL1JYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:24:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37913 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZL1JYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:24:13 -0500
Date: Mon, 28 Dec 2009 10:24:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dynamic debug - adding ring buffer storage support
Message-ID: <20091228092402.GD24690@elte.hu>
References: <1261481526-17630-1-git-send-email-jolsa@redhat.com>
 <20091222153955.GD3308@redhat.com>
 <20091222161353.GB20225@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222161353.GB20225@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Dec 22, 2009 at 10:39:56AM -0500, Jason Baron wrote:
> > On Tue, Dec 22, 2009 at 12:32:06PM +0100, Jiri Olsa wrote:
> > > Hi,
> > > 
> > > as I use dynamic debug sometimes, I thought it could be useful having
> > > the possibility to store the output somewhere else than dmesg.
> > > 
> > > The attached patch implements support for storing dynamic debug
> > > messages to the ring buffer.
> > > 
> > > The dynamic debug allows simple addition of new flags,
> > > so I added 'r' flag for ring buffer storage.
> > > 
> > > I used the ring buffer implementation from trace framework.
> > > 
> > > hopefuly this could be any use for others as well...
> > > plz let me know what you think,
> > > 
> > > jirka
> > > 
> > 
> > hi,
> > 
> > I like the idea of using the ring buffer for output. However, I'm not
> > sure why we need a separate one for this. I like adding the 'r' for ring
> > buffer storage, by why not just make this path call 'trace_printk()', and
> > store the string in the existing kernel tracing ring buffer? That way it
> > can interleave with other trace data as well.
> 
> that way you need to enable tracing as well... but thats ok I guess :)
> 
> I was investigating trace events for this, but did not find a way
> to put variable length argument inside... and I overlooked the
> trace_printk, I'll look on it and see how it fits, thanks
> 
> also having separate ring buffer makes the 'trace'/'trace_pipe' code
> really simple (suprissingly) compared to ftrace, and I thought
> on this place it could last for some time.. ;)

I think what we want is a unified channel of events, of which printk (and 
dynamic-printk) is one form. I.e. we should add printk events and 
dynamic-printk events as well, which would show up in /debug/tracing/events/ 
in a standard ftrace event form and would be accessible to tooling that way.

For printk a single event would be enough i suspect (we dont want a separate 
event for every printk), and for dynamic-printk we want to map the existing 
dyn-printk topologies into /debug/tracing/events, to preserve the distinctions 
and controls available there.

This way in the long run we'd have one unified facility.

	Ingo
