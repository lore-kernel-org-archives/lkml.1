Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbXGZLLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbXGZLLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 07:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbXGZLLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 07:11:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54387 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbXGZLLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 07:11:24 -0400
Subject: Re: [bug] SLUB & freeing locks [was: Re: 2.6.23-rc1: known
	regressions with patches]
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <84144f020707260408t1426a1bcs698afd74b344bbb8@mail.gmail.com>
References: <46A47940.7030801@googlemail.com>
	 <20070726091048.GA7366@elte.hu> <1185441963.8197.67.camel@twins>
	 <1185442353.8197.71.camel@twins>
	 <84144f020707260408t1426a1bcs698afd74b344bbb8@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 13:11:15 +0200
Message-Id: <1185448275.8197.79.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 14:08 +0300, Pekka Enberg wrote:
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

Ah, I think you are right, s->size includes all the padding and
redzones.

