Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZGCH1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZGCH1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZGCH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:27:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbZGCH1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:27:30 -0400
Date: Fri, 3 Jul 2009 09:27:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090703072717.GB7943@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net> <20090702064712.GA26690@elte.hu> <1246519076.6384.22.camel@marge.simson.net> <20090702074214.GA19187@elte.hu> <1246521342.8681.5.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246521342.8681.5.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Thu, 2009-07-02 at 09:42 +0200, Ingo Molnar wrote:
> 
> (squirrels suggestions away for later reference)
> 
> > Btw, another thing: we are thinking about making -F 1000 (1 KHz 
> > auto-freq sampling) the default for perf top and perf record. This 
> > way we'd always gather enough data (and never too much or too little 
> > data), regardless of the intensity of the workload. Have you played 
> > with -F before, what's your general experience about it? It's 
> > particularly useful for 'rare' and highly fluctuating events like 
> > cache-misses.
> > 
> > Maybe 1KHz is a bit too low - Oprofile defaults to 100000 cycles 
> > interval by default which is about 10 KHz on a 1GHz box and 30 
> > KHz on a 3GHz box. Perhaps 10 KHz is a better default?
> 
> My default usage is 1000Hz to keep overhead low.  Works fine for 
> me.

ah, so you use -F by default?

I still think 10 KHz would be better - especially for really short 
runs like 'perf record -f -g ./git gc'. Since Oprofile samples at 26 
KHz by default, we must not go to a too low frequency, otherwise 
people might get a 'hm, the perf profiles are worse than the 
Oprofile ones' first impression ...

We could perhaps add a freq=1000 switch to .perfconfig - we have 
Git's util/config.c facility - it's just unused right now ;-)

[ Look at the Git sources about how config.c is used. ]

	Ingo
