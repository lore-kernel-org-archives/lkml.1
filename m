Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYIDQRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYIDQRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbYIDQR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:17:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYIDQRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:17:25 -0400
Date: Thu, 4 Sep 2008 18:17:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert commit e8aa4667baf74dfd85fbaab86861465acb811085
Message-ID: <20080904161707.GA24369@elte.hu>
References: <20080904144657.GC15987@alberich.amd.com> <20080904153206.GB7120@elte.hu> <alpine.LFD.1.10.0809041812450.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809041812450.3243@apollo.tec.linutronix.de>
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

> On Thu, 4 Sep 2008, Ingo Molnar wrote:
> 
> > 
> > * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > 
> > > This reverts commit e8aa4667baf74dfd85fbaab86861465acb811085
> > >  (x86: enable hpet=force for AMD SB400)
> > > 
> > > Since ATI/AMD decided not to support HPET on SB4xx it doesn't
> > > make sense to enable this unsupported feature.
> > > (I was not aware of this when submitting the quirk.)
> > > 
> > > If a system with SB4xx chipset provides an ACPI HPET table and does
> > > not boot, "nohpet" should be used as kernel parameter.
> > > 
> > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > 
> > applied to tip/x86/urgent, thanks Andreas. I guess a system broke due to 
> > this commit?
> 
> Hmm, why do we remove something which needs to be force enabled by the 
> user anyway ?

good point, i thought the original commit caused unconditional 
force-enabling - but indeed it is only relevant if hpet=force is 
specified. (which should be rare and specific)

> Is the HPET on these systems not working at all so the force enable 
> code is useless ?

also, if a user does hpet=force and thing break he's got to keep all the 
pieces, right?

or is there any other side-effect of the commit that matters here?

	Ingo
