Return-Path: <linux-kernel-owner+w=401wt.eu-S935058AbXGZRrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935058AbXGZRrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934751AbXGZRrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:47:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47427 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764410AbXGZRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:47:14 -0400
Date: Thu, 26 Jul 2007 10:47:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] SLUB & freeing locks [was: Re: 2.6.23-rc1: known regressions
 with patches]
In-Reply-To: <84144f020707260408t1426a1bcs698afd74b344bbb8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707261046370.2374@schroedinger.engr.sgi.com>
References: <46A47940.7030801@googlemail.com> <20070726091048.GA7366@elte.hu>
  <1185441963.8197.67.camel@twins> <1185442353.8197.71.camel@twins>
 <84144f020707260408t1426a1bcs698afd74b344bbb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Pekka Enberg wrote:

> On 7/26/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > --- linux-2.6.orig/mm/slub.c
> > +++ linux-2.6/mm/slub.c
> > @@ -1656,6 +1656,7 @@ static void __always_inline slab_free(st
> >         unsigned long flags;
> > 
> >         local_irq_save(flags);
> > +       debug_check_no_locks_freed(object, s->size);
> 
> Although it doesn't matter much, I think this should be s->objsize. Christoph?

Correct. Locks can only be in the first objsize range of bytes.


