Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0BHP6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:58:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0BHP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:58:07 -0500
Subject: Re: [RFC][PATCH] perf_events: Fix FORK events
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100208074438.GC24721@elte.hu>
References: <1265384243.30057.42.camel@laptop>
	 <20100208074438.GC24721@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 16:57:46 +0100
Message-ID: <1265644666.11509.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 08:44 +0100, Ingo Molnar wrote:
> 
> > We could of course just slam the commit in and not worry about it, but
> > that just doesn't feel right.
> 
> Would be nice to figure it out ... 

OK, so it is real simple, patch 22e19085 ("perf: Honour event state for
aux stream data") drops all events for !ACTIVE and newly inherited child
counters are INACTIVE.

So we can either go with the original patch and send the FORK events to
the parent because that's always ACTIVE (already true for COMM and
MMAP), or weaken the state test to < INACTIVE, which would also satisfy
Anton's case because PERF_EVENT_IOC_DISABLE sets events to OFF.



