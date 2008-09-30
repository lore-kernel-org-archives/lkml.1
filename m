Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYI3ToN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYI3ToN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYI3Tn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:43:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54061 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYI3Tn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:43:58 -0400
Date: Tue, 30 Sep 2008 15:43:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
In-Reply-To: <20080930183531.GA20670@Krystal>
Message-ID: <alpine.DEB.1.10.0809301541120.7993@gandalf.stny.rr.com>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <20080929155004.GA11029@Krystal> <1222709445.23876.70.camel@twins.programming.kicks-ass.net> <20080929203124.GA23070@Krystal>
 <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com> <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com> <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com> <20080930181436.GA19690@Krystal> <alpine.DEB.1.10.0809301421330.6224@gandalf.stny.rr.com>
 <20080930183531.GA20670@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Mathieu Desnoyers wrote:
> 
> You are actually using them to put redundant information that could be
> encoded differently and thus save 4 bits per event records, more or less
> what will be needed by most tracers (15 IDs, 1 reserved for an extended
> ID field).

I really like the idea of keeping the tracer event ids out of the ring 
buffer logic.

> 
> So the fact that you use them does not mean they are really required,
> and I don't think such duplicated information actually makes things more
> solid. Maybe just more obscure ?

Well, at least for version 1 these bits stay. I already found two bugs by 
hitting the event padding when the size said it should not have. This 
redundant information makes me feel a bit more cozy when they match.

-- Steve

