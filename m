Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYHGScy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYHGScy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYHGScq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:32:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45114 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYHGScq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:32:46 -0400
Date: Thu, 7 Aug 2008 14:32:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: LTTng finds abnormally long APIC interrupt handler : 58.2 ms
In-Reply-To: <y0mwsisitcy.fsf@ton.toronto.redhat.com>
Message-ID: <alpine.DEB.1.10.0808071429380.7625@gandalf.stny.rr.com>
References: <20080805182007.GA4631@Krystal> <alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com> <20080807160907.GA11255@Krystal> <alpine.DEB.1.10.0808071314320.20931@gandalf.stny.rr.com> <y0mwsisitcy.fsf@ton.toronto.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 Aug 2008, Frank Ch. Eigler wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> >
> > I've been thinking of exporting it, and make it so that once you 
> > register something to the trace_ops, I'll up the module count, and never 
> > let that module unload.
> 
> This issue will need some sort of resolution if systemtap is to be
> able to hook up to ftrace.  Perhaps we could have a second/nested API
> that suffers the costs of explicit reference counting, but does permit
> dynamic attach and robust detach.

I've also thought about having a second registration method that would 
hook the mcount function to an internal one, one that is always there. 
Here we could add logic to know that a driver has registered a function. 
It will just have the added overhead of that logic.

It's not hard to do. I just didn't want to clutter ftrace too much before 
it made it into a major release. This means any patches to do this will 
happen after 27.

-- Steve

