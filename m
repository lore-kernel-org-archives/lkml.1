Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYDRXHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYDRXHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYDRXGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:06:54 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41478 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751793AbYDRXGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:06:53 -0400
Date: Fri, 18 Apr 2008 16:06:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slub: add hooks for kmemcheck
In-Reply-To: <19f34abd0804181527i3b65e82bk2a5d8b3c2b196f9e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804181604310.4046@schroedinger.engr.sgi.com>
References: <20080418220339.GC16586@damson.getinternet.no> 
 <Pine.LNX.4.64.0804181507130.31394@schroedinger.engr.sgi.com>
 <19f34abd0804181527i3b65e82bk2a5d8b3c2b196f9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008, Vegard Nossum wrote:

> We set it to zero to allow the compiler to optimize out code if
> CONFIG_KMEMCHECK=n. For instance
> 
>         if (kmemcheck_page_is_tracked(page) && !(s->flags & SLAB_NOTRACK)) {
> 
> Will be turned into if(0 && !(s->flags & 0)), which can be completely
> optimized away. On the other hand, if SLAB_NOTRACK is non-zero, this
> is not the case, since the flag must be tested.

The compiler will optize it again regardless of SLAB_NOTRACK. if (0 && 
whatever) is still 0.

> >  Should this not go into some kmemcheck.h file?
> 
> The implementations of these prototypes are in mm/slub_kmemcheck.c.
> They are only ever called from slub.c since they represent the
> interface between SLUB and kmemcheck.
> 
> Would you rather have it in include/linux/slub_kmemcheck.h?

Well lets see what Pekka says.

> Currently, with SLAB/SLUB debugging enabled, the page flag will be
> cleared, then accessed in check_object(), thus generating a few
> accesses to the page. It is safer to delay the clearing of the page
> flag until no more accesses can be generated for the page.

Hmmmm.. Okay that is already dealt with by a patch in Pekka's tree.
