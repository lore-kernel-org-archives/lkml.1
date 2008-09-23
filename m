Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYIWCh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYIWCh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYIWChQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:37:16 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:40851 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754074AbYIWChP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:37:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAFTt10hMQWq+/2dsb2JhbACBXbUcgWY
Date: Mon, 22 Sep 2008 22:36:54 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923023654.GF24937@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com> <1222077437.7470.5.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222077437.7470.5.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:31:40 up 110 days,  7:12,  7 users,  load average: 1.04, 0.45,
	0.34
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Sat, 2008-09-20 at 05:03 -0400, Steven Rostedt wrote:
> 
> > Oh, and all commands should start with the namespace.
> > 
> >   ring_buffer_alloc()
> >   ring_buffer_free()
> >   ring_buffer_record_event()
> 
> I really think we should separate the ringbuffer management from the
> event stuff.
> 

Sure, I am strongly in favor of separating those two, given they
represent two different things. However, the requirement I have heard at
KS2008 was to provide 

- Unified buffering mechanism
- Timestamps synchronized across all buffers
- Unified event IDs management, so events from various sources could be
  shared between tools.
- As of my understanding, unified event structure, which can be exported
  to userspace and be shared across different tools.
- Unified buffer control/management mechanism.

These all represent different infrastructure parts, but are all needed
if we want tools to be able to share the data exported through those
buffers.

Relay is a good example of having only a _single_ of these layers in
common : there is currently no way the different relay users can share
the data they collect because they have simply no idea how others
structure their data.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
