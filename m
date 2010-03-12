Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab0CLXlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:41:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab0CLXll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:41:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B9A6033.8010705@s5r6.in-berlin.de>
References: <4B9A6033.8010705@s5r6.in-berlin.de> <20100311172055.7328.51353.stgit@warthog.procyon.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       sgruszka@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Document Linux's circular buffering capabilities
Date: Fri, 12 Mar 2010 23:41:08 +0000
Message-ID: <18180.1268437268@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> "...do this" could be misunderstood as "use a modulus instruction",
> although the heading says that this section is about 2^n sized buffers.
> How about reversing the leading paragraph?
> 
>     Calculating the occupied or free space of a circular buffer involves
>     a somewhat slow modulus operation.  But if the buffer size is an
>     exact power of 2, a quick bitwise AND can be used instead.
> 
>     There is a set of macros which do the latter, that can be made use
>     of by [...]

How about:

	Calculation of the occupancy or the remaining capacity of an
	arbitrarily sized circular buffer would normally be a slow operation,
	requiring the use of a modulus (divide) instruction.  However, if the
	buffer is of a power-of-2 size, then a much quicker bitwise-AND
	instruction can be used instead.

	Linux provides a set of macros for handling power-of-2 circular
	buffers.  These can be made use of by:
	...

> > +Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
> > +This prevents the compiler from discarding and reloading its cached value -
> > +which some compilers will do, even after an implied compiler barrier.
> 
> I don't understand why ACCESS_ONCE is needed here.  The CIRC_SPACE and
> CIRC_CNT macros do not look at head and tail more than once.

In this example they don't, but say someone wants to read several elements
from the buffer, they might end up accessing their copy of head several times.

If you only access it once anyway, ACCESS_ONCE() shouldn't hurt.

David
