Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab0CDVSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:18:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40706 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab0CDVSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:18:00 -0500
Date: Thu, 4 Mar 2010 22:17:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Greg KH <greg@kroah.com>
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace events
Message-ID: <20100304211741.GB3643@elte.hu>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
 <1267632387.10871.59.camel@gandalf.stny.rr.com>
 <1267634258.25158.88.camel@laptop>
 <1267636046.10871.74.camel@gandalf.stny.rr.com>
 <1267636595.25158.93.camel@laptop>
 <20100304112531.GF21977@elte.hu>
 <1267715801.10871.191.camel@gandalf.stny.rr.com>
 <20100304153606.GA32496@elte.hu>
 <1267718131.10871.240.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267718131.10871.240.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2010-03-04 at 16:36 +0100, Ingo Molnar wrote:
> 
> > > This should be done anyway. But it would also let you decouple ftrace trace 
> > > events from perf trace events but still let the two use the same trace 
> > > points.
> > 
> > I think the main thing would be to have a decoupled /eventfs - basically 
> > /debug/tracing/events/ moved to "/eventfs" or maybe to "/proc/events/". This 
> > would make them available more widely, and in a standardized way.
> 
> I know Greg once proposed a /tracefs directory. I don't really care how 
> things work as long as we don't lose functionality. Perhaps we should have a 
> standard tracefs dir, and have:

No, we want to decouple it from 'tracing'. It's events, not tracing. Events 
are more broader, they can be used for RAS, profiling, counting, etc. - not 
just tracing.

Furthermore, we only want /debug/tracing/events really, not the various 
dynamic ftrace controls - those could remain in /debug/tracing/.

Thanks,

	Ingo
