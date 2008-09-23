Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYIWD3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYIWD3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYIWD3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:29:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022AbYIWD3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:29:08 -0400
Date: Mon, 22 Sep 2008 20:26:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
cc: Masami Hiramatsu <mhiramat@redhat.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <adaod2f649o.fsf@cisco.com>
Message-ID: <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
 <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Sep 2008, Roland Dreier wrote:
>
> Just like Einstein said, it really seems to me that the order of things
> depends on your frame of reference.

Heh. Yes. In general, there is no single ordering unless you actually use 
a serializing lock on all CPU's involved. 

And exactly as in the theory of relativity, two people on different CPU's 
can actually validly _disagree_ about the ordering of the same event. 
There are things that act as "light-cones" and are borders for what 
everybody can agree on, but basically, in the absence of explicit locks, 
it is very possible that no such thing as "ordering" may even exist.

Now, an atomic increment on a single counter obviously does imply *one* 
certain ordering, but it really only defines the ordering of that counter 
itself. It does not at all necessarily imply any ordering on the events 
that go on around the counter in other unrelated cachelines.

Which is exactly why even a global counter in no way orders "events" in 
general, unless those events have something else that does so.

		Linus
