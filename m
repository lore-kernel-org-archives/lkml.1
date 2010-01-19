Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476Ab0ASQVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0ASQVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029Ab0ASQVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:21:10 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54262 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0ASQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:21:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a7IFD5DCgTSpixg2qXnxNbJnhNATkSaj7MgzBDqhAc4XP38S9JWnPTncjP0ZKcIDFV
         vGZToOr4vH14qdotpJDNrQIohAnUAiFvgIFMvk7zVqPI4XfaC+5+T0I0Xxs6A5qx5Kea
         xUiJnw/UzO62LAv88uDPzJ48RGnqfdmocPO1c=
Date: Tue, 19 Jan 2010 17:21:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Joshua Pincus <joshua.pincus@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100119162059.GF8061@nowhere>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> <87ljg1fn3u.fsf@basil.nowhere.org> <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com> <20100114092350.GF12241@basil.fritz.box> <bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com> <20100118110406.GC5256@nowhere> <y0maawbid91.fsf@fche.csb> <20100119145027.GB8061@nowhere> <20100119151210.GC16096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119151210.GC16096@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 10:12:10AM -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> > > > [...]
> > > > What about extending ptrace to support a new type of
> > > > breakpoint debugging interface?
> > > 
> > > This is the sort of reason why the utrace-gdbstub prototype was
> > > constructed.  It should allow in-kernel implementation of the
> > > multithreaded gdb extensions.  (By the way, it can already use uprobes
> > > rather than userspace-managed breakpoints.)
> > 
> > Can utrace somehow meet Joshua's needs? 
> 
> Not directly, I'm afraid.  I jumped in at a late stage of the thread
> that got a bit away from Joshua's original note
> (http://lkml.org/lkml/2010/1/13/490).  OTOH, it could be made to work
> a few different ways.
> 
> One is a systemtap or hand-written module that maps selected
> perf-event hits in the kernel to an application SIGTRAP.



Yeah would work.

But I rather hope we can extend ptrace interface to handle
such new needs instead (ie: having a more scalable breakpoint
interface support by ptrace).



> Another is using the gdbstub, extended with gdb watchpoint support (Z*
> packets), which would tie into the hw-breakpoint system directly.
> Joshua's application would manage the debug registers by means of a
> userspace supervisor process sending the appropriate Z* packets to the
> gdbstub, and otherwise letting the program run.  When a watchpoint
> fires, the supervisor process can instruct gdbstub to send a SIGTRAP
> to the application.  In this scenario, the perf syscall / subsystem is
> not used at all.



Is this gdbstub an interface to utrace?

This: http://lwn.net/Articles/364268/ ?



> 
> > I'm not sure what kind of interface it can offer for that. The fact
> > is I don't know very well utrace :)
> 
> That's ok.  utrace is an in-kernel API for process management.  ptrace
> and the RFC gdbstub are two possible userspace interfaces tuned for
> third-party debugging.



Ok.

 
> 
> > Do you plan a resubmission soon?
> 
> Utrace core has been resubmitted at the end of December
> (http://lkml.org/lkml/2009/12/17/466), with no further comments
> received.


Hmm, there has been deep review from Peter, IIRC.


> I hope it gets plopped into linux-next ASAP and merged next
> time.  The gdbstub was an RFC only at this stage, but if other people
> get excited about it, we're happy to spiff it up for proposed merging.



Ok.

Thanks.

