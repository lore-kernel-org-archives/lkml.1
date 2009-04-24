Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbZDXRza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbZDXRza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZDXRzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:55:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35274 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbZDXRzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:55:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090424172845.GB13026@redhat.com>
References: <20090424172845.GB13026@redhat.com> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <26028.1240573601@redhat.com> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait() and co. imply a memory barrier
Date: Fri, 24 Apr 2009 18:53:45 +0100
Message-ID: <27944.1240595625@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Suppose that "event_indicated = 1" leaks into try_to_wake_up() after we
> read p->state.

In that case, it's entirely possible that the smp_wmb() in try_to_wake_up()
should actually be an smp_mb(), but that on whichever arch patch:

	commit 04e2f1741d235ba599037734878d72e57cb302b5
	Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
	Date:   Sat Feb 23 18:05:03 2008 -0800
	Subject: Add memory barrier semantics to wake_up() & co

was tested on, it made no difference.

David
