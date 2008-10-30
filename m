Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYJ3WlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYJ3WlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYJ3WlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:41:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYJ3WlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:41:11 -0400
Date: Thu, 30 Oct 2008 23:40:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: next-20081030: voyager compile busted
Message-ID: <20081030224057.GB20507@elte.hu>
References: <20081030173030.d8847df6.sfr@canb.auug.org.au> <20081030180323.GA13399@x200.localdomain> <1225398287.19324.1.camel@localhost.localdomain> <20081030205230.GO27407@elte.hu> <1225400283.19324.6.camel@localhost.localdomain> <20081030210704.GA25665@elte.hu> <1225401708.19324.35.camel@localhost.localdomain> <490A2A30.5040905@zytor.com> <1225403266.19324.42.camel@localhost.localdomain> <490A2C3D.4020202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490A2C3D.4020202@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> James Bottomley wrote:
> > 
> > Yes ... been having IRC conversations about that.  We'd need to use
> > runtime patching to fix the performance regressions virtualisation has
> > been causing us first ... but then we could use it for voyager.
> 
> I thought we already were, at least to some degree (the call sites 
> are way too big and way bigger than they need to be, so we end up 
> with a lot of NOPs.  I proposed a solution to Jeremy at Kernel 
> Summit, but he basically said "I don't want to maintain that, I 
> don't care about hardware performance", which is understandable but 
> highly unfortunate.)

in practice the function pointer overhead is almost unmeasurable for 
things like IPIs which are rather expensive to issue. In fact it's 
probably more expensive on Voyager as it does not utilize the local 
APIC for SMP messaging (which is pretty much the only 
performance-sensitive thing here). It uses its own glue logic it 
appears, which is almost certainly behind the system bus.

James, how many cycles do typical SMP ops take on Voyager?

	Ingo
