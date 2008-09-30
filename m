Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYI3Tyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYI3Tyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYI3TyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:54:14 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:34910 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820AbYI3TyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:54:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUFAHwg4khMQWq+/2dsb2JhbACBZr1XgWk
Date: Tue, 30 Sep 2008 15:54:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Martin Bligh <mbligh@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Message-ID: <20080930195409.GA24169@Krystal>
References: <20080929155004.GA11029@Krystal> <1222709445.23876.70.camel@twins.programming.kicks-ass.net> <20080929203124.GA23070@Krystal> <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com> <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com> <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com> <20080930181436.GA19690@Krystal> <alpine.DEB.1.10.0809301421330.6224@gandalf.stny.rr.com> <20080930183531.GA20670@Krystal> <33307c790809301244x40218be6of61b53104b8d7da3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <33307c790809301244x40218be6of61b53104b8d7da3@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:48:36 up 118 days, 29 min, 10 users,  load average: 0.40,
	0.57, 0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin Bligh (mbligh@google.com) wrote:
> > You are actually using them to put redundant information that could be
> > encoded differently and thus save 4 bits per event records, more or less
> > what will be needed by most tracers (15 IDs, 1 reserved for an extended
> > ID field).
> 
> You have 15 event types that are useful with no data payload at all?
> 

I am not saying anything about the actual number of events with 0 bytes
payload I actually have in my own instrumentation, if this is what you
mean. I am just saying that it leaves this room available for such
events.

Even if there is a 32 bits payload associated with those events, the
fact that we can encode the event ID in the 32 bits header will bring
those events from 96 bits (due to 32 bits alignment) down to 64 bits.

> > So the fact that you use them does not mean they are really required,
> > and I don't think such duplicated information actually makes things more
> > solid. Maybe just more obscure ?
> 
> This is all over 1 bit of information, right? Since you need at least 1 for
> the timestamp stuff.

4 bits of information could be added to the 32-bits header if we allow
tracers to register their first 15 event IDs in those 4 bits.

But well... let's keep that for v2. ;)

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
