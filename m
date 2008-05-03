Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbYECLKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbYECLKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 07:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYECLK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 07:10:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbYECLK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 07:10:26 -0400
Date: Sat, 3 May 2008 13:10:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org
Subject: Re: x86 git acpi issue?
Message-ID: <20080503111004.GC22543@elte.hu>
References: <481BAC6F.5090509@ct.jp.nec.com> <481BACEC.8080902@zytor.com> <20080503071332.GF5838@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805031123420.6003@apollo.tec.linutronix.de> <20080503094551.GA10805@elte.hu> <alpine.LFD.1.10.0805031201130.6003@apollo.tec.linutronix.de> <20080503100810.GA15645@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503100810.GA15645@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sat, May 03, 2008 at 12:02:37PM +0200, Thomas Gleixner wrote:
> > On Sat, 3 May 2008, Ingo Molnar wrote:
> > > > Right. This Makefile is a nasty trap. I looked into it and the fix for 
> > > > now is below. Long term this Makefile trickery needs to be cleaned up 
> > > > to avoid trapping into this again.
> > > 
> > > Thanks Thomas, i messed up that commit - i should have known that the 
> > > NUMAQ build fix looked _too_ easy ;-)
> > 
> > Also the move of 
> > pci-$(CONFIG_ACPI)             += acpi.o
> > is what broke things.
> > 
> > There is a nasty init function ordering problem as well between
> > 
> > pci-$(CONFIG_ACPI)             += acpi.o
> > pci-y                          += legacy.o irq.o
> > 
> > Sigh.
> 
> This is the kind of stuff that has prevented me from unifying the two 
> Makefiles. But if no-one beats me I will give it a shot soon. It will 
> be a microsteps because we will likeky hit such issues.

yeah, it needs to be micro-steps (nice word! :) as this stuff is very 
subtle.

	Ingo
