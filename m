Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYLSWMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYLSWMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbYLSWDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:03:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54786 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444AbYLSWDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:03:14 -0500
Date: Fri, 19 Dec 2008 23:02:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
Message-ID: <20081219220255.GJ2351@elte.hu>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com> <20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com> <84144f020812191208x66f26bc9tf087b35b6c90662a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020812191208x66f26bc9tf087b35b6c90662a@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, Dec 19, 2008 at 8:13 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > This patch adds the base support for the kernel memory leak
> > detector. It traces the memory allocation/freeing in a way similar to
> > the Boehm's conservative garbage collector, the difference being that
> > the unreferenced objects are not freed but only shown in
> > /sys/kernel/debug/kmemleak. Enabling this feature introduces an
> > overhead to memory allocations.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Looks good to me. I have only reviewed this lightly but all my major 
> concerns have been addressed so feel free to add my:
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Andrew, do you have any principial objections against having this in 
v2.6.29?

This dragged on for a long time, and i think the debug output is useful 
and it tells us something that we have no other tool for at the moment to 
figure out. We can tell stuck tasks, stuck files and other stuck resources 
easily - we can even see fast slab leaks, but we cannot really tell slow, 
long-term slab leaks apart from regular slab prints, and we cannot 
identify the source of them. The false positive rate of kmemleak has 
decreased substantially as well, over the earlier design.

	Ingo
