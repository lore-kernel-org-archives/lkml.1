Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbXGWWJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbXGWWJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbXGWWI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:08:58 -0400
Received: from www.osadl.org ([213.239.205.134]:50174 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911AbXGWWI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:08:57 -0400
Subject: Re: [PATCH] drivers/char/hpet.c: integer constant is too large for
	"long" type
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: caglar@pardus.org.tr, Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20070723145940.a99b0324.akpm@linux-foundation.org>
References: <200707211419.47680.caglar@pardus.org.tr>
	 <20070723145940.a99b0324.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 00:08:55 +0200
Message-Id: <1185228535.3318.44.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 14:59 -0700, Andrew Morton wrote:
> On Sat, 21 Jul 2007 14:19:44 +0300
> "S.__a__lar Onur" <caglar@pardus.org.tr> wrote:
> 
> > Following trivial patch silents
> > 
> > drivers/char/hpet.c:76: warning: integer constant is too large for "long" type
> > 
> > warning (with gcc-3.4.6)
> > 
> > Signed-off-by: S.__a__lar Onur <caglar@pardus.org.tr>
> >  
> >  drivers/char/hpet.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> > index ba0e74a..23fadf5 100644
> > --- a/drivers/char/hpet.c
> > +++ b/drivers/char/hpet.c
> > @@ -73,7 +73,7 @@ static struct clocksource clocksource_hpet = {
> >          .name           = "hpet",
> >          .rating         = 250,
> >          .read           = read_hpet,
> > -        .mask           = 0xffffffffffffffff,
> > +        .mask           = 0xffffffffffffffffLL,
> >          .mult           = 0, /*to be caluclated*/
> >          .shift          = 10,
> >          .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
> 
> hm, well, this does assume that cycle_t is implemented as long long (or
> unsigned long long, actually).  Which in turn assumes that u64 is
> implemented as [unsigned] long long.
> 
> Not all architectures use unsigned long long for u64: some use unsigned
> long.  They'll probably be OK with this change but I think I'll convert
> that into plain old "-1", which just works everywhere.

	.mask = CLOCKSOURCE_MASK(64)

should work

	tglx




