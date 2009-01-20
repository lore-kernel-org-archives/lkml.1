Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbZATOSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbZATOSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762901AbZATOSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:18:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762889AbZATOSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:18:18 -0500
Date: Tue, 20 Jan 2009 15:17:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120141735.GA9474@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu> <20090120141454.GI19505@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120141454.GI19505@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> On Tue, Jan 20, 2009 at 03:03:24PM +0100, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > Times I believe are in nanoseconds for lmbench, anyway lower is 
> > > > better.
> > > > 
> > > > non pv   AVG=464.22 STD=5.56
> > > > paravirt AVG=502.87 STD=7.36
> > > > 
> > > > Nearly 10% performance drop here, which is quite a bit... hopefully 
> > > > people are testing the speed of their PV implementations against 
> > > > non-PV bare metal :)
> > > 
> > > Ouch, that looks unacceptably expensive. All the major distros turn 
> > > CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
> > > promise to have no measurable runtime overhead.
> > 
> > Here are some more precise stats done via hw counters on a perfcounters 
> > kernel using 'timec', running a modified version of the 'mmap performance 
> > stress-test' app i made years ago.
> > 
> > The MM benchmark app can be downloaded from:
> > 
> >    http://redhat.com/~mingo/misc/mmap-perf.c
> 
> BTW. the lmbench test I run directly (it's called lat_mmap.c, and gets 
> compiled into a standalone lat_mmap exec by the standard lmbench build).

doesnt that include an indeterminate number of gettimeofday() based 
calibration calls? That would make it harder to measure its total costs in 
a comparative way.

	Ingo
