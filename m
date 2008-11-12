Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYKLSnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYKLSnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKLSne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:43:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54018 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbYKLSnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:43:33 -0500
Date: Wed, 12 Nov 2008 19:43:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [PATCH] [4/4] SCHED: Use a lookup array in sd_level_to_string
Message-ID: <20081112184321.GF4562@elte.hu>
References: <20081112145.328971960@firstfloor.org> <20081112124512.6EEF63E6610@basil.firstfloor.org> <20081112144709.GB2672@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112144709.GB2672@cmpxchg.org>
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


* Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Wed, Nov 12, 2008 at 01:45:12PM +0100, Andi Kleen wrote:
> > 
> > Generates better/shorter code. Doesn't matter much because it's only
> > a SCHED_DEBUG function. 
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > ---
> >  kernel/sched.c |   29 +++++++++++------------------
> >  1 file changed, 11 insertions(+), 18 deletions(-)
> > 
> > Index: linux-2.6.28-rc4-test/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.28-rc4-test.orig/kernel/sched.c	2008-11-12 12:36:23.000000000 +0100
> > +++ linux-2.6.28-rc4-test/kernel/sched.c	2008-11-12 12:43:58.000000000 +0100
> > @@ -6629,24 +6629,17 @@
> >  
> >  static inline const char *sd_level_to_string(enum sched_domain_level lvl)
> >  {
> > -	switch (lvl) {
> > -	case SD_LV_NONE:
> > -			return "NONE";
> > -	case SD_LV_SIBLING:
> > -			return "SIBLING";
> > -	case SD_LV_MC:
> > -			return "MC";
> > -	case SD_LV_CPU:
> > -			return "CPU";
> > -	case SD_LV_NODE:
> > -			return "NODE";
> > -	case SD_LV_ALLNODES:
> > -			return "ALLNODES";
> > -	case SD_LV_MAX:
> > -			return "MAX";
> > -
> > -	}
> > -	return "MAX";
> > +	static const char *lva[] = {
> > +#define T(x) [SD_LV_ ## x ] = #T
> 
> Shouldn't                         ^ that be x?

hasnt been tested i guess. Note that the patch is moot: an equivalent 
change has been done in the scheduler tree already, in a cleaner way. 
It's all in linux-next.

	Ingo
