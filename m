Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbZCBKUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbZCBKUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbZCBKTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:19:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55900 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945AbZCBKTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:19:38 -0500
Date: Mon, 2 Mar 2009 11:19:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Kevin O'Connor" <kevin@koconnor.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org
Subject: Re: [PATCH] x86: ioremap mptable -v2
Message-ID: <20090302101918.GA6705@elte.hu>
References: <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu> <49A23EE0.8000102@kernel.org> <20090228234127.GA29964@morn.localdomain> <49A9FC9A.2030707@kernel.org> <20090301180420.GA27040@morn.localdomain> <49AB511E.9010507@kernel.org> <20090302101823.GJ20897@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302101823.GJ20897@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> >  	} else if (mpf->physptr) {
> > +		struct mpc_table *mpc;
> > +		unsigned long size;
> >  
> > +		mpc = early_ioremap(mpf->physptr, PAGE_SIZE);
> > +		size = mpc->length;
> > +		apic_printk(APIC_VERBOSE, "  mpc: %lx-%lx\n", (unsigned long)mpf->physptr,
> > +			 mpf->physptr + size);
> > +		early_iounmap(mpc, PAGE_SIZE);
> > +		mpc = early_ioremap(mpf->physptr, size);
> 
> no objections, but this bit of __get_smp_config() needs to be 
> done cleaner - the whole mpf->physptr != 0 bit should probably 
> go into a helper function.

and if you do that it should be done via two patches, in two 
steps: first patch is a pure cleanup that moves this bit of 
__get_smp_config() into a helper function. The second patch then 
adds the early_ioremap().

	Ingo
