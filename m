Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYHGSYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYHGSYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYHGSY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:24:29 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:35837 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbYHGSY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:24:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEABHYmkhMRKxB/2dsb2JhbACBWKs8
Date: Thu, 7 Aug 2008 14:24:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: LTTng finds abnormally long APIC interrupt handler : 58.2 ms
Message-ID: <20080807182424.GA18164@Krystal>
References: <20080805182007.GA4631@Krystal> <alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com> <20080807160907.GA11255@Krystal> <alpine.DEB.1.10.0808071314320.20931@gandalf.stny.rr.com> <y0mwsisitcy.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0mwsisitcy.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:22:51 up 63 days, 23:03,  7 users,  load average: 0.48, 0.94,
	1.17
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> 
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > [...]
> >> It all holds in a small module. Having the ability to connect any marker
> >> on any generic probe from the lttng marker interface has been very
> >> useful to do all this. Actually, this module has to be built into the
> >> kernel because ftrace does not permit breeing the trace_ops data
> >> structure. :/
> >
> > I did this purposely. The reason is that there is no safe way to release
> > the trace_ops, because you never know if something is in the function
> > you pointed to. If you remove the module after that, it crashes.
> >
> > I've been thinking of exporting it, and make it so that once you 
> > register something to the trace_ops, I'll up the module count, and never 
> > let that module unload.
> 
> This issue will need some sort of resolution if systemtap is to be
> able to hook up to ftrace.  Perhaps we could have a second/nested API
> that suffers the costs of explicit reference counting, but does permit
> dynamic attach and robust detach.
> 

Creating a wrapper which would disable preemption before calling the
callback would make teardown possible.
Unregistration/synchronize_sched() and then module free would be ok.
That's what I do with markers and tracepoints.

The wrapper itself can never be unloaded, but the connected probes can.

Mathieu

> 
> - FChE

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
