Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZF3NXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZF3NXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZF3NXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:23:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:52431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZF3NXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:23:36 -0400
Subject: Re: [PATCH 2/3 -tip] perf_counter tools: Add support to set of
 multiple events in one shot
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090630095738.GD6942@elte.hu>
References: <1246051852.2988.8.camel@hpdv5.satnam>
	 <1246051927.2988.10.camel@hpdv5.satnam>
	 <1246051996.2988.12.camel@hpdv5.satnam> <20090627163821.GA17638@elte.hu>
	 <1246129498.32198.27.camel@hpdv5.satnam> <20090628132926.GD31988@elte.hu>
	 <1246202166.2982.8.camel@hpdv5.satnam> <20090629035708.GD8059@elte.hu>
	 <1246351114.2476.38.camel@ht.satnam>  <20090630095738.GD6942@elte.hu>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 18:52:45 +0530
Message-Id: <1246368165.2434.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 11:57 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Mon, 2009-06-29 at 05:57 +0200, Ingo Molnar wrote:
> > 
> > > The above patterns i suggested _already cover_ 'multiple events'.
> > > 
> > > We might define further aliases like:
> > > 
> > > 	all := "*"
> > >         all-sw := "sw-*"
> > > 
> > > but it should all be in terms of patterns and regular 
> > > expressions, not via some hardcoded special-case thing as your 
> > > posted patches did.
> > > 
> > 
> > It seems to me very confusing and needs lot of book-keeping and 
> > need to rewrite whole tools/perf/util/parse-events.c because :
> > 
> > * means all perf_event_types :
> > 	PERF_TYPE_HARDWARE,
> >         PERF_TYPE_SOFTWARE,
> >         PERF_TYPE_TRACEPOINT,
> >         PERF_TYPE_HW_CACHE,
> >         PERF_TYPE_RAW
> > 
> > hw-* means all hardware events :
> > 	PERF_TYPE_HARDWARE,
> >         PERF_TYPE_HW_CACHE,
> >         PERF_TYPE_RAW
> > 
> > sw-* means all software events :
> >         PERF_TYPE_SOFTWARE,
> >         PERF_TYPE_TRACEPOINT
> > 
> > *cache* means all cache based events :
> > 	PERF_COUNT_CACHE_REFERENCES, 	/* Generalized H/W */
> > 	PERF_COUNT_CACHE_MISSES,	/* Generalized H/W */
> >         PERF_TYPE_HW_CACHE,		/* Generalized Cache */
> > 
> > *write* means all write based events :
> > 	(L1D,       WRITE,          ACCESS),
> > 	(L1D,       WRITE,          MISS),
> > 	(LL,        WRITE,          ACCESS),
> > 	(LL,        WRITE,          MISS),
> > 	(DTLB,      WRITE,          ACCESS),
> > 	(DTLB,      WRITE,          MISS)
> > 
> > Please let me know why it looks complex to me, is it really 
> > complex or I am going in wrong direction.
> 
> It would certainly need some reorganization of the code but the end 
> result would be more flexible and other places could use it too, for 
> example:
> 
> 	perf test -e hw-*
> 
> would test all (known) hardware counters.
> 

Its true.

Can you please verify that the assumptions I made above are correct.

Thanks,
--
JSR

