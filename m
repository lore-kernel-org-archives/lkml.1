Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbYBLOgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbYBLOgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762820AbYBLOg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:36:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:29269 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761344AbYBLOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NIRKdsxvGibUD+jngba6/Y4P/IcmlEB0IGLNn2pMdiOB4Wjpbti4vr/SDB8Dg+MepHDk32UeMkLIl+dzzZUG3Yl6M7WD5eRET/WDvNQGRh+honj9v1pX+J6jUT2qzho6s0Uo6H0DdRBMrGvTCfn5mfCK2NaRyV2B1KTSlforLqM=
Message-ID: <5a4c581d0802120635k3aab6222y6066e4e344620088@mail.gmail.com>
Date: Tue, 12 Feb 2008 15:35:52 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup and is unkillable [still broken in 2.6.25-rc1]
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1202823858.6247.26.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com>
	 <20080211204921.GA24806@elte.hu> <20080211221034.GA2587@elte.hu>
	 <200802120012.35314.rjw@sisk.pl> <1202823858.6247.26.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 2:44 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Tue, 2008-02-12 at 00:12 +0100, Rafael J. Wysocki wrote:
> > On Monday, 11 of February 2008, Ingo Molnar wrote:
> > >
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > > no, they were not lost, they just didnt pass QA here (they crashed on
> > > > a particularly hard to debug 8-way box i have) and Peter worked on
> > > > that queue of fixes up until today to get it really correct. Could you
> > > > check:
> > > >
> > > >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> > > >
> > > > combo patch below as well - whichever you prefer. The shortlog can be
> > > > found below as well - but i dont yet consider this pullable, i'd like
> > > > it to see pass a full night of randconfig tests on my test-systems.
> > >
> > > ok, we just found the reason for the 8-way crash, the delta fix from
> > > Peter is below if any of you have tried the previous combo patch.
> > > Updated sched.git as well, new HEAD is
> > > fec13e45305d69fd0bd23b30bd05a0a42cf341f8.
> >
> > With the previous patch and this patch applied, the issue is not reproducible
> > here.
>
> Did you enable CONFIG_RT_GROUP_SCHED (it defaults to n)?
>
> If you didn't, could you try with it set to y?

I just rebuilt 2.6.25-rc1-git2 with Ingo's patch and your patch on top,
 and the Oracle VKTM issue is still gone even with

[asuardi@sandman ~]$ grep GROUP_SCHED
/share/src/linux-2.6.25-rc1-git2-orafix/.config
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CGROUP_SCHED is not set

 so it's good for me.

Or is it necessary to also enable CONFIG_CGROUP_SCHED and retest ?

--alessandro

 "We act as though comfort and luxury were the chief requirements
   of life, when all that we need to make us really happy is
   something to be enthusiastic about."

   (Charles Kingsley)
