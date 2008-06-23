Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYFWU64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYFWU64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYFWU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:58:49 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:40429 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYFWU6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:58:48 -0400
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
	with irqs disable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	 <20080507073017.GJ32195@elte.hu>
	 <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
	 <1214241561.19392.21.camel@elijah.suse.cz>
	 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
	 <1214253593.11254.30.camel@twins>
	 <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 22:58:50 +0200
Message-Id: <1214254730.11254.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 13:45 -0700, Christoph Lameter wrote:
> On Mon, 23 Jun 2008, Peter Zijlstra wrote:
> 
> > > It is good that the locks are build with _trylock and _can_lock because 
> > > then we can reenable interrupts while spinning.
> > 
> > Well, good and bad, the turn side is that fairness schemes like ticket
> > locks are utterly defeated.
> 
> True. But maybe we can make these fairness schemes more generic so that 
> they can go into core code?

The trouble with ticket locks is that they can't handle waiters going
away - or in this case getting preempted by irq handlers. The one who
took the ticket must pass it on, so if you're preempted it just sits
there being idle, until you get back to deal with the lock.

But yeah, perhaps another fairness scheme might work in the generic
code..

