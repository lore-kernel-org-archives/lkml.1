Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYKTIWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYKTIWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYKTIWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:22:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33143 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbYKTIWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:22:14 -0500
Date: Thu, 20 Nov 2008 09:20:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       ink@jurassic.park.msu.ru, rmk@arm.linux.org.uk, starvik@axis.com,
       tony.luck@intel.com, takata@linux-m32r.org, ralf@linux-mips.org,
       grundler@parisc-linux.org, paulus@samba.org, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, wli@holomorphy.com, davem@davemloft.net,
       jdike@addtoit.com, mingo@redhat.com
Subject: Re: [PATCH 1/2] cpumask: centralize cpu_online_map and
	cpu_possible_map
Message-ID: <20081120082013.GF21785@elte.hu>
References: <200811200107.18162.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811200107.18162.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> (I'll be rinsing this through linux-next; testing feedback and even 
> Acked-by's appreciated).
> 
> Each SMP arch defines these themselves.  Move them to a central 
> location.
> 
> Twists:
> 1) Some archs (m32, parisc, s390) set possible_map to all 1, so we add a
>    CONFIG_INIT_ALL_POSSIBLE for this rather than break them.
> 
> 2) mips and sparc32 '#define cpu_possible_map phys_cpu_present_map'.
>    Those archs simply have phys_cpu_present_map replaced everywhere.
> 
> 3) Alpha defined cpu_possible_map to cpu_present_map; this is tricky
>    so I just manipulate them both in sync.
> 
> 4) IA64, cris and m32r have gratuitous 'extern cpumask_t cpu_possible_map'
>    declarations.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Nice cleanup - my earlier acked-by for this concept still stands:

  Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
