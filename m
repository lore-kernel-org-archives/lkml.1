Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZDRUGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZDRUGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZDRUGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:06:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbZDRUGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:06:38 -0400
Date: Sat, 18 Apr 2009 22:06:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Jan Kiszka <jan.kiszka@web.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
Message-ID: <20090418200623.GA27294@elte.hu>
References: <49E89D1B.7060800@suse.com> <49E9904A.5030201@web.de> <49EA2F81.7030302@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EA2F81.7030302@suse.com>
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


* Jeff Mahoney <jeffm@suse.com> wrote:

> > Hmmmmm. That somehow reminds me of what I thought I had to fix in the
> > HPET emulation of QEMU just recently [1] - because of 2.6.30-rc's behavior.
> > 
> > Could you try if writing 'delta' a second time makes any difference on
> > that box?
> > 
> > diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> > index 648b3a2..523d72b 100644
> > --- a/arch/x86/kernel/hpet.c
> > +++ b/arch/x86/kernel/hpet.c
> > @@ -324,6 +324,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
> >  		       HPET_TN_SETVAL | HPET_TN_32BIT;
> >  		hpet_writel(cfg, HPET_Tn_CFG(timer));
> >  		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
> > +		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
> >  		hpet_start_counter();
> >  		hpet_print_config();
> >  		break;
> > 
> 
> Thanks, Jan.
> 
> That fixed it for me.

I've queued it up (and i've got a test-system that might be affected 
by a similar problem - it shows a similar crash very rarely), but it 
would be nice to know why this duplicate writeout makes a 
difference. Jan?

	Ingo
