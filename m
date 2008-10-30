Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYJ3WVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYJ3WVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYJ3WVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:21:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbYJ3WVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:21:17 -0400
Date: Thu, 30 Oct 2008 23:21:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <Jens.Axboe@oracle.com>
Subject: Re: [PATCH] fix smp generic helper voyager breakage
Message-ID: <20081030222111.GA18600@elte.hu>
References: <1225400980.19324.24.camel@localhost.localdomain> <20081030215421.GG30303@elte.hu> <1225404368.19324.49.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225404368.19324.49.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-10-30 at 22:54 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > +++ b/arch/x86/Kconfig
> > > @@ -167,9 +167,11 @@ config GENERIC_PENDING_IRQ
> > >  config X86_SMP
> > >  	bool
> > >  	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
> > > -	select USE_GENERIC_SMP_HELPERS
> > >  	default y
> > >  
> > > +config USE_GENERIC_SMP_HELPERS
> > > +	def_bool y
> > > +
> > 
> > uhm, that's a bogus change - USE_GENERIC_SMP_HELPERS must not be set 
> > on UP. This will break all UP compilations, on all x86 UP boxes:
> 
> Heh, that would be one thing I don't build in my test rig.

lets put it this way: that change, when put in my test rig, already 
broke more x86 boxes than there are working Voyager test-boxes in 
existence ;-) [it broke the build on three of them]

> > kernel/softirq.c: In function '__try_remote_softirq':
> > kernel/softirq.c:522: error: implicit declaration of function '__smp_call_function_single'
> > 
> > so i've removed your patch for now.
> 
> OK, I'll update it ... I assume it should depend on CONFIG_SMP then?

correct.

	Ingo
