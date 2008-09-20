Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYITLlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYITLlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYITLlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:41:05 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:46223 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751652AbYITLlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:41:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMFAA991EhMQWq+/2dsb2JhbACBXbRWgWU
Date: Sat, 20 Sep 2008 07:40:57 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Martin Bligh <mbligh@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080920114056.GB10800@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <20080919144258.ac787fdf.randy.dunlap@oracle.com> <33307c790809191457y3ebffa28xa6d9ab6431554618@mail.gmail.com> <20080919224109.GB4491@suse.de> <33307c790809191519k7c1bcce7y3fa37efc23b0f9c@mail.gmail.com> <alpine.DEB.1.10.0809200427070.9362@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809200427070.9362@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:32:58 up 107 days, 16:13,  5 users,  load average: 1.10, 1.41,
	1.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Fri, 19 Sep 2008, Martin Bligh wrote:
> 
> > >> Sorry, probably lots of implicit assumptions in there that I forgot to explain
> > >
> > > Ids for event types. Either allocated dynamically, if the tracer needs
> > > new ids on each use, or statically assigned for others (like my fctrace
> > > or Steven's ftrace, I believe). Should we have a reserved range / registry
> > > for static allocation, maybe something like a very simple version of
> > > devices.txt?
> > 
> > Sure, but it's per-tracer, so hopefully won't be a big problem (eg fctrace
> > would have a different event-id namespace from blktrace)
> > 
> 
> Right!
> 
>  We stated in our little meeting that the true event id association is 
> buffer id / event id tuple. We will not be assigning ranges for events 
> for specific tracers. Ftrace will not have its own range. The static ids 
> are reserved for the static trace points and some various static trace 
> types that the average kernel developer may use.
> 

Just to be sure of the "that the average kernel developer may use"
meaning : I would recommend keeping those static ID range only for
internal buffering mechanism events. E.g., if we need to add a
periodical event in every stream so we can detect timestamp wrap-around,
that would be part of the buffering infrastructure itself, and thus
reserve an event ID.

core_heartbeat (u64 timestamp)

Same thing if we want to export the table that maps:

  event name <-> event ID <-> event typing (includes event size info)

That table can be presented into the buffers (possible a single metadata
buffer) in the form of two static event IDs :

core_id_name (u16 id, const char *name)
core_id_type (u16 id, const char *type)

Here another assumption for portability is to declare event type as a
possibly extended format string. Alternative suggestions are welcome.

Mathieu

> Think "string event type" for a event type that will simply hold an ASCII 
> string.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
