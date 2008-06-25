Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYFYOqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYFYOqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbYFYOpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:45:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44484 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYFYOpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:45:20 -0400
Date: Wed, 25 Jun 2008 16:45:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce init_memory_mapping for 32bit
Message-ID: <20080625144504.GA18796@elte.hu>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806240410.47856.yhlu.kernel@gmail.com> <20080624113049.GA7731@elte.hu> <86802c440806241222h574c2a1cidf4191f7f6f3f372@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806241222h574c2a1cidf4191f7f6f3f372@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Tue, Jun 24, 2008 at 4:30 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> so could use mem below max_low_pfn as early. could move several
> >> function more early instead of waiting after paging_init including
> >> moving relocate_initrd early, and kva related early done in
> >> initmem_init
> >
> > applied to tip/x86/setup-memory - thanks Yinghai.
> >
> > a sidenote:
> >
> >>  6 files changed, 128 insertions(+), 74 deletions(-)
> >
> > this patch is too large - if it causes any problems it will not be very
> > easy to figure out which exact change caused the problems.
> >
> > Lets hope it goes all fine - but in the future lets try doing
> > more+smaller patches, especially if they change some known-dangerous
> > area of the kernel.
> >
> > For example here a better splitup would have been to do 5 or more
> > patches:
> >
> >  1) first introduce init_memory_mapping() [but dont use it anywhere]
> >  2) add the init_memory_mapping() call to setup_arch()
> >  3) move remap_numa_kva()
> >  4) move relocate_initrd()
> >  5) remove the now unnecessary setup from paging_init()
> >
> > ... or something like that. The point is to manage risk: if there's
> > multiple problem areas that a change is touching, try to isolate them
> > from each other and introduce the change gradually.
> >
> > The end result is still exactly the same, but much more
> > reviewable/debuggable/bisectable.
> 
> split into 3 patches, please use them to replace the old one if you 
> like.

i've applied them to tip/x86/setup-memory, replacing the larger patch - 
thanks Yinghai.

	Ingo
