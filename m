Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZDVPUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZDVPUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZDVPT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:19:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59734 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZDVPT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:19:59 -0400
Date: Wed, 22 Apr 2009 17:19:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Trond.Myklebust@netapp.com, serue@us.ibm.com, steved@redhat.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a
	full memory barrier
Message-ID: <20090422151909.GA18224@elte.hu>
References: <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <4664.1240413126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4664.1240413126@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > No. They dont generally imply a full memory barrier versus any
> > arbitrary prior (or following) memory access.
> >
> > try_to_wake_up() has an smp_wmb() so it is a write memory barrier
> > (but not necessarily a read memory barrier). Otherwise there are
> > spinlocks there but spinlocks are not explicit 'full memory
> > barriers'.
> 
> Blech.  That's a good point LOCK...UNLOCK does not imply a full 
> barrier.
> 
> So we can't assume that complete(), wake_up() and co. imply any 
> barriers.
> 
> All we can assume is that try_to_wake_up() implies a write 
> barrier, but we can't assume that that will be called via 
> __wake_up_common().

Yeah, it's all too special-case. We might rely on it in special, 
well-argued cases but we should not document it as a general barrier 
property.

	Ingo
