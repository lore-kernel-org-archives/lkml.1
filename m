Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZD1Ja2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZD1Ja2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZD1JaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:30:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbZD1JaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:30:11 -0400
Date: Tue, 28 Apr 2009 11:29:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428092918.GC21085@elte.hu>
References: <20090428010907.912554629@intel.com> <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu> <20090428074031.GK27382@one.firstfloor.org> <1240909484.1982.16.camel@penberg-laptop> <20090428091508.GA21085@elte.hu> <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> I have no idea how expensive tracepoints are but I suspect they 
> don't make too much sense for this particular scenario. After all, 
> kmemtrace is mainly interested in _allocation patterns_ whereas 
> this patch seems to be more interested in "memory layout" type of 
> things.

My point is that the allocation patterns can be derived from dynamic 
events. We can build a map of everything if we know all the events 
that led up to it. Doing:

  echo 3 > /proc/sys/vm/drop_caches

will clear 99% of the memory allocations, so we can build a new map 
from scratch just about anytime. (and if boot allocations are 
interesting they can be traced too)

_And_ via this angle we'll also have access to the dynamic events, 
in a different 'view' of the same tracepoints - which is obviously 
very useful for different purposes.

	Ingo
