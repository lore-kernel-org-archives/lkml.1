Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYIYVD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYIYVD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYIYVC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:02:56 -0400
Received: from gw.goop.org ([64.81.55.164]:46343 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbYIYVCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:02:55 -0400
Message-ID: <48DBFC7D.4050208@goop.org>
Date: Thu, 25 Sep 2008 14:02:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> As for C2/C3 - that's just an argument for *not* doing anything at trace 
> time. What do you think happens when you try to trace through those 
> things? You're much better off trying to sort out the problems later, when 
> you don't hold critical locks and are possibly deep down in some buggy 
> ACPI code, and you're trying to trace it exactly _because_ it is buggy.
>   

That suggests that frequency changes should be recorded at a lower layer
as well, along with full timestamps and deltas, so that a log parser can
correctly generate the timestamps without having to parse higher-level
trace records.  Maybe the simplest thing to do is make the full
timestamp records also include frequency and offset information (to deal
with discontinuities caused by things like a vcpu switching between
physical cpus with unsynced tscs).

    J
