Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZBIKRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZBIKRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZBIKRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:17:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZBIKRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:17:04 -0500
Date: Mon, 9 Feb 2009 11:16:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>,
       "David S. Miller" <davem@davemloft.net>,
       Al Viro <viro@zeniv.linux.org.uk>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/3] cpumask: remove dangerous CPU_MASK_ALL_PTR,
	&CPU_MASK_ALL.
Message-ID: <20090209101642.GG20467@elte.hu>
References: <200902071809.17953.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902071809.17953.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> (Thanks to Al Viro for reminding me of this, via Ingo)
> 
> CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:
> 
> 	#define CPU_MASK_ALL (cpumask_t) { { ... } }
> 
> Taking the address of such a temporary is questionable at best,
> unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
> CPU_MASK_ALL_PTR:
> 
> 	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)
> 
> Which formalizes this practice.  One day gcc could bite us over this
> usage (though we seem to have gotten away with it so far).
> 
> So replace everywhere which used &CPU_MASK_ALL or CPU_MASK_ALL_PTR
> with the modern "cpu_all_mask" (a real struct cpumask *), and remove
> CPU_MASK_ALL_PTR altogether.
> 
> Also remove the confusing and deprecated large-NR_CPUS-only
> "cpu_mask_all".
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

In general this should be expressed via this tag:

	Reported-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks,

	Ingo
