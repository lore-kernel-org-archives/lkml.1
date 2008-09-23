Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYIWEM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYIWEM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 00:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYIWEMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 00:12:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYIWEMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 00:12:16 -0400
Message-ID: <48D86C38.9000407@redhat.com>
Date: Tue, 23 Sep 2008 00:10:32 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com> <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com> <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809222335400.26011@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809222335400.26011@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> But, with that, with a global atomic counter, and the following trace:
> 
> cpu 0: trace_point_a
> cpu 1: trace_point_c
> cpu 0: trace_point_b
> cpu 1: trace_point_d
> 
> 
> Could the event a really come after event d, even though we already hit 
> event b?

yes, if event c is an interrupt event :-).

  cpu 0       cpu 1
             hit event d
hit event a
log event a
             irq event c
             log event c
hit event b
log event b
             log event d

so, I think if we really need to order events, we have to stop
irq right after hitting an event.

Anyway, in most case, I think it works, but as accurate as
synchronized-TSC if hardware supports it.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

