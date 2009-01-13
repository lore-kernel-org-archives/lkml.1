Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbZAMLvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbZAMLvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZAMLuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:50:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZAMLuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:50:51 -0500
Date: Tue, 13 Jan 2009 12:50:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christophe Saout <christophe@saout.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Re: OOPS and panic on 2.6.29-rc1 on xen-x86
Message-ID: <20090113115029.GA12055@elte.hu>
References: <20090112172613.GA8746@shion.is.fushizen.net> <3e8340490901122054q4af2b4cm3303c361477defc0@mail.gmail.com> <1231838731.4823.2.camel@leto.intern.saout.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231838731.4823.2.camel@leto.intern.saout.de>
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


* Christophe Saout <christophe@saout.de> wrote:

> Hi Bryan,
> 
> > I've bisected the bug in question, and the faulty commit appears to be:
> > commit e97a630eb0f5b8b380fd67504de6cedebb489003
> > Author: Nick Piggin <npiggin@suse.de>
> > Date:   Tue Jan 6 14:39:19 2009 -0800
> > 
> >     mm: vmalloc use mutex for purge
> > 
> >     The vmalloc purge lock can be a mutex so we can sleep while a purge is
> >     going on (purge involves a global kernel TLB invalidate, so it can take
> >     quite a while).
> > 
> >     Signed-off-by: Nick Piggin <npiggin@suse.de>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > The bug is easily reproducable by a kernel build on -j4 - it will
> > generally OOPS and panic before the build completes.
> > Also, I've tested it with ext3, and it still occurs, so it seems
> > unrelated to btrfs at least :)
> 
> Nice!
> 
> Reverting this also fixes the BUG() I was seeing when testing the Dom0
> patches on 2.6.29-rc1+tip.  It just ran stable for an hour compiling
> gimp and playing music on my notebook (and then I had to leave).

okay - i've reverted it in tip/master so that testing can continue - but 
the upstream fix (or revert) should be done via the MM folks.

	Ingo
