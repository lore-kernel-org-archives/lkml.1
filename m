Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYITLok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYITLok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYITLod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:44:33 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:56811 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbYITLod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:44:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMFAGZ+1EhMQWq+/2dsb2JhbACBXbRngWU
Date: Sat, 20 Sep 2008 07:44:28 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Martin Bligh <mbligh@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080920114427.GC10800@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <20080919144258.ac787fdf.randy.dunlap@oracle.com> <33307c790809191457y3ebffa28xa6d9ab6431554618@mail.gmail.com> <alpine.DEB.1.10.0809200424050.9362@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809200424050.9362@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:41:51 up 107 days, 16:22,  5 users,  load average: 3.44, 2.59,
	1.92
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Fri, 19 Sep 2008, Martin Bligh wrote:
> 
> > >> Event ids are 16 bit, dynamically allocated.
> > >
> > > What are these (like)?
> > 
> > u16
> > 
> > Sorry, probably lots of implicit assumptions in there that I forgot to explain
> > 
> > > Arch-specific "word"?
> > > or some fixed-size-for-all-systems (so that trace buffers can be
> > > shared/used on other systems?)  Preferably the latter.
> > 
> > Mmmm. I don't see anything wrong with making it just 8 byte aligned, personally.
> > Steven - this was your thing?
> 
> I'm fine with 8 byte aligned for all.
> 
> > 
> > >> Variable record length, header will start with length record.
> > >> Timestamps in fixed timebase, monotonically increasing (across all CPUs)
> > >
> > > what timestamp resolution?
> > 
> > ns is probably sufficient for output, but may need to be higher
> > internally to get
> > correct ordering of events across CPUs. So, as long as we record this in
> > the buffer header, the internal resolution shouldn't be critical. The text
> > print output ... I'd say ns? We can put it relative to wall time in there,
> > as long as we record it in the buffer header at trace start. I guess we should
> > document the buffer header ;-)
> > 
> 
> ftrace has two outputs. One is ns from start of boot, the other is ns from 
> start of trace. Not sure we need to make wall time in there, unless we add 
> it in the trace header (as you stated). Probably best for Version #2.
> 
> -- Steve
> 

For simplicity and efficiency, I would try to keep the timestamp
recorded for every event as close as what we are reading from the
hardware without manipulation. We can save the timestamp value at the
beginning of the trace (in the buffer header) and we can also save the
scaling value in the same header so we can transform stuff like cycle
counts into ns, ps from boot time or from trace start when we
pretty-print.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
