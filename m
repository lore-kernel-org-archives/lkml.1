Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYFZRlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYFZRlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYFZRlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:41:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52465 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751166AbYFZRlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:41:01 -0400
Date: Thu, 26 Jun 2008 10:02:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Petr Tesarik <ptesarik@suse.cz>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
In-Reply-To: <1214471867.17319.8.camel@elijah.suse.cz>
Message-ID: <Pine.LNX.4.64.0806261001310.7369@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> 
 <20080507073017.GJ32195@elte.hu>  <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com> 
 <1214241561.19392.21.camel@elijah.suse.cz> 
 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com> 
 <1214253593.11254.30.camel@twins>  <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>
  <1214254730.11254.34.camel@twins>  <48630420.1090102@goop.org>
 <1214471867.17319.8.camel@elijah.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Petr Tesarik wrote:

> We should probably re-think the whole locking scheme, because spinlocks
> were designed to be held for a short period of time. This was a fair
> assumption when they were introduced, but obviously it is now false in
> many cases (such as virtualization).

And NUMA.

> Ticket-based spinlocks have actually already changed the original
> design, so why not implement a generic "lock scheduler" on top of
> spinlock_t and rwlock_t?

How about making the semaphore / mutex code as fast as spinlocks and just 
use that?

