Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZF2Way@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZF2Way (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZF2Waq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:30:46 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42111 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752298AbZF2Waq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:30:46 -0400
Date: Mon, 29 Jun 2009 18:30:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@cs.helsinki.fi,
       mpm@selenic.com, jdb@comx.dk
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem
 in sl[aou]b
In-Reply-To: <20090625193137.GA16861@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0906291827050.21956@gentwo.org>
References: <20090625193137.GA16861@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Paul E. McKenney wrote:

> Jesper noted that kmem_cache_destroy() invokes synchronize_rcu() rather
> than rcu_barrier() in the SLAB_DESTROY_BY_RCU case, which could result
> in RCU callbacks accessing a kmem_cache after it had been destroyed.
>
> The following untested (might not even compile) patch proposes a fix.

It could be seen to be the responsibility of the caller of
kmem_cache_destroy to insure that no accesses are pending.

If the caller specified destroy by rcu on cache creation then he also
needs to be aware of not destroying the cache itself until all rcu actions
are complete. This is similar to the caution that has to be execised then
accessing cache data itself.


