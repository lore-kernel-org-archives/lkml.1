Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYJVJiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYJVJiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYJVJhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:37:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbYJVJhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:37:07 -0400
Date: Wed, 22 Oct 2008 11:36:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
Message-ID: <20081022093615.GF12453@elte.hu>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com> <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com> <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu> <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu> <1224517744.5195.1.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224517744.5195.1.camel@koto.keithp.com>
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


* Keith Packard <keithp@keithp.com> wrote:

> On Mon, 2008-10-20 at 13:58 +0200, Ingo Molnar wrote:
> 
> > yes but note that by caching the whole mapping on 64-bit we get 
> > everything we want: trivially lockless, works from any CPU, can be 
> > preempted at will, and there are no ugly INVLPG flushes anywhere.
> 
> I was assuming that on 64-bit, the map would be created at driver init 
> time and be left in place until the driver closed; if that's what you 
> mean by 'caching', then yes, we should cache the map.

correct.

> > 32-bit we should handle as well but not design for it.
> 
> As long as we get kmap_atomic-like performance, and we get to simplify 
> our code, I'm up for it.

okay. So ... mind sending your io_mapping patch as a generic facility? 
It looks all good to me in its present form, except that it should live 
in include/linux/io.h, not in the drivers/gpu/drm/i915/io_reserve.h file
:-)

also, please send at least two patches, so that we can look at (and 
possibly merge) the generic facility in isolation.

	Ingo
