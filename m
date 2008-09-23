Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYIWTmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYIWTmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYIWTmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:42:46 -0400
Received: from www.tglx.de ([62.245.132.106]:36100 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYIWTmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:42:46 -0400
Date: Tue, 23 Sep 2008 21:41:40 +0200 (CEST)
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
In-Reply-To: <33307c790809231238m1e80fef4rce8a80722ff245f1@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809232140090.2038@apollo.tec.linutronix.de>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>  <33307c790809221712x4fbd9781u958c98d4585e92a9@mail.gmail.com>  <48D901FE.5060604@redhat.com> <20080923150410.GA28341@Krystal>  <48D90B84.4030905@redhat.com> 
 <alpine.LFD.1.10.0809230847360.3265@nehalem.linux-foundation.org>  <48D921B3.2060809@redhat.com>  <alpine.LFD.1.10.0809231927060.2038@apollo.tec.linutronix.de>  <48D93CAF.8070000@redhat.com>  <alpine.LFD.1.10.0809232129280.2038@apollo.tec.linutronix.de>
 <33307c790809231238m1e80fef4rce8a80722ff245f1@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, Martin Bligh wrote:

> On Tue, Sep 23, 2008 at 12:36 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 23 Sep 2008, Masami Hiramatsu wrote:
> >> # cat /sys/devices/system/cpu/cpu0/cpuidle/state3/usage
> >> 171210
> >
> > C3 stops the TSC. So depending on how many C3 entries you have on the
> > different cores, your TSCs will drift apart. Some BIOSes do even a
> > lousy job trying to fixup the TSCs on exit from C3, which makes things
> > even worse.
> >
> >>     C1:                  type[C1] promotion[--] demotion[--] latency[001] usage[00000016] duration[00000000000000000000]
> >>     C2:                  type[C2] promotion[--] demotion[--] latency[001] usage[00037969] duration[00000000000024288003]
> >>     C3:                  type[C3] promotion[--] demotion[--] latency[057] usage[00171818] duration[00000000001881257636]
> >>
> >> Could these help you?
> >
> > Yup, explains your TSC observation. Nothing we can do about. Broken by
> > system design :( Welcome in the wonderful world of Inhell/BIOS/ACPI !
> 
> We have linux patches that sync the TSC on exit_idle. I'll see if I can get
> Michael to send them out.

Are you sure that they sync it precicely enough that there is no user
space observable way of time going backwards between cores ?

Thanks,

	tglx
