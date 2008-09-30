Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYI3Sfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYI3Sfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYI3Sfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:35:33 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:48184 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbYI3Sfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:35:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUFAHAO4khMQWq+/2dsb2JhbACBZr4PgWk
Date: Tue, 30 Sep 2008 14:35:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Message-ID: <20080930183531.GA20670@Krystal>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <20080929155004.GA11029@Krystal> <1222709445.23876.70.camel@twins.programming.kicks-ass.net> <20080929203124.GA23070@Krystal> <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com> <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com> <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com> <20080930181436.GA19690@Krystal> <alpine.DEB.1.10.0809301421330.6224@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809301421330.6224@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:30:19 up 117 days, 23:10,  9 users,  load average: 0.47, 0.39,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Tue, 30 Sep 2008, Mathieu Desnoyers wrote:
> > 
> > In Steven's scheme, the event IDs in the 4 bytes are reserved for
> > (useless) internal use ;) They can therefore not be used for specific
> > tracer event IDs, which I think is a misuse of the precious bits
> > otherwise available to store really useful event IDs.
> 
> I'm using them, so they must not be totally useless. ;-)
> 
> But ftrace has its own event ids and I don't want the ring buffer to ever 
> have to know about them.
> 
> -- Steve
> 

You are actually using them to put redundant information that could be
encoded differently and thus save 4 bits per event records, more or less
what will be needed by most tracers (15 IDs, 1 reserved for an extended
ID field).

So the fact that you use them does not mean they are really required,
and I don't think such duplicated information actually makes things more
solid. Maybe just more obscure ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
