Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZBIMBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZBIMBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZBIMBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:01:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52986 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZBIMBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:01:20 -0500
Date: Mon, 9 Feb 2009 13:00:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>,
       "David S. Miller" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: [PATCH] forcedeth: make msi-x different name for rx-tx
Message-ID: <20090209120057.GB17782@elte.hu>
References: <498BC3A8.9040203@kernel.org> <20090206144948.GD18368@elte.hu> <498C6C15.3050807@kernel.org> <20090206171544.GA16190@elte.hu> <498C7958.4010109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498C7958.4010109@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Ingo Molnar wrote:
> >>> Cool cleanups!
> >>>
> >>> Would you mind to also fix the following - on all my systems that have 
> >>> forcedeth gigabit ethernet i've been getting these bogus warnings for 
> >>> _years_, under moderate load:
> >>>
> >>>   eth2: too many iterations (16) in nv_nic_irq.
> >>>
> >>> I think a 64 iterations limit will work much better. (i tried a limit of 50 
> >>> a year ago for a while and it worked fine and had no side effects - and the 
> >>> bogus warnings were done.)
> >> you may enable CONFIG_FORCEDETH_NAPI.
> >>
> >> we should enable NAPI for forcedeth by default, and try to squash more bugs out.
> > 
> > i do have that:
> > 
> >  CONFIG_FORCEDETH=y
> >  CONFIG_FORCEDETH_NAPI=y
> > 
> > and the messages still come.
> 
> so you systems are using ioapic routing, or msi.
> 
> and those messages are from 
> nv_nic_irq_optimized or nv_nic_irq
> for TX or OTHER (timerirq).

yes, IO-APIC:

 18:      81386  306713817          0          0 1413724087          0          0          
0          0          0          0          0          0          0          0          
0   IO-APIC-fasteoi   eth2

Those messages do come and are annoying.

	Ingo
