Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZGCHgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZGCHgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZGCHgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:36:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:48819 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751401AbZGCHgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:36:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/uNms5obTunn+KqXTnNgm+VNlWsJK6bOYIi5Hfnu
	lWkcV4zSImNbqA
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
 kernel modules
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090703072717.GB7943@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net>
	 <20090702064712.GA26690@elte.hu>
	 <1246519076.6384.22.camel@marge.simson.net>
	 <20090702074214.GA19187@elte.hu> <1246521342.8681.5.camel@marge.simson.net>
	 <20090703072717.GB7943@elte.hu>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 09:36:25 +0200
Message-Id: <1246606585.6257.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 09:27 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Thu, 2009-07-02 at 09:42 +0200, Ingo Molnar wrote:
> > 
> > (squirrels suggestions away for later reference)
> > 
> > > Btw, another thing: we are thinking about making -F 1000 (1 KHz 
> > > auto-freq sampling) the default for perf top and perf record. This 
> > > way we'd always gather enough data (and never too much or too little 
> > > data), regardless of the intensity of the workload. Have you played 
> > > with -F before, what's your general experience about it? It's 
> > > particularly useful for 'rare' and highly fluctuating events like 
> > > cache-misses.
> > > 
> > > Maybe 1KHz is a bit too low - Oprofile defaults to 100000 cycles 
> > > interval by default which is about 10 KHz on a 1GHz box and 30 
> > > KHz on a 3GHz box. Perhaps 10 KHz is a better default?
> > 
> > My default usage is 1000Hz to keep overhead low.  Works fine for 
> > me.
> 
> ah, so you use -F by default?

Yes.

> I still think 10 KHz would be better - especially for really short 
> runs like 'perf record -f -g ./git gc'. Since Oprofile samples at 26 
> KHz by default, we must not go to a too low frequency, otherwise 
> people might get a 'hm, the perf profiles are worse than the 
> Oprofile ones' first impression ...
> 
> We could perhaps add a freq=1000 switch to .perfconfig - we have 
> Git's util/config.c facility - it's just unused right now ;-)
> 
> [ Look at the Git sources about how config.c is used. ]

Yeah, that's a good idea.. everyone can roll their own defaults.

For me, it doesn't matter what the default is, I always specify.

	-Mike

