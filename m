Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZDPJLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZDPJLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZDPJLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:11:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48383 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbZDPJLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:11:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090415162712.342d4c07.akpm@linux-foundation.org>
References: <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Trond.Myklebust@netapp.com, serue@us.ibm.com, steved@redhat.com,
       viro@zeniv.linux.org.uk, Daire.Byrne@framestore.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Date: Thu, 16 Apr 2009 10:10:18 +0100
Message-ID: <14561.1239873018@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> The patch itself is a little worrisome.  The wake-all semantics are
> very good at covering up little race bugs.  And switching to wake-once
> is a great way of exposing hitherto-unsuspected races.

It's something I'm intending to test, once I get MN10300 working again (which
for some reason it isn't).

> I wonder if slow_work_cull_timeout() should have some sort of barrier,
> so the write is suitably visible to the woken thread.

That's an interesting question.  Should wake_up() imply a barrier of any sort,
I wonder.  Well, __wake_up() does impose a barrier as it uses a spinlock, but
I wonder if that's sufficient.

> Bearing in mind that the thread might _already_ have been woken by someone
> else?

If the thread is woken by someone else, there must be work for it to do, in
which case it wouldn't be culled anyway.

> off-topic: afacit the code will cull a maximum of one thread per five
> seconds.  But the rate of thread _creation_ is, afacit, unbound.  Are
> there scenarios in which we can get a runaway thread count?

The maximum number of threads is limited (slow_work_max_threads).

David
