Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZKWLDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZKWLDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbZKWLDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:03:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:61921 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbZKWLDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:03:43 -0500
Subject: Re: [PATCH 1/1] twl4030-regulator: Remove regulator from all
 groups when disabling
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: eduardo.valentin@nokia.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>
In-Reply-To: <20091123070828.GB25705@esdhcp037198.research.nokia.com>
References: <1258734559-15594-1-git-send-email-eduardo.valentin@nokia.com>
	 <1258744079.3640.435.camel@odin>
	 <20091123070828.GB25705@esdhcp037198.research.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 10:55:27 +0000
Message-ID: <1258973727.3629.63.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 09:08 +0200, Eduardo Valentin wrote:
> Hello Liam,
> 
> On Fri, Nov 20, 2009 at 08:07:59PM +0100, ext Liam Girdwood wrote:
> > On Fri, 2009-11-20 at 18:29 +0200, Eduardo Valentin wrote:
> > > Just remove regulator from all groups when disabling. This way we
> > > avoid problems if boot loader touches twl4030 registers.
> > > 
> > > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > > ---
> > >  drivers/regulator/twl4030-regulator.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
> > > index e2032fb..27b3115 100644
> > > --- a/drivers/regulator/twl4030-regulator.c
> > > +++ b/drivers/regulator/twl4030-regulator.c
> > > @@ -126,7 +126,7 @@ static int twl4030reg_disable(struct regulator_dev *rdev)
> > >  	if (grp < 0)
> > >  		return grp;
> > >  
> > > -	grp &= ~P1_GRP;
> > > +	grp &= ~(P1_GRP & P2_GRP | P3_GRP);
> > >  	return twl4030reg_write(info, VREG_GRP, grp);
> > >  }
> > >  
> > 
> > Applied.
> 
> Thanks for applying. But this one has actually a typo
> It was supposed to be:
> 
> +	grp &= ~(P1_GRP | P2_GRP | P3_GRP);
> 
> Could you please apply this one instead:
> http://lkml.org/lkml/2009/11/20/231
> 
> ?

Ah, I did see the new message but applied the wrong one (they both had
the same subject, a V2 subject would have been better).

Applied correct version now.

Thanks

Liam

