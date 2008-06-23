Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbYFWSUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbYFWSUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYFWSUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:20:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47620 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755331AbYFWSUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:20:10 -0400
Date: Mon, 23 Jun 2008 11:20:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Petr Tesarik <ptesarik@suse.cz>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
In-Reply-To: <1214241561.19392.21.camel@elijah.suse.cz>
Message-ID: <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> 
 <20080507073017.GJ32195@elte.hu>  <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
 <1214241561.19392.21.camel@elijah.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Petr Tesarik wrote:

> Maybe I'm just blind, but doesn't this change effectively disable any
> arch-specific optimized code for _raw_*_lock?

True.  Only the __raw_xxx_trylock is still used.

> If CONFIG_DEBUG_LOCK_ALLOC is set, then CONFIG_DEBUG_SPINLOCK must also
> be set, so in that case the debugging versions of _raw_*_lock are used.
> But if CONFIG_DEBUG_LOCK_ALLOC is _not_ set, then the locks are built
> with _trylock and _can_lock primitives.
> 
> What am I missing here?

It is good that the locks are build with _trylock and _can_lock because 
then we can reenable interrupts while spinning.


