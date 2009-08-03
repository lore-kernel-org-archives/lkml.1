Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZHCMID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZHCMID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZHCMIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:08:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47055 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbZHCMIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:08:00 -0400
Date: Mon, 3 Aug 2009 14:07:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sachin Sant <sachinp@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Boot failure on x86_64 (OOPS set_cpu_sibling_map() )
Message-ID: <20090803120739.GA29156@elte.hu>
References: <20090730182143.eadf36e6.sfr@canb.auug.org.au> <4A718338.6050907@in.ibm.com> <20090730135623.GB16659@aftab> <20090803093144.GC9074@elte.hu> <20090803101401.GA14442@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803101401.GA14442@aftab>
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


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi Ingo,
> 
> On Mon, Aug 03, 2009 at 11:31:44AM +0200, Ingo Molnar wrote:
> > Borislav, this patch:
> > 
> >  From 4581c6313c16a38ffcef8bccd6ffbe9598d585b0 Mon Sep 17 00:00:00 2001
> >  From: Andreas Herrmann <andreas.herrmann3@amd.com>
> >  Date: Fri, 24 Jul 2009 10:21:06 +0200
> >  Subject: [PATCH] x86: provide CPU topology information for multi-node processors
> > 
> >  arch/x86/include/asm/processor.h |    2 ++
> >  arch/x86/include/asm/smp.h       |    6 ++++++
> >  arch/x86/include/asm/topology.h  |    2 ++
> >  arch/x86/kernel/cpu/common.c     |    2 ++
> >  arch/x86/kernel/cpu/proc.c       |    1 +
> >  arch/x86/kernel/smpboot.c        |   20 ++++++++++++++++----
> >  6 files changed, 29 insertions(+), 4 deletions(-)
> > 
> > has absolutely _ZERO_ place in the EDAC tree. It was submitted to 
> > the x86 tree and was under discussion - i requested changes to it so 
> > this current form has my NAK.
> 
> I know that, I'm following the discussion. I needed the 
> functionality in EDAC and that's why I added them _temporarily_ to 
> the mix so that the whole series (esp. the MCE bits) can see some 
> testing. Which obviously caught some issues :).
> 
> But I'm very well aware that the patches are not final and they 
> will go through x86 when done. This is what I told Stephen when 
> upping them for linux-next.

Next time please tell the x86 maintainers too ;-)

The thing that was blocking this commit is really the insufficient 
sched-domains integration of said NUMA bits. I think the NUMA bits 
look good and if the EDAC tree makes use of it we can merge it in 
.32.

Mind preparing a separate branch for it (.31-rc5 based) and send me 
a pull request so that we can share the commit between the EDAC tree 
and the x86 tree?

Thanks,

	Ingo
