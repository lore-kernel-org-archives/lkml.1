Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0BDRzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:55:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0BDRzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:55:16 -0500
Date: Thu, 4 Feb 2010 18:54:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204175445.GB27361@elte.hu>
References: <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
 <20100202154656.GD27314@elte.hu>
 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
 <20100204062619.GA29154@elte.hu>
 <20100204071705.GA28403@elte.hu>
 <20100204164859.GA17878@srcf.ucam.org>
 <20100204170826.GA16397@elte.hu>
 <20100204173602.GA19855@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204173602.GA19855@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Feb 04, 2010 at 06:08:26PM +0100, Ingo Molnar wrote:
> 
> > Well, once i applied the revert i got no more hangs or crashes today, in 
> > lots of bootups. This is fully repeatable - if i re-apply that commit 
> > with the config i sent the hang happens again.
> 
> If you leave the commit applied, use that config and then enable Radeon KMS 
> under staging, do you get the hang?

drivers/staging/ is generally an exception from all sorts of regression (and 
ABI compatibility, etc.) policies so i dont auto-test it. (because simpy i 
cannot do it in a sane way)

I do test the other thousands of regular mainline drivers though - more than 
a hundred of which get activated for real on my various test-systems.

So if you move a driver (or a piece of a driver) from drivers/staging to 
drivers/ in the -rc6 timeframe, and it causes trouble, i see it as a new 
regression.

But you could claim that it's not a regression because 1) technically the 
code got introduced in drivers/staging/, and staging drivers are not on the 
regression list 2) the Kconfig value is default-off so it can only harm those 
who got lured by a new Kconfig value popping up in -rc7 in a well working 
driver they already have enabled.

So the moving of driver functionality from drivers/staging/ to drivers/ is a 
grey area it appears. Wouldnt it have been better to do this in the next 
merge window, as all other drivers do? It's not new hardware enablement 
either, it's feature enablement for an existing driver.

Thanks,

	Ingo
