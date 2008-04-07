Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYDGGUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYDGGUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 02:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYDGGUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 02:20:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35264 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751493AbYDGGUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 02:20:10 -0400
Date: Sun, 6 Apr 2008 23:20:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/10] emm: notifier logic
In-Reply-To: <20080407060602.GE9309@duo.random>
Message-ID: <Pine.LNX.4.64.0804062314080.18728@schroedinger.engr.sgi.com>
References: <20080404223048.374852899@sgi.com> <20080404223131.469710551@sgi.com>
 <20080405005759.GH14784@duo.random> <Pine.LNX.4.64.0804062246030.18148@schroedinger.engr.sgi.com>
 <20080407060602.GE9309@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, Andrea Arcangeli wrote:

> > > My mm_lock solution makes all rcu serialization an unnecessary
> > > overhead so you should remove it like I already did in #v11. If it
> > > wasn't the case, then mm_lock wouldn't be a definitive fix for the
> > > race.
> > 
> > There still could be junk in the cache of one cpu. If you just read the 
> > new pointer but use the earlier content pointed to then you have a 
> > problem.
> 
> There can't be junk, spinlocks provides semantics of proper memory
> barriers, just like rcu, so it's entirely superflous.
> 
> There could be junk only if any of the mmu_notifier_* methods would be
> invoked _outside_ the i_mmap_lock and _outside_ the anon_vma and
> outside the mmap_sem, that is never the case of course.

So we use other locks to perform serialization on the list chains? 
Basically the list chains are protected by either mmap_sem or an rmap 
lock? We need to document that.

In that case we could also add an unregister function.

