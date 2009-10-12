Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZJLTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZJLTI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbZJLTI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:08:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33987 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbZJLTI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:08:26 -0400
Date: Mon, 12 Oct 2009 21:07:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v3 6/7] perf: Add perf probe subcommand
	for kprobe-event setup helper
Message-ID: <20091012190707.GJ17138@elte.hu>
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222822.1684.3251.stgit@dhcp-100-2-132.bos.redhat.com> <20091012190303.GA4748@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091012190303.GA4748@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Oct 07, 2009 at 06:28:23PM -0400, Masami Hiramatsu wrote:
> > Add perf probe subcommand for kprobe-event setup helper to perf command.
> > This allows user to define kprobe events by C expressions (C line numbers,
> > C function names, and C local variables).
> >
> 
> 
> My libdwarf.h and dwarf.h are available through <libdwarf.h> and
> <dwarf.h>, these are in /usr/include
> 
> But even by fixing the include path in the makefile and probe-finder.h,
> I get the following build error:
> 
> util/probe-finder.c: In function ‘die_get_entrypc’:
> util/probe-finder.c:222: erreur: ‘Dwarf_Ranges’ undeclared (first use in this function)
> util/probe-finder.c:222: erreur: (Each undeclared identifier is reported only once
> util/probe-finder.c:222: erreur: for each function it appears in.)
> util/probe-finder.c:222: erreur: ‘ranges’ undeclared (first use in this function)
> cc1: warnings being treated as errors
> util/probe-finder.c:223: erreur: ISO C90 forbids mixed declarations and code
> util/probe-finder.c:247: erreur: implicit declaration of function ‘dwarf_get_ranges’
> util/probe-finder.c:247: erreur: nested extern declaration of ‘dwarf_get_ranges’
> util/probe-finder.c:251: erreur: implicit declaration of function ‘dwarf_ranges_dealloc’
> util/probe-finder.c:251: erreur: nested extern declaration of ‘dwarf_ranges_dealloc’
> make: *** [util/probe-finder.o] Erreur 1
> 
> 
> I remember we talked about that before, but I don't remember well why it happened.
> This is because of a libdwarf version or something, right?
> 
> Which one should I pick? Mine is:
> 
>     libdwarf.h  
> 
>     $Revision: #9 $ $Date: 2008/01/17 $

if it's possible to still have a single set of APIs it would be nice to 
auto-detect and massage all these libdwarf versions into a single 
backend within perf.

	Ingo
