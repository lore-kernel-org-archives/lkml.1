Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYJFKox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYJFKox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYJFKoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:44:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57255 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbYJFKon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:44:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0810031512420.3045@xanadu.home>
References: <alpine.LFD.2.00.0810031512420.3045@xanadu.home> <alpine.LFD.2.00.0810011110440.3635@xanadu.home> <alpine.LFD.2.00.0809282123100.3635@xanadu.home> <20080924164826.14867.63020.stgit@warthog.procyon.org.uk> <1222426580.16700.258.camel@lappy.programming.kicks-ass.net> <alpine.LFD.2.00.0809260802310.3635@xanadu.home> <1222431635.16700.278.camel@lappy.programming.kicks-ass.net> <29968.1222871650@redhat.com> <1703.1222986215@redhat.com> 
To: Nicolas Pitre <nico@cam.org>
Cc: dhowells@redhat.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
Date: Mon, 06 Oct 2008 11:44:22 +0100
Message-ID: <19168.1223289862@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@cam.org> wrote:

> If so then you're using this interface in an inappropriate way.
> 
> The _absolute_ minimum frequency with which this should be fully 
> executed is once per half period of the base counter.  I hope that in 
> practice it happens far more often than that.

I think you're misunderstanding my contention.

If preemption is enabled, cnt32_to_63() can be called with greater than
minimum frequency and yet reversions can still happen.

The problem is that a process that's half way through executing cnt32_to_63()
can be preempted for a period of time sufficient that when it is rescheduled
and writes __m_cnt_hi, it corrupts it with an out of date value.

David

