Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0BDSMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:12:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226Ab0BDSMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:12:40 -0500
Date: Thu, 4 Feb 2010 19:12:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204181218.GA6175@elte.hu>
References: <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
 <20100202154656.GD27314@elte.hu>
 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
 <20100204062619.GA29154@elte.hu>
 <20100204071705.GA28403@elte.hu>
 <20100204164859.GA17878@srcf.ucam.org>
 <20100204170826.GA16397@elte.hu>
 <20100204173602.GA19855@srcf.ucam.org>
 <20100204175445.GB27361@elte.hu>
 <20100204175928.GA20595@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204175928.GA20595@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Feb 04, 2010 at 06:54:45PM +0100, Ingo Molnar wrote:
> 
> > But you could claim that it's not a regression because 1) technically the 
> > code got introduced in drivers/staging/, and staging drivers are not on 
> > the regression list 2) the Kconfig value is default-off so it can only 
> > harm those who got lured by a new Kconfig value popping up in -rc7 in a 
> > well working driver they already have enabled.
> > 
> > So the moving of driver functionality from drivers/staging/ to drivers/ 
> > is a grey area it appears. Wouldnt it have been better to do this in the 
> > next merge window, as all other drivers do? It's not new hardware 
> > enablement either, it's feature enablement for an existing driver.
> 
> The reason the option was in staging (as has been mentioned before) was 
> because the ABI wasn't felt to be stable enough. Upstream is now willing to 
> commit to that stability, so now seems as good a time to move it as any. 
> There's no code change and there's no default configuration change, so I 
> really can't see any way that it can be classed as a regression.

But that argument in essence renders the regression policy meaningless for 
such code: just about any new driver feature under the sun could be shaped as 
a Kconfig option, introduced via a drivers/staging Kconfig entry, and then 
activated via a twoliner commit in a later -rc.

IMHO the point of tracking regressions is to reduce the bugginess of the 
kernel and thus to help users, not to give ground for legalistic arguments.

There _are_ common-sense exceptions from the regression rules, such as the 
introduction of a new piece of hardware that was previously unsupported 
(hence there's no expectation of stability) - but the tweaking of an 
existing, widely used driver (even if the new opion is default-off) hardly 
seems to qualify for that.

I dont mind making useful exceptions from rules, as long as we are honest 
about having done it.

Anyway, i've bisected it back to that Kconfig change and i am able to work 
the crashes around by reverting that, so my immediate problems are solved.

Thanks,

	Ingo
