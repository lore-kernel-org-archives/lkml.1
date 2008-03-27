Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbYC0Qdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbYC0Qdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYC0Qdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:33:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38698 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760704AbYC0Qdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:33:31 -0400
Date: Thu, 27 Mar 2008 17:33:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines (re-submit)
Message-ID: <20080327163314.GA24180@elte.hu>
References: <20080326222450.GA11621@elte.hu> <Pine.SGI.3.96.1080327110732.7873204d-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080327110732.7873204d-100000@fergus.americas.sgi.com>
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


* Alan Mayer <ajm@sgi.com> wrote:

> > well, i dont it has to be (or it should be) an all or nothing patch, 
> > given the complexity and risks involved.
> > 
> > - we should first introduce a nr_irqs variable and a Kconfig switch 
> >   (say CONFIG_ARCH_HAS_DYNAMIC_NR_IRQS) for architectures to toggle. If 
> >   the switch is toggled, nr_irqs is a variable, otherwise it's a carbon 
> >   copy of NR_IRQS. Some array-definition, declaration and initialization 
> >   wrappers are provided as well.
> > 
> > - then the core code, x86 and most drivers can be converted to nr_irqs.
> >   The switch might initially even be user-selectable if
> >   CONFIG_DEBUG_KERNEL, to ease regression testing.
> > 
> > - other architectures will follow one by one, fixing their
> >   arch-dependent drivers as well in the process
> > 
> > - finally we get rid of the wrappers.
> > 
> > 	Ingo
> > 
> 
> Okay, let's see if I understand this.
> 
> First patch introduces a config switch and a variable, nr_irqs that is
> set to NR_IRQS.  It also dynamically allocates the currently staticly
> allocated arrays that are dimensioned by NR_IRQS.  It also initializes
> these dynamically allocated data structures.  This is all done under
> the config switch, initially off by default.  
> 
> Second patch changes core code, x86 and most drivers to use nr_irqs.
> This patch will also introduce a calculation of nr_irqs, based on
> interrupt sources, that is a better estimate of the number of irqs
> in the running system than just picking a guaranteed not-to-exceed
> value that may be too big.
> Is there a way to identify which drivers need to be addressed?
> 
> Then, test the crap out of it.  
> 
> Other architectures will follow, with the work being done by people
> familiar with those architectures.
> 
> Clean up anything that's left over that's now been made unnecessary by
> the conversion by everyone.  Including the config option?
> 
> Do I have the gist of it?

i think you got it right, yes. But ... this is just a quick first-look 
suggestion from me, YMMV. Maybe you find a way to do it much easier to 
just convert everything at once. I tend to do things more gradually, in 
my experience it's very hard and time-consuming to change the world all 
at once - it's hard both to you the developer (you dont know whether it 
works until you have a very substantial amount of code written - while 
in a more gradual approach it can be converted one by one perhaps) - and 
it's hard for users and fellow kernel hackers.

	Ingo
