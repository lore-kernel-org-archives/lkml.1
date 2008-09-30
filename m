Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbYI3UVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbYI3UVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYI3UVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:21:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46467 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYI3UVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:21:17 -0400
Date: Tue, 30 Sep 2008 16:21:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@suse.com,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
In-Reply-To: <20080930200112.GD27822@redhat.com>
Message-ID: <alpine.DEB.1.10.0809301620080.7993@gandalf.stny.rr.com>
References: <20080929155004.GA11029@Krystal> <1222709445.23876.70.camel@twins.programming.kicks-ass.net> <20080929203124.GA23070@Krystal> <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com> <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com>
 <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com> <20080930181436.GA19690@Krystal> <alpine.DEB.1.10.0809301421330.6224@gandalf.stny.rr.com> <20080930183531.GA20670@Krystal> <alpine.DEB.1.10.0809301541120.7993@gandalf.stny.rr.com>
 <20080930200112.GD27822@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Frank Ch. Eigler wrote:
> On Tue, Sep 30, 2008 at 03:43:45PM -0400, Steven Rostedt wrote:
> > [...]
> > On Tue, 30 Sep 2008, Mathieu Desnoyers wrote:
> > > 
> > > You are actually using them to put redundant information that could be
> > > encoded differently and thus save 4 bits per event records, more or less
> > > what will be needed by most tracers (15 IDs, 1 reserved for an extended
> > > ID field).
> > 
> > I really like the idea of keeping the tracer event ids out of the ring 
> > buffer logic.
> 
> That's fine for a ring buffer that only ever contains data from one
> event source.  How do you imagine multiplexing working, where one
> wants to grep a single debugfs file that contains data from different
> event sources?  Punt to another layer?

Field goal!

Yes! That is exactly what I want. If your trace has only one event, why 
would it want to record them?  The event id belongs in the tracer layer 
not the ring buffer layer.

I would like to make a "trace_buffer" layer that includes all of this.

-- Steve

