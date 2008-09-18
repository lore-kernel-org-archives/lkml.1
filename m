Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYIRM3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYIRM3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 08:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYIRM3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 08:29:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48037 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYIRM3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 08:29:42 -0400
Date: Thu, 18 Sep 2008 14:29:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Jeremy Fitzhardinge <jeremy@goop.org>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
Message-ID: <20080918122922.GA27232@elte.hu>
References: <48D21BA3.76E4.0078.0@novell.com> <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu> <48D23BF6.76E4.0078.0@novell.com> <20080918095710.GA11633@elte.hu> <20080918112018.GA456@elte.hu> <48D25E87.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D25E87.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 18.09.08 13:20 >>>
> >
> >* Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> * Jan Beulich <jbeulich@novell.com> wrote:
> >> 
> >> > I'm really sorry for that, yet another merge oversight (not caught 
> >> > because only re-tested on x86-64). Here's a better one.
> >> 
> >> ah, i see, the delta below. Nasty.
> >
> >the attached config fails in a similar way.
> 
> Hmm, yes, other than in .27, -tip derives resource_size_t from phys_addr_t,
> regardless of CONFIG_RESOURCES_64BIT (and the config you provided
> is a non-PAE one). I have to question that change, which I'm sure is
> responsible for this failure. If there's a good reason for this, then
> phys_addr_valid() should use phys_addr_t as its parameter type (and
> so should ioremap() & Co), and the pre-processor conditional should
> then change to depend on CONFIG_PHYS_ADDR_T_64BIT. Since ioremap()
> would need to change first, I'd have to withdraw the patch until that
> gets sorted out.

(Cc:-ing Jeremy and Hugh).

	Ingo
