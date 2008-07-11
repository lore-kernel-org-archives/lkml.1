Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYGKVEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYGKVEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbYGKVEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:04:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbYGKVEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:04:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: today's linux-next fails to boot
Date: Fri, 11 Jul 2008 23:06:38 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
References: <4877400B.1000400@gmail.com> <200807111710.42826.rjw@sisk.pl> <20080711190749.GB21758@elte.hu>
In-Reply-To: <20080711190749.GB21758@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807112306.39455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of July 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Friday, 11 of July 2008, Ingo Molnar wrote:
> > > 
> > > * Török Edwin <edwintorok@gmail.com> wrote:
> > > 
> > > > On 2008-07-11 16:59, Ingo Molnar wrote:
> > > > > * Török Edwin <edwintorok@gmail.com> wrote:
> > > > >
> > > > >   
> > > > >>> [Added Ingo to Cc]
> > > > >>>
> > > > >>> I get the boot problem on i386 with 2008-07-11 linux-next tree, too.
> > > > >>> In my case, no error appears on the screen, just staying blank and
> > > > >>> dead.  It seems stopping at the very beginning, soon after GRUB, so
> > > > >>> could be the same reason.
> > > > >>>   
> > > > >>>       
> > > > >> I don't see any boot messages on the screen, I get that BUG message as
> > > > >> soon as grub's menu dissapears.
> > > > >> I have bisected it to this range so far:
> > > > >> git-bisect good aa03060a78c1aec53075a0c8ca7be19cedfbea8f
> > > > >> git-bisect bad b1611c0058bc6635e7257e755c3f194933a7a6df
> > > > >>
> > > > >> Should I continue to bisect?
> > > > >>     
> > > > >
> > > > > could you check latest tip/master, does it boot fine with the same 
> > > > > config?
> > > > 
> > > > tip/master boots fine.
> > > 
> > > to update linux-next to the latest bits in -tip, you can perhaps do 
> > > something like this:
> > > 
> > >  git-merge tip/auto-x86-next
> > >  git-merge tip/auto-core-next
> > >  git-merge tip/auto-cpus4096-next
> > >  git-merge tip/auto-ftrace-next
> > >  git-merge tip/auto-generic-ipi-next
> > >  git-merge tip/auto-genirq-next
> > >  git-merge tip/auto-latest
> > >  git-merge tip/auto-safe-poison-pointers-next
> > >  git-merge tip/auto-sched-next
> > >  git-merge tip/auto-stackprotector-next
> > >  git-merge tip/auto-timers-next
> > > 
> > > but it's easily possible that the bug is in some other portion of 
> > > linux-next.
> > 
> > Hm, I haven't tested the linux-next from today myself yet, but I have 
> > a related question.  Namely, is there a way to get a log of commits 
> > that have been added since the previous linux-next?
> > 
> > That may help to find a guilty patch if the yesterday's linux-next 
> > works.
> 
> at least in -tip it works like this:
> 
>    git-shortlog tip-history-2008-07-10_09.58_Thu..
> 
> or, a more practical format with commit IDs on the same line:
> 
>   git log --no-merges --pretty=format:"%h: %s" \
>       tip-history-2008-07-10_09.58_Thu..
> 
> you can restrict it to a given piece of code as well, say:
> 
>   git log --no-merges --pretty=format:"%h: %s" \
>       tip-history-2008-07-10_09.58_Thu.. -- arch/x86/ include/asm-x86/
> 
> this doesnt work in linux-next nearly as well, due to the Quilt imported 
> trees. Every time a quilt queue is updated and reimported, there's a 
> stream of repeat commits.

Thanks for the tips.

Well, it turns out that linux-next from today doesn't boot on my box too
(64-bit) and I don't see anything obviously suspicious.  Bisection time.

Thanks,
Rafael
