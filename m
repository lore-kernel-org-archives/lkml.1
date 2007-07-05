Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbXGEJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbXGEJBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbXGEJBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:01:17 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:6003 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753177AbXGEJBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:01:16 -0400
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <1183625889.3818.14.camel@johannes.berg>
References: <1183583529.9662.34.camel@johannes.berg>
	 <20070705085304.GC3476@elte.hu>  <1183625889.3818.14.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 11:01:10 +0200
Message-Id: <1183626070.7054.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 10:58 +0200, Johannes Berg wrote:
> On Thu, 2007-07-05 at 10:53 +0200, Ingo Molnar wrote:
> 
> > > +#ifdef CONFIG_LOCKDEP
> > > +/*
> > > + * HACK! This really should call lockdep_init_map() but can't
> > > + * because there's no requirement to initialise work structs
> > > + * at runtime. This works because subclass == 0.
> > > + *
> > > + * NB: because we have to copy the lockdep_map, setting .key
> > > + * here is required!
> > > + */
> > 
> > why do you consider this a hack? A static object is a static object, and 
> > its own address is its key. That's what we have for like 80% of all the 
> > spinlocks in the kernel. Static initialization is not as flexible as 
> > dynamic initialization, but the lockdep engine handles it. Am i missing 
> > something?
> 
> Well, there's nothing in lockdep that guarantees that. I'd be much more
> comfortable doing that when lockdep had a STATIC_LOCKDEP_MAP_INIT()
> macro that looks like my __WORK_INIT_LOCKDEP_MAP() macro because then
> people changing lockdep would see that they cannot rely on
> lockdep_init_map() having been called (unless subclass != 0)

You could of course make this STATIC_LOCKDEP_MAP_INIT() and place it
near lockdep_init_map() :-)

That way it would be clear that changes to either ought to be reflected
in the other.

