Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629Ab0ARQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0ARQvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343Ab0ARQvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:51:19 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62228 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0ARQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s/WOZazLOmaJ6S3M4HqqD+L7HuCnZN/4RrXtHG4nWEq6GZuUMOS/qFoQEseGEeU9ON
         XAyWYUdEXntS1/cpKp9ll5KxLaE9tuGnD7IdAFdRNpaYWEv4NwX001M47sCtLf8eriDl
         OQS7XFDzfJS4tLCaZuUiKWGP4prSOEFOsNRFI=
Date: Mon, 18 Jan 2010 17:51:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100118165114.GJ10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com> <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop> <20100118144556.GE10364@nowhere> <1263826601.4283.603.camel@laptop> <20100118161836.GG10364@nowhere> <1263831973.4283.622.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263831973.4283.622.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 05:26:13PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 17:18 +0100, Frederic Weisbecker wrote:
> > On Mon, Jan 18, 2010 at 03:56:41PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-01-18 at 15:45 +0100, Frederic Weisbecker wrote:
> > > > 
> > > > > > That requires to know in advance if we have hardware pmu
> > > > > > in the list though (can be a flag in the group).
> > > > > 
> > > > > Good point, but your proposed hw_check_constraint() call needs to know
> > > > > the exact same.
> > > > 
> > > > 
> > > > True. Whatever model we use anyway, both implement the same idea.
> > > 
> > > Hmm, we seem to already have that problem (which would indicate another
> > > bug in the hw-breakpoint stuff), how do you deal with
> > > hw_perf_{enable,disable}() for the breakpoints?
> > 
> > 
> > We don't have ordering constraints for breakpoints, only constraints
> > on the number of available registers.
> > 
> > So we check the constraints when a breakpoint registers. The
> > enable/disable then (is supposed to) always succeed on breakpoint
> > pmu, except for flexible breakpoints that can make it or not,
> > but no need to overwrite group scheduling for that.
> 
> hw_perf_{enable,disable} are unrelated to groups.


Right hw_perf_enable/disable have no action on breakpoint events.
These were somehow considered as software events until now.

That raises the question: why perf_disable() only takes care
of hardware events? Very few software events can trigger
between perf_disable() and perf_enable() sections though.

May be I should handle breakpoints there.

