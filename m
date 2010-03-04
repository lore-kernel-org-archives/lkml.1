Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab0CDWBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:01:46 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49428 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab0CDWBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RZ9YXoeehtkMY1tDCsxZT78UTs4nDRL4lmc6G2iMoTjePXI0zNhTHBNr8XaCOtnoC3
         mSon5IcxCEBqRcbG5CgDDtJYjUcV9bHDLttSw5aJay/+xndWFPR0DaZCpG1fKmJvn4We
         cdvmtw8Bwvp6g5Cr61sOgBfmi3mUot5RKV8sk=
Date: Thu, 4 Mar 2010 23:01:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Greg KH <greg@kroah.com>
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
	events
Message-ID: <20100304220138.GB8169@nowhere>
References: <1267636046.10871.74.camel@gandalf.stny.rr.com> <1267636595.25158.93.camel@laptop> <20100304112531.GF21977@elte.hu> <1267715801.10871.191.camel@gandalf.stny.rr.com> <20100304153606.GA32496@elte.hu> <1267718131.10871.240.camel@gandalf.stny.rr.com> <20100304211741.GB3643@elte.hu> <1267738238.10871.582.camel@gandalf.stny.rr.com> <20100304213725.GA8169@nowhere> <alpine.LFD.2.00.1003042251510.2014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003042251510.2014@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:52:36PM +0100, Thomas Gleixner wrote:
> On Thu, 4 Mar 2010, Frederic Weisbecker wrote:
> 
> > On Thu, Mar 04, 2010 at 04:30:38PM -0500, Steven Rostedt wrote:
> > > On Thu, 2010-03-04 at 22:17 +0100, Ingo Molnar wrote:
> > > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > 
> > > 
> > > > No, we want to decouple it from 'tracing'. It's events, not tracing. Events 
> > > > are more broader, they can be used for RAS, profiling, counting, etc. - not 
> > > > just tracing.
> > > > 
> > > > Furthermore, we only want /debug/tracing/events really, not the various 
> > > > dynamic ftrace controls - those could remain in /debug/tracing/.
> > > 
> > > I was talking about the files in the events directory:
> > > 
> > > events/sched/sched_switch/{id,format,enable,filter}
> > > 
> > > 
> > > Seems only the format file should go in, and perhaps the id.
> > > 
> > > I can keep the debug/tracing/events/* as is too, where the format and id
> > > just call the same routines that the eventfs calls, but add the enable
> > > and filter to be specific to ftrace.
> > 
> > 
> > The /debug/tracing/events could contain symlinks for the format
> > files so that the rest can stay there.
> 
> Are you proposing to create another sysfs symlink maze ?
> 
> Thanks,
> 
> 	tglx


I don't know, I like the idea of generalizing the events, but I hope
it won't be at the detriment of ftrace usability.

