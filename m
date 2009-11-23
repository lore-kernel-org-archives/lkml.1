Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZKWHIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZKWHIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 02:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZKWHIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 02:08:49 -0500
Received: from smtp.nokia.com ([192.100.105.134]:24532 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZKWHIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 02:08:49 -0500
Date: Mon, 23 Nov 2009 09:08:28 +0200
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Liam Girdwood <lrg@slimlogic.co.uk>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>
Subject: Re: [PATCH 1/1] twl4030-regulator: Remove regulator from all
 groups when disabling
Message-ID: <20091123070828.GB25705@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1258734559-15594-1-git-send-email-eduardo.valentin@nokia.com>
 <1258744079.3640.435.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258744079.3640.435.camel@odin>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Nov 2009 07:08:32.0655 (UTC) FILETIME=[C44189F0:01CA6C0B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Liam,

On Fri, Nov 20, 2009 at 08:07:59PM +0100, ext Liam Girdwood wrote:
> On Fri, 2009-11-20 at 18:29 +0200, Eduardo Valentin wrote:
> > Just remove regulator from all groups when disabling. This way we
> > avoid problems if boot loader touches twl4030 registers.
> > 
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > ---
> >  drivers/regulator/twl4030-regulator.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
> > index e2032fb..27b3115 100644
> > --- a/drivers/regulator/twl4030-regulator.c
> > +++ b/drivers/regulator/twl4030-regulator.c
> > @@ -126,7 +126,7 @@ static int twl4030reg_disable(struct regulator_dev *rdev)
> >  	if (grp < 0)
> >  		return grp;
> >  
> > -	grp &= ~P1_GRP;
> > +	grp &= ~(P1_GRP & P2_GRP | P3_GRP);
> >  	return twl4030reg_write(info, VREG_GRP, grp);
> >  }
> >  
> 
> Applied.

Thanks for applying. But this one has actually a typo
It was supposed to be:

+	grp &= ~(P1_GRP | P2_GRP | P3_GRP);

Could you please apply this one instead:
http://lkml.org/lkml/2009/11/20/231

?

> 
> Thanks
> 
> Liam
> 


BR,

-- 
Eduardo Valentin
