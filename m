Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbXLCJmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbXLCJmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbXLCJmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:42:37 -0500
Received: from mga10.intel.com ([192.55.52.92]:63159 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750774AbXLCJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:42:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,243,1194249600"; 
   d="scan'208";a="221945658"
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071203084557.GA13156@elte.hu>
References: <1196155985.25646.31.camel@ymzhang>
	 <200711301429.15664.nickpiggin@yahoo.com.au>
	 <20071130100845.GB2201@elte.hu>
	 <200712031527.57129.nickpiggin@yahoo.com.au>
	 <20071203084557.GA13156@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Mon, 03 Dec 2007 17:41:09 +0800
Message-Id: <1196674869.25646.142.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-03 at 09:45 +0100, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > On Friday 30 November 2007 21:08, Ingo Molnar wrote:
> > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > Haven't we been asking JVMs to use futexes or posix locking for years
> > > > and years now? [...]
> > >
> > > i'm curious, with what JVM was it tested and where's the source so i 
> > > can fix their locking for them? Can the problem be reproduced with:
> > 
> > Sure, but why shouldn't the compat behaviour be the default, and the 
> > sysctl go away?
> > 
> > It makes older JVMs work better, it is slightly closer to the old 
> > behaviour, and it is arguably a less surprising result.
> 
> as far as desktop apps such as firefox goes, the exact opposite is true. 
> We had two choices basically: either a "more agressive" yield than 
> before or a "less agressive" yield. Desktop apps were reported to hurt 
> from a "more agressive" yield (firefox for example gets some pretty bad 
> delays),
Why not to change source codes of firefox? If the sched_compat_yield=0,
the sys_sched_yield almost does nothing but returns, so firefox could just
do not call sched_yield. I assume 'sched_compat_yield=0' ~ no_call_to_sched_yield.

It's easier to delete calls to sched_yield in applications than to tune
calls to sched_yield.

>  so we defaulted to the less agressive method. (and we defaulted 
> to that in v2.6.23 already) Really, in this sense volanomark is another 
> test like dbench - we care about it but not unconditionally and in this 
> case it's a really silly API use that is at the center of the problem. 
> Talking about the default alone will not bring us forward, but we can 
> certainly add helpers to identify SCHED_OTHER::yield tasks - a once per 
> bootup warning perhaps?
> 
> 	Ingo
