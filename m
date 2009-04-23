Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZDWVRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZDWVRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbZDWVRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:17:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbZDWVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:17:40 -0400
Date: Thu, 23 Apr 2009 14:12:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait() and
 co. imply a memory barrier
In-Reply-To: <22170.1240518945@redhat.com>
Message-ID: <alpine.LFD.2.00.0904231410590.3101@localhost.localdomain>
References: <alpine.LFD.2.00.0904231004120.3101@localhost.localdomain> <20090422175753.GA14236@elte.hu> <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com>
 <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> 
 <22170.1240518945@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Apr 2009, David Howells wrote:
> 
> Well, Ingo's point is it could be left up to the caller of wake_up() to supply
> the barrier:
> 
> 	*my_variable = 1234;
> 	smp_wmb();
> 	wake_up(&my_queue);

That's bogus.

EVERY SINGLE wake_up() would need it.

There is _always_ a reason for the wakeup. And yes, you can re-order 
things, but we normally don't. Just make the rule be that there's an 
implied smp_wmb() instead.

It's not like it's going to cost anything on any sane architecture anyway. 
So asking people to add "smp_wmb()" calls before their wakups just makes 
the source code unreadable and fragile, for no actual advantage.

		Linus
