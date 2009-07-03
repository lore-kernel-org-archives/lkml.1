Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZGCJYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZGCJYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZGCJYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:24:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54210 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZGCJYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:24:13 -0400
Date: Fri, 3 Jul 2009 11:24:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kurt Garloff <garloff@suse.de>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Greg KH <gregkh@suse.de>, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090703092405.GD3902@elte.hu>
References: <20090624213211.GA11291@kroah.com> <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org> <20090630223040.GA3802@suse.de> <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org> <20090701111003.GC15958@elte.hu> <20090703091935.GL20681@tpkurt2.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703091935.GL20681@tpkurt2.suse.de>
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


* Kurt Garloff <garloff@suse.de> wrote:

> Ingo,
> 
> On Wed, Jul 01, 2009 at 01:10:03PM +0200, Ingo Molnar wrote:
> > * Maciej W. Rozycki <macro@linux-mips.org> wrote:
> > 
> > > On Tue, 30 Jun 2009, Greg KH wrote:
> > > 
> > > > >  These days an IOCK NMI typically happens in response to a PCI 
> > > > > SERR -- it may be useful to traverse PCI buses to find the 
> > > > > offender and dump this information on this occasion too.  The 
> > > > > south bridge may have additional status too.
> > > > 
> > > > Sure, that would be great to have.  Care to make a patch?  :)
> > > 
> > >  ENOTIME, sorry.  Next year perhaps.  Or a homework project for 
> > > one of the newbies. ;)
> > 
> > You know that this project would kill a newbie, right? :)
> > 
> > We have no real southbridge drivers on x86 - but we should 
> > certainly add some. Also, walking the PCI device tree from NMI 
> > context is tricky as the lists there are not NMI safe - we could 
> > crash if we happen to get a #IOCK while loading/unloading 
> > drivers (which is rare but could happen).
> 
> Well -- in case we panic the system anyway this is not necessarily 
> a big issue (let's print the message before ...) -- if we crash 
> trying to gather additional info, we'll lose the info. Currently 
> we never have the info ...

We dont _necessarily_ crash ... The crash/panic is default off and 
sysctl driven.

Allowing a crash is not the highest quality of implementation and 
i'm somewhat wary of 'allow a little bit of crap' arguments - it's 
too similar to the 'little bit pregnant' concept ;-)

	Ingo
