Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbYB0WjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbYB0WjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYB0Wiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:38:51 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36556 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYB0Wiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:38:51 -0500
Date: Thu, 28 Feb 2008 00:37:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: X86_HT always enable on X86_64 SMP
Message-ID: <20080227223740.GZ29269@cs181133002.pp.htv.fi>
References: <47C5D32E.8070308@ct.jp.nec.com> <20080227212658.GU29269@cs181133002.pp.htv.fi> <47C5D693.3030207@zytor.com> <20080227215816.GX29269@cs181133002.pp.htv.fi> <47C5E158.5080900@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47C5E158.5080900@ct.jp.nec.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 02:16:56PM -0800, Hiroshi Shimamoto wrote:
> Adrian Bunk wrote:
> > On Wed, Feb 27, 2008 at 01:30:59PM -0800, H. Peter Anvin wrote:
> >> Adrian Bunk wrote:
> >>> On Wed, Feb 27, 2008 at 01:16:30PM -0800, Hiroshi Shimamoto wrote:
> >>>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >>>>
> >>>> X86_HT is used for hyperthreading or multicore on 32-bit.
> >>>> The X86_HT on 64-bit is different from 32-bit, it means hyperthreading only.
> >>>> And X86_HT is not used on 64-bit except from cpu/initel_cacheinfo.c.
> >>>>
> >>>> Unify X86_HT for hyperthreading or multicore.
> >>>> Turn X86_HT on when X86_64 and SMP are enabled.
> >>> Please fix it properly instead - fiddling around with it the way you do
> >>> only asks for trouble in the future.
> >>>
> >>> What we need are two different variables for:
> >>> - hyperthreading and
> >>> - multicore
> >> He does, and calls them SCHED_SMT and SCHED_MC respectively.
> > 
> > These are the already existing scheduler related variables that are 
> > only a part of the X86_HT usages.
> > 
> >> It's not particularly clear to me what X86_HT is meant to be used for  
> >> anymore at all.
> > 
> > grep through the source code and you find it is sometimes used for 
> > hyperthreading and sometimes for multicore.
> > 
> > I don't care whether X86_HT gets splitted or perhaps even removed, but 
> > any change to it should remove the status quo of it having two different 
> > semantics.
> 
> OK, you say "Don't mix two different semantics into one variable X86_HT", right?

Exactly.

This mixing is not your fault since it's an older problem, but instead 
of your suggested patch we should fix it properly.

> Thanks,
> Hiroshi Shimamoto

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

