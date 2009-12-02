Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZLBUQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZLBUQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbZLBUQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:16:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39001 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbZLBUQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:16:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AlN6ANHtdXwqjB4solFGK/SfkbZGmQVu+kOZG6mdcUdk0lcRL/xauLoKVIHT8+PhSW
         yT615rXyWn/yA3cGgSUfAxYRH9vlZEalMLtr2/JrG/1oZ07vLrwryIjXVPG4oPO59RjT
         gKtJ1EZPgXI2Xi36VlNnmr0GtnSuCoxJ/XMAY=
Date: Wed, 2 Dec 2009 21:16:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, randy.dunlap@oracle.com,
       wcohen@redhat.com, tglx@linutronix.de, jbaron@redhat.com,
       mhiramat@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH][tip/perf/core] tracing: Rename TRACE_EVENT and others
	to something resonable
Message-ID: <20091202201635.GA5141@nowhere>
References: <20091202140128.GA2611@elte.hu> <1259764109.12870.37.camel@gandalf.stny.rr.com> <20091202144334.GA30359@elte.hu> <1259765735.12870.42.camel@gandalf.stny.rr.com> <20091202162715.GB9710@Krystal> <1259773888.12870.61.camel@gandalf.stny.rr.com> <20091202180633.GF9710@Krystal> <1259777987.12870.70.camel@gandalf.stny.rr.com> <20091202190135.GA23316@Krystal> <1259784683.12870.100.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259784683.12870.100.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 03:11:23PM -0500, Steven Rostedt wrote:
> With the addition of TRACE_EVENT templates (or classes) the issue of
> naming has come up.
> 
> Originally, the template was called TRACE_EVENT_TEMPLATE. This was to be
> used to consolidate similar TRACE_EVENTs because a single TRACE_EVENT
> takes up quite a bit of code. One TRACE_EVENT creates a function to
> register and unregister a trace point, a function to record the event in
> a buffer, a function to display the binary output to user space, a
> function to add counters to record the number of times the event is
> reached, and so on.
> 
> All these functions creates a lot of bloat, especially since these
> functions are almost identical to each other. Unfortunately, these
> functions require specific parameters and structure fields, and can't
> always be the same. But for those events that share the same structure
> and parameters, a class/template allows them to share the same functions
> and this cuts down the bloat substantially.
> 
> But what to call these macros to satisfy the already confused kernel
> developers?
> 
> Ideally, DECLARE_EVENT_CLASS to create the class, DEFINE_EVENT to create
> an instance of the class, and even DEFINE_EVENT_CLASS to replace the
> current TRACE_EVENT that defines a class and creates an event of the
> same name as the class. New DEFINE_EVENTs may also reference a class
> declared by DEFINE_EVENT_CLASS.
> 
> But us kernel developers stay up too late at night, drinking jolt (or
> beer if you are in Europe), and our brain cells have fused to only
> logical circuitry, thus understanding concepts that are not engraved in
> stone becomes a bit too straining for us, and we may finally have to
> give up on solving this one last bug to get some rest with our love one
> that's been sleeping since 9pm.
> 
> This means using DECLARE_* and DEFINE_* will push us over that brink to
> normalcy and must be avoided. A new name must be established to clearly
> describe the mystical CPP magic that comprises the TRACE_EVENT hackery.
> Something that can bring us back to our roots. Something where it all
> begins. The stone age.
> 
> Thus, this patch renames the MACROS to the most obvious definitions
> around. Something we should have thought of at the start.
> 
> 
> s/DEFINE_EVENT_CLASS/FRED/g
> s/DEFINE_EVENT/WILMA/g
> s/TRACE_EVENT/BARNEY/g
> 
> 
> Thus with the new naming convention:
> 
> FRED(x, ...) -- will declare a class but will not make any events
> WILMA(x, y, ...) -- will create an event based off of class made by FRED
> BARNEY(x, ...) -- will create both a class and an event
> 
> /* Little known secret, WILMA can also fool around with BARNEY and can
> create new events with BARNEY as well as with FRED */
> 
>   (apologies to Thomas Gleixner and his renaming to "fred")
> 
> Signed-off-by: Steven Rostedt <flintstone@goodmis.org>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

