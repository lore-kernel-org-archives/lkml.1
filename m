Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZA2OFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZA2OFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZA2OF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:05:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbZA2OF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:05:26 -0500
Date: Thu, 29 Jan 2009 15:04:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, srostedt@redhat.com,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090129140451.GM24391@elte.hu>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere> <20090127225048.GA4652@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127225048.GA4652@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Jan 27, 2009 at 11:43:03PM +0100, Frederic Weisbecker wrote:
> > On Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke wrote:
> > > 
> > > This tracer monitors regular file open() syscalls. This is a fast
> > > and low-overhead alternative to strace, and does not allow or
> > > require to be attached to every process.
> > > 
> > > The tracer only logs succesfull calls, as those are the only ones we
> > > are currently interested in, and we can determine the absolute path
> > > of these files as we log.
> > > 
> > > Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> > 
> > 
> > Hi Auke,
> > 
> > Speaking about a global syscall tracer, I made a patch to trace only the syscalls
> > with the function-graph-tracer.
> > 
> > http://lkml.org/lkml/2008/12/30/267
> > 
> > Its approach and purpose is different than a tracer dedicated only to syscalls.
> > The function graph tracer traces execution graph of the functions and is more about
> > execution time spent and code flow whereas a syscall tracer can provide more specific
> > informations about syscalls.
> > 
> > So both are not overlaping.
> > 
> > But the low level part of my patch creates a thread flag _TIF_SYSCALL_TRACE which triggers
> 
> s/_TIF_SYSCALL_TRACE/_TIF_SYSCALL_FTRACE

> > Once we have it, I think a syscall tracer can be fed with new syscalls 
> > events through several patch iterations, starting with the open and 
> > close one :-)
> > 
> > Are you ok with that?
> > 
> > Steven, Ingo, do you agree?

yes. We definitely need this on the asm syscall level, to not contaminate 
hundreds of syscalls with tracepoints.

Auke's sys_open() plugin would be a nice prototype for that concept - but 
in generally it would be useful to be able to augment kernel tracer output 
with all syscall events that occur.

The output would be something like a slimmed-down strace, but for the 
whole kernel and not tied to ptrace semantics (which are crippling).

Would you be interested in extending your syscall tracing concept with 
those bits and would you be interested in integrating Auke's plugin into 
that

	Ingo
