Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbZCUJNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbZCUJNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZCUJNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:13:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbZCUJNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:13:05 -0400
Date: Sat, 21 Mar 2009 10:12:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       utrace-devel@redhat.com, Frank Eigler <fche@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321091235.GA29678@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321013912.ed6039c9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 21 Mar 2009 08:43:01 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Roland McGrath <roland@redhat.com> wrote:
> > 
> > > From: Frank Ch. Eigler <fche@redhat.com>
> > > 
> > > This is v2 of the prototype utrace-ftrace interface.  This code is 
> > > based on Roland McGrath's utrace API, which provides programmatic 
> > > hooks to the in-tree tracehook layer.  This new patch interfaces 
> > > many of those events to ftrace, as configured by a small number of 
> > > debugfs controls.  Here's the 
> > > /debugfs/tracing/process_trace_README:
> > 
> > Please submit changes/enhancements to kernel/trace/* to the tracing 
> > tree maintainers (Steve and me) for review, testing and integration.
> > 
> > Please also post patches against the latest tracing tree:
> > 
> >    http://people.redhat.com/mingo/tip.git/README
> 
> uhm, this patch depends on the (large) utrace patch, which is not 
> kernel/trace material.

The thing is, utrace crashes in Fedora have dominated kerneloops.org 
for many months, so i'm not sure what to make of the idea of posting 
a 4000+ lines of core kernel code patchset on the last day of the 
development cycle, a posting that has carefully avoided the Cc:-ing 
of affected maintainers ;-)

Utrace is very much tracing material - without the ftrace plugin the 
whole utrace machinery is just something that provides a _ton_ of 
hooks to something entirely external: SystemTap mainly.

kernel/utrace.c should probably be introduced as 
kernel/trace/utrace.c not kernel/utrace.c. It also overlaps pending 
work in the tracing tree and cooperation would be nice and desired.

The ftrace/utrace plugin is the only real connection utrace has to 
the mainline kernel, so proper review by the tracing folks and 
cooperation with the tracing folks is very much needed for the whole 
thing.

	Ingo
