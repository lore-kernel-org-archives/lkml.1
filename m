Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYIWUFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYIWUFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYIWUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:05:29 -0400
Received: from www.tglx.de ([62.245.132.106]:50865 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYIWUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:05:28 -0400
Date: Tue, 23 Sep 2008 22:03:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Bligh <mbligh@google.com>
cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <33307c790809231250y298ede7cqbee5a613ed6dbad5@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809232157580.2038@apollo.tec.linutronix.de>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>  <20080923150410.GA28341@Krystal> <48D90B84.4030905@redhat.com>  <alpine.LFD.1.10.0809230847360.3265@nehalem.linux-foundation.org>  <48D921B3.2060809@redhat.com> 
 <alpine.LFD.1.10.0809231927060.2038@apollo.tec.linutronix.de>  <48D93CAF.8070000@redhat.com>  <alpine.LFD.1.10.0809232129280.2038@apollo.tec.linutronix.de>  <33307c790809231238m1e80fef4rce8a80722ff245f1@mail.gmail.com>  <alpine.LFD.1.10.0809232140090.2038@apollo.tec.linutronix.de>
 <33307c790809231250y298ede7cqbee5a613ed6dbad5@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, Martin Bligh wrote:

> >> > Yup, explains your TSC observation. Nothing we can do about. Broken by
> >> > system design :( Welcome in the wonderful world of Inhell/BIOS/ACPI !
> >>
> >> We have linux patches that sync the TSC on exit_idle. I'll see if I can get
> >> Michael to send them out.
> >
> > Are you sure that they sync it precicely enough that there is no user
> > space observable way of time going backwards between cores ?
> 
> I think the tolerance is about 500 cycles. If that's not sufficient, I guess
> we'll have to either live with some slight misordering (which people have
> pointed out is kind of inevitable anyway) on these broken machines?
> It was sufficient for what we were using it for, but maybe not for everyone.

Well, I dont care about the trace reordering at all. I care about user
space visible time going backwards issues observed via the
gettimeofday vsyscall. 500 cycles should be fine, I doubt that we can
migrate in less than that :)

I guess you try this only for machines where the TSC runs with
constant frequency, right ?

Looking forward to your patches.

Thanks,

	tglx


 
