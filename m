Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYFZJR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYFZJR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYFZJRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:17:49 -0400
Received: from styx.suse.cz ([82.119.242.94]:49491 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753846AbYFZJRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:17:48 -0400
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
	with irqs disable
From: Petr Tesarik <ptesarik@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <48630420.1090102@goop.org>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	 <20080507073017.GJ32195@elte.hu>
	 <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
	 <1214241561.19392.21.camel@elijah.suse.cz>
	 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
	 <1214253593.11254.30.camel@twins>
	 <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>
	 <1214254730.11254.34.camel@twins>  <48630420.1090102@goop.org>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Thu, 26 Jun 2008 11:17:47 +0200
Message-Id: <1214471867.17319.8.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 19:51 -0700, Jeremy Fitzhardinge wrote:
> [...]
> I'm experimenting with adding pvops hook to allow you to put in new 
> spinlock implementations on the fly.  If nothing else, it will be useful 
> for experimenting with different algorithms.  But it definitely seems 
> like the old unfair lock algorithm played much better with a virtual 
> environment, because the next cpu to get the lock is the next one the 
> scheduler gives time, rather than dictating an order - and the scheduler 
> should mitigate the unfairness that ticket locks were designed to solve.

We really should paravirtualize spin locks, because there's always
something better to do than just burn time spinning. But in a
non-virtualized environment, tickets (or a similar scheme) should be
preserved.

We should probably re-think the whole locking scheme, because spinlocks
were designed to be held for a short period of time. This was a fair
assumption when they were introduced, but obviously it is now false in
many cases (such as virtualization).

Ticket-based spinlocks have actually already changed the original
design, so why not implement a generic "lock scheduler" on top of
spinlock_t and rwlock_t?

Petr Tesarik


