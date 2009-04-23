Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZDWUjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZDWUjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZDWUi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:38:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49235 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbZDWUi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:38:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090423163624.GA6732@redhat.com>
References: <20090423163624.GA6732@redhat.com> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <20090422175753.GA14236@elte.hu> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a full memory barrier
Date: Thu, 23 Apr 2009 21:37:14 +0100
Message-ID: <22193.1240519034@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Well. I think in that case almost every try_to_wake_up/wake_up_process
> needs mb().

Not exactly.  They need smp_wmb() in the wake_up() path - unless they use
locks, which a lot of cases do.

David
