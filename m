Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYHYMlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYHYMlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYHYMlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:41:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbYHYMlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:41:10 -0400
Date: Mon, 25 Aug 2008 14:40:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next:  build failure
Message-ID: <20080825124054.GD8663@elte.hu>
References: <20080825212833.38550575.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825212833.38550575.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> Today's linux-next build (sparc64 defconfig) failed like this:
> 
> ERROR: "__BUILD_BUG_ON_non_constant" [drivers/net/sunvnet.ko] undefined!
> ERROR: "__BUILD_BUG_ON_non_constant" [drivers/block/sunvdc.ko] undefined!
> 
> Probably intorduced by commit f5b5d41dd51a31fe70e3a04fb80a3b90b84c6a4e
> ("debug: fix BUILD_BUG_ON() for non-constant expressions").
> 
> The preprocessed code looks like this:
> 
> static inline __attribute__((always_inline)) u32 vio_dring_avail(struct vio_dring_state *dr,
>       unsigned int ring_size)
> {
>  do { (void)sizeof(char[1 - 2*!!(!is_power_of_2(ring_size))]); if (!__builtin_constant_p(!is_power_of_2(ring_size))) __BUILD_BUG_ON_non_constant++; } while (0);
> 
>  return (dr->pending -
>   ((dr->prod - dr->cons) & (ring_size - 1)));
> }
> 
> I tried turning the above inline function into a macro to no avail.
> 
> I applied the following patch (which is probably not what is wanted, 
> but puts back what was there before).
> 
> I see from LKML that this definition of BUILD_BUG_ON is to be 
> replaced, so this is just a temporary measure.

yeah. Note that it will only be stricter, so more fallout is expected.

	Ingo
