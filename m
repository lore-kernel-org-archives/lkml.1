Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYFWUj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYFWUj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYFWUjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:39:52 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:61557 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYFWUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:39:51 -0400
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
	with irqs disable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	 <20080507073017.GJ32195@elte.hu>
	 <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
	 <1214241561.19392.21.camel@elijah.suse.cz>
	 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 22:39:53 +0200
Message-Id: <1214253593.11254.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 11:20 -0700, Christoph Lameter wrote:
> On Mon, 23 Jun 2008, Petr Tesarik wrote:
> 
> > Maybe I'm just blind, but doesn't this change effectively disable any
> > arch-specific optimized code for _raw_*_lock?
> 
> True.  Only the __raw_xxx_trylock is still used.
> 
> > If CONFIG_DEBUG_LOCK_ALLOC is set, then CONFIG_DEBUG_SPINLOCK must also
> > be set, so in that case the debugging versions of _raw_*_lock are used.
> > But if CONFIG_DEBUG_LOCK_ALLOC is _not_ set, then the locks are built
> > with _trylock and _can_lock primitives.
> > 
> > What am I missing here?
> 
> It is good that the locks are build with _trylock and _can_lock because 
> then we can reenable interrupts while spinning.

Well, good and bad, the turn side is that fairness schemes like ticket
locks are utterly defeated.

