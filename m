Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbYE0Wxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbYE0Wxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbYE0Wxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:53:32 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40947 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348AbYE0Wxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:53:31 -0400
Date: Wed, 28 May 2008 01:50:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [REGRESSION][BISECTED][X86] next-20080526 hangs on boot
Message-ID: <20080527225042.GG11310@cs181133002.pp.htv.fi>
References: <g1eg2q$81q$1@ger.gmane.org> <20080526161623.GC7305@cvg> <g1f230$7bl$1@ger.gmane.org> <g1f3ht$b9g$1@ger.gmane.org> <aa79d98a0805262335lf5cd4e1p8f318d45dfe7ff92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aa79d98a0805262335lf5cd4e1p8f318d45dfe7ff92@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 10:35:43AM +0400, Cyrill Gorcunov wrote:
> On 5/26/08, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> > <posted & mailed>
> >
> > Sitsofe Wheeler wrote:
> >
> > > Cyrill Gorcunov wrote:
> > >
> > >> [Sitsofe Wheeler - Mon, May 26, 2008 at 03:04:54PM +0100]
> > >> | When using a 32 bit linux-next-20080526 the bootup process will hang at
> > >> | a random point (not even sysrq helps) with no additional output on the
> > >> | screen (whereas linux-next-20080523 did boot). Mysteriously, booting
> > >> | with nmi_watchdog=2 allows the boot to finish (booting with
> > >> | nmi_watchdog=1 still stalls). I have bisected it down to commit
> > >> | [d1b946b97d71423f365fa797d1428e1847c0bec1]:
> > >>
> > >> Hi, so it helps by reverting only that commit? I mean all further commits
> > >> are still appiled?
> > >
> > > Ah that I hadn't tested. I believe I might need to revert
> > > 4b82b277707a39b97271439c475f186f63ec4692 too if later commits are applied
> > > (but I'm still testing)
> > >
> > >> and, btw, could you post your config, please?
> > >
> > > http://sucs.org/~sits/test/config-20080526.txt
> >
> > OK applying the following patch (which is more or less a revert of
> > [4b82b277707a39b97271439c475f186f63ec4692]) resolves the problem:
>...
> 
> Hi Sitsofe, actually I can't imagine how this revert have helped you
> from hang. Newly introduced nmi_watchdog_default() didn't change
> the logic of the code being used before this merge-series.
> 
> Thomas, Ingo, maybe I've overlooked something (hard to believe ;)?
> Only the change is the adding of new call for nmi_watchdog_default()
> which was say 'inlined' before.
>...

arch/x86/kernel/smpboot.c:native_smp_prepare_cpus() also calls
the no longer empty nmi_watchdog_default() on 32bit.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

