Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZDVPNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZDVPNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZDVPNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:13:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45855 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbZDVPNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:13:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090422135134.GA5249@elte.hu>
References: <20090422135134.GA5249@elte.hu> <20090416143351.GD6532@redhat.com> <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Trond.Myklebust@netapp.com,
       serue@us.ibm.com, steved@redhat.com, viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a full memory barrier
Date: Wed, 22 Apr 2009 16:12:06 +0100
Message-ID: <4664.1240413126@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> No. They dont generally imply a full memory barrier versus any
> arbitrary prior (or following) memory access.
>
> try_to_wake_up() has an smp_wmb() so it is a write memory barrier
> (but not necessarily a read memory barrier). Otherwise there are
> spinlocks there but spinlocks are not explicit 'full memory
> barriers'.

Blech.  That's a good point LOCK...UNLOCK does not imply a full barrier.

So we can't assume that complete(), wake_up() and co. imply any barriers.

All we can assume is that try_to_wake_up() implies a write barrier, but we
can't assume that that will be called via __wake_up_common().

David
