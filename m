Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZC2ABG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZC2ABG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 20:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZC2AAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 20:00:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZC2AAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 20:00:52 -0400
Date: Sun, 29 Mar 2009 01:00:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090329000026.GA27015@elte.hu>
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain> <20090328190350.GA30214@uranus.ravnborg.org> <49CEA3CD.105@kernel.org> <alpine.LFD.2.00.0903290025280.3397@localhost.localdomain> <20090328233438.GA4957@elte.hu> <alpine.LFD.2.00.0903290035390.3397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903290035390.3397@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 29 Mar 2009, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > > Personally I'd prefer alphabetic order, sorting based on length 
> > > > isn't a complete ordering.  Nearly all editors can sort 
> > > > alphabetically at the push of a key.
> > > 
> > > I'd prefer if somebody would sit down and write a tool to analyse 
> > > the include hell instead of manually shuffling crap around to 
> > > avoid trivial merge conflicts. I have cleaned up enough stuff in 
> > > the x86 merger myself where I was able to cut the number of 
> > > includes at least in half just by staring at the gcc intermediate 
> > > files. We could do better and automate the analysis so we get down 
> > > to a handful of includes instead of including the world and more.
> > 
> > I do not disagree with include file cleanups (we've done many of 
> > them in this cycle and in previous cycles), but note that the 
> > reduction in include files at the top of .c files actually increases 
> > the chance of patch conflicts: when a new include file is added by 
> > two patches to the same .c file.
> 
> Those conflicts are trivial and if we have a mechanism to anlyse 
> include dependencies then we can avoid such conflicts often at 
> all.

Yeah, i agree that least 50% of the existing #include's are not 
needed.

That's not the point though. When two new files both append to the
#include file section, they'll clash. Those _new_ includes tend to 
be justified - people dont add #includes needlessly - it's years 
long bitrot that causes #includes to bloat up slowly.

> Go through some of the include madness and watch the compiler 
> reading the same header file ten times for a single source file 
> compile.

Yes, we need both efforts. That section needs to look professional 
(unordered lines look amateurishly random, arbitrary and confusing), 
and it needs to be minimalized as well.

And the xmas-tree helps the minimizing effort - as it trivially 
eliminates duplicate #includes (which do happen frequently as well), 
and they eliminate related includes as well because they get moved 
together and get noticed.

Most importantly, such code needs to look like as if someone 
actually cared about it. If code looks tidy, people assume that it's 
supposed to be perfect, and will notice and fix more subtle 
imperfections in it. If code looks totally messy on the other hand, 
_nobody_ will care because it's visibly broken. So these changes are 
a small step forward.

	Ingo
