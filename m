Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbZKDRnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbZKDRnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254AbZKDRnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:43:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbZKDRm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:42:59 -0500
Date: Wed, 4 Nov 2009 18:42:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Aristeu Rozanski <aris@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20091104174253.GB16091@elte.hu>
References: <20091103171054.GB25437@redhat.com> <20091104114630.GA16993@elte.hu> <38974.1257337997@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38974.1257337997@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Wed, 04 Nov 2009 12:46:30 +0100, Ingo Molnar said:
>
> > What i'd like to see for the NMI watchdog is much more ambitious 
> > than this: the use of perf events to run a periodic NMI callback.
> > 
> > The NMI watchdog would cause the creation of a per-cpu perf_event 
> > structure (in-kernel). All x86 CPUs that have perf event support 
> > (the majority of them) will thus be able to have an NMI watchdog 
> > using a nice, generic piece of code and we'd be able to phase out 
> > the open-coded NMI watchdog code.
> 
> What happens on older/smaller x86 CPUs that don't have any native 
> support for perf events?

I think we want to keep their NMI watchdog implementation - but new work 
should go towards a perf-events based NMI watchdog.

Note that in practice a working NMI watchdog implementation on an 
old/small x86 CPU can be taken and turned into a minimal PMU driver: one 
that can provide cycle based NMI events. There's no 'full' PMU support 
needed to get a fair amount of perf events functionality - and some of 
those CPUs dont even have a PMU.

So there's no hardware barrier of entry.

	Ingo
