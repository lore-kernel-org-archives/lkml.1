Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129Ab0AUJzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0AUJzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077Ab0AUJzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:55:08 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:57772 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755051Ab0AUJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:55:07 -0500
Date: Thu, 21 Jan 2010 20:54:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Don Mullis <don.mullis@gmail.com>, linux-kernel@vger.kernel.org,
       airlied@redhat.com, andi@firstfloor.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
Message-ID: <20100121095434.GA25842@discord.disaster>
References: <87fx609i29.fsf@gmail.com> <1264065775.3032.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264065775.3032.18.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:22:55AM +0200, Artem Bityutskiy wrote:
> On Wed, 2010-01-20 at 20:51 -0800, Don Mullis wrote:
> > The use of list_sort() by UBIFS looks like it could generate long
> > lists; this alternative implementation scales better, reaching ~3x
> > performance gain as list length approaches the L2 cache size.
> > 
> > Stand-alone program timings were run on a Core 2 duo L1=32KB L2=4MB,
> > gcc-4.4, with flags extracted from an Ubuntu kernel build.  Object
> > size is 552 bytes versus 405 for Mark J. Roberts' code.
> > 
> > Worst case for either implementation is a list length just over a POT,
> > and to roughly the same degree, so here are results for a range of
> > 2^N+1 lengths.  List elements were 16 bytes each including malloc
> > overhead; random initial order.
> > 
> 
> Could you please add a debugging function which would be compiled-out
> normally, and which would check that on the output 'list_sort()' gives
> really sorted list, and number of elements in the list stays the same.
> You'd call this function before returning from list_sort(). Something
> like:
> 
> #ifdef DEBUG_LIST_SORT
> static int list_check(void *priv, struct list_head *head,
>                       int (*cmp)(void *priv, struct list_head *a,
>                                  struct list_head *b))
> {
>    /* Checking */
> }
> #else
> #define list_check(priv, head, cmp) 0
> #endif
> 
> This will provide more confidence in the algorithm correctness for
> everyone who modifies 'list_sort()'.

I'd suggest the same method as employed in lib/sort.c - a
simple userspace program that verifies correct operation is included
in lib/sort.c....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
