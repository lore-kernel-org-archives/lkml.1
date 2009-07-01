Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZGAVLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZGAVLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZGAVL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:11:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44787 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZGAVL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:11:26 -0400
Date: Wed, 1 Jul 2009 23:11:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
Message-ID: <20090701211117.GC631@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 1 Jul 2009, David Howells wrote:
> > +
> > +#define ATOMIC64_INIT(i)	{ (i) }
> > +#define atomic64_read(v)	((v)->counter)
> > +#define atomic64_set(v, i)	(((v)->counter) = (i))
> 
> These seem to be buggy.
> 
> At least "atomic64_read()" needs to make sure to actually read it 
> atomically - otherwise you'll do two 32-bit reads, and that just 
> gets crap. Imagine if somebody is adding 1 to 0x00000000ffffffff, 
> and then "atomic64_read()" reads it as two accesses in the wrong 
> place, and gets either 0, or 0x00000001ffffffff, both of which are 
> totally incorrect.
> 
> The case of 'atomic64_set()' is _slightly_ less clear, because I 
> think we use it mostly for initializers, so atomicity is often not 
> strictly required. But at least on x86, we do guarantee that it 
> sets it atomically too.
> 
> Btw, Ingo: I looked at the x86-32 versions to be sure, and noticed 
> a couple of buglets:

thanks - we'll fix these!

	Ingo
