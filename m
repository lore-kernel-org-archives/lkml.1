Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYJVPI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYJVPI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYJVPIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:08:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54194 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbYJVPIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:08:15 -0400
Date: Wed, 22 Oct 2008 17:08:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Daniele Calore <orkaan@orkaan.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27] x86: memtest fix use of reserve_early()
Message-ID: <20081022150801.GG23060@elte.hu>
References: <20081013103412.6fec375a@buddha> <86802c440810211142v30cf5b4s4f71aa1261526c08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810211142v30cf5b4s4f71aa1261526c08@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, Oct 13, 2008 at 1:34 AM, Daniele Calore <orkaan@orkaan.org> wrote:
> > Hi all,
> >
> > Wrong usage of 2nd parameter in reserve_early call.
> > 66/75: reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
> >                                ^^^^^^^^^^^^^^^^^^^^
> >
> > The correct way is to use 'end' address and not 'size'.
> > As a bonus a fix to the printk format.
> >
> > Signed-off-by: Daniele Calore <orkaan@orkaan.org>
> >
> > ---
> > diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
> > index 672e17f..9cab18b 100644
> > --- a/arch/x86/mm/memtest.c
> > +++ b/arch/x86/mm/memtest.c
> > @@ -61,9 +61,9 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
> >                                last_bad += incr;
> >                        } else {
> >                                if (start_bad) {
> > -                                       printk(KERN_CONT "\n  %010lx bad mem addr %010lx - %010lx reserved",
> > +                                       printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
> >                                                val, start_bad, last_bad + incr);
> > -                                       reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
> > +                                       reserve_early(start_bad, last_bad + incr, "BAD RAM");
> >                                }
> >                                start_bad = last_bad = start_phys_aligned;
> >                        }
> > @@ -72,9 +72,8 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
> >        if (start_bad) {
> >                printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
> >                        val, start_bad, last_bad + incr);
> > -               reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
> > +               reserve_early(start_bad, last_bad + incr, "BAD RAM");
> >        }
> > -
> >  }
> >
> >  /* default is disabled */
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

applied to tip/x86/urgent, thanks!

	Ingo
