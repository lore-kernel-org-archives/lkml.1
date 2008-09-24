Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYIXVIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYIXVIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIXVIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:08:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44596 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYIXVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:08:35 -0400
Date: Wed, 24 Sep 2008 17:08:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Martin Bligh <mbligh@google.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <33307c790809241356l79acc57cxa4fb84c1e5dae1da@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809241703560.10529@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
  <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>  <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>  <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com>  <33307c790809241104k2af4b900w781aba1a1393004b@mail.gmail.com> 
 <alpine.LFD.1.10.0809241330270.3265@nehalem.linux-foundation.org> <33307c790809241356l79acc57cxa4fb84c1e5dae1da@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Martin Bligh wrote:

> > On Wed, 24 Sep 2008, Martin Bligh wrote:
> >>
> >> If we use 32 bits instead of 27, then the timestamp events are only
> >> about once per second, which is probably fine for overhead ... ?
> >
> > You'd have them ONCE IN A BLUE MOON.
> >
> > If there is nothing going on, you don't need the timestamps at all.
> 
> Yeah, you're right - we can just mark it dirty, and 'pre-log' the timestamp
> events when someone calls a reserve and we haven't logged anything
> for more time than we can store. Did not think of that. Was only 5 bits
> for us, not an extra 37, but still, is much better.
> 
> Is a 5-bit event id generic enough though?
> 

Actually, I was keeping the event id completely out of the ring buffer and 
let a higher layer deal with that. For padding, I just made the length 
field zero.

For overflows of the timestamp, we can reserve the -1 timestamp as a 
trigger to read the tsc again and put the full 64 bits into the record.

Just an idea.

-- Steve

