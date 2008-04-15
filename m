Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYDOVI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYDOVI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYDOVIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:08:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYDOVIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:08:48 -0400
Date: Tue, 15 Apr 2008 23:08:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415210818.GA1339@elte.hu>
References: <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <Pine.LNX.4.64.0804151319410.1785@schroedinger.engr.sgi.com> <20080415205857.GD31645@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415205857.GD31645@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Tue, 15 Apr 2008, Ingo Molnar wrote:
> > 
> > > my current guess would have been some bootmem regression/interaction 
> > > that messes up the buddy bitmaps - but i just reverted to the v2.6.24 
> > > version of bootmem.c and that crashes too ...
> > 
> > The simplest solution for now may be to go with your workaround 
> > increasing SECTION_SIZE_BITS to 27. [...]
> 
> the bug's effects are so severe that this is the last thing i'd like 
> to do.

more verbosely: we sometimes do "blind" reverts, if it's reasonably 
established (or strongly suspected) that a revert makes a bug less 
severe. We do this even if we dont fully understand the bug and its 
effects and time runs out - on the assumption that we wont get worse 
than the old code was.

but what i'd not really like to do are blind _non-revert_ changes. With 
your suggested change we'd introduce a seemingly innocious but still 
wholly new (and untested) memory setup layout on the most popular Linux 
kernel memory config in existence. (!PAE 32-bit is still being run on 
more than 50% of the Linux desktops - around 80% runs 32-bit kernels.)

And as this bug demonstrates it, seemingly small differences appear to 
have large effects so we cannot know in what direction that would go - 
we might turn a rare regression into a common regression. I'd rather 
release with this bug being unfixed than with tweaking it just because 
the effect seems less severe on a totally unrepresentative set of 
systems.

	Ingo
