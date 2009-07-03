Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbZGCIxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbZGCIxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZGCIxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:53:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45974 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZGCIxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:53:46 -0400
Date: Fri, 3 Jul 2009 10:53:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090703085338.GI21833@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net> <20090702064712.GA26690@elte.hu> <1246519076.6384.22.camel@marge.simson.net> <1246536617.4752.15.camel@laptop> <1246605459.6092.189.camel@marge.simson.net> <20090703084109.GA4933@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703084109.GA4933@nowhere>
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

> On Fri, Jul 03, 2009 at 09:17:39AM +0200, Mike Galbraith wrote:
> > On Thu, 2009-07-02 at 14:10 +0200, Peter Zijlstra wrote:
> > > On Thu, 2009-07-02 at 09:17 +0200, Mike Galbraith wrote:
> > > 
> > > >  I've been pondering a perf archive tool
> > > > that would package everything that's needed to do analysis on a
> > > > different box.  One big problem though, is that while you can easily
> > > > package vmlinux and modules, what about all the userland binaries?  A
> > > > large perf.data and/or debug info binaries can easily make transport
> > > > impractical enough.
> > > 
> > > I would simply extend the current file header with another section in
> > > which we do a structured storage of the data structures we currently
> > > build in perf-report. That is, the dso and symbol bits.
> > > 
> > > If we then run perf-report on a file containing such a section we read
> > > that data instead of trying to locate them the regular way.
> > 
> > That's a good idea.
> > 
> > If uname doesn't match stored record time uname, you're not live, so
> > tools require an exportable perf.data.  If you're not live and not on
> > the same host, annotate requires binaries appended via an export tool
> > with --sym-filter -k -u -% whatever capability.
> > 
> > 	-Mike
> 
> 
> Also that would make easier the implementation of a perf compare 
> thing. A perf compare may have several uses, including:
> 
> (1) comparing different workloads with a same executable.
> (2) comparing different executable versions for a same workload
> (3) (1) + (2) ?
> 
> For the (2), having self contained record files as operands would 
> let comparisons based on symbols, pretty useful when you have to 
> compare two different vmlinux (or whatever binary executable).

very good points.

	Ingo
