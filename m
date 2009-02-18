Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZBRC5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZBRC5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZBRC5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:57:34 -0500
Received: from mail.openmoko.org ([88.198.124.205]:59547 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZBRC5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:57:34 -0500
Date: Wed, 18 Feb 2009 08:27:10 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andy@openmoko.com, drzeus-mmc@drzeus.cx
Subject: Re: [PATCH] mmc: In mmc_power_up, use previously selected ocr if
	available
Message-ID: <20090218025708.GA3189@fedora.yogi>
References: <20090209132806.GD3278@fedora.yogi> <20090217132900.dc041bd5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217132900.dc041bd5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 01:29:00PM -0800, Andrew Morton wrote:
> On Mon, 9 Feb 2009 18:58:08 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
> > When mmc_power_up is called during unsafe resume, host->ocr should be
> > used instead of host->ocr_avail.
> > 
> > Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> > Cc: Andy Green <andy@openmoko.com>
> > Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
> > ---
> >  drivers/mmc/core/core.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > index df6ce4a..3ad7f87 100644
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -572,7 +572,13 @@ void mmc_set_timing(struct mmc_host *host, unsigned int timing)
> >   */
> >  static void mmc_power_up(struct mmc_host *host)
> >  {
> > -	int bit = fls(host->ocr_avail) - 1;
> > +	int bit;
> > +
> > +	/* If ocr is set, we use it */
> > +	if (host->ocr)
> > +		bit = ffs(host->ocr) - 1;
> > +	else
> > +		bit = fls(host->ocr_avail) - 1;
> >  
> >  	host->ios.vdd = bit;
> >  	if (mmc_host_is_spi(host)) {
> 
> What are the user-visible consequences of not having this patch in
> their kernels?
> 
> In other words, what does this patch fix?
> 
> Please always include this information in changelogs.
> 
OK, sorry about that.

Actually, it's nothing more than the wrong voltage being used on resume.
I have seen no consequences of this, but it shouldn't be doing so and
should be using the voltage determined at probing time.

> See, this patch is applicable to 2.6.28, 2.6.27, 2.6.26, 2.6.25 and
> probably earlier.  But I don't have a clue whether it should be applied
> to those kernels, because you didn't tell me.

But since I haven't really seen any trouble, we could well apply it only
to the current kernel ?

Thanks,
Balaji
