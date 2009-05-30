Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZE3WP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZE3WP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZE3WPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:15:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZE3WPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:15:14 -0400
Date: Sun, 31 May 2009 00:14:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Larry H." <research@subreption.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530221444.GB23204@elte.hu>
References: <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com> <4A20E601.9070405@cs.helsinki.fi> <20090530082048.GM29711@oblivion.subreption.com> <20090530173428.GA20013@elte.hu> <20090530180333.GH6535@oblivion.subreption.com> <84144f020905301322g7bbdd42cpe1391c619ffda044@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905301322g7bbdd42cpe1391c619ffda044@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> Hi Larry,
> 
> On Sat, May 30, 2009 at 9:03 PM, Larry H. <research@subreption.com> wrote:
> > The first issue is that SLOB has a broken ksize, which won't take into
> > consideration compound pages AFAIK. To fix this you will need to
> > introduce some changes in the way the slob_page structure is handled,
> > and add real size tracking to it. You will find these problems if you
> > try to implement a reliable kmem_ptr_validate for SLOB, too.
> 
> Does this mean that kzfree() isn't broken for SLAB/SLUB? Maybe I 
> read your emails wrong but you seemed to imply that.

Yep, he definitely wrote that:

    http://lkml.org/lkml/2009/5/30/30

 [...]
 |
 | That's hopeless, and kzfree is broken. Like I said in my earlier 
 | reply, please test that yourself to see the results. Whoever 
 | wrote that ignored how SLAB/SLUB work and if kzfree had been used 
 | somewhere in the kernel before, it should have been noticed long 
 | time ago.
 |
 [...]

Very puzzling claims i have to say.

	Ingo
