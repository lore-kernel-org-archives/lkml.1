Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYC3Noe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYC3Noe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 09:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYC3No1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 09:44:27 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:54357 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYC3No0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 09:44:26 -0400
Date: Sun, 30 Mar 2008 08:43:27 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 22/35] W1: ds1wm.c msleep for reset
Message-ID: <20080330134327.GA1852@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net> <20080328122700.GW3613@spacedout.fries.net> <20080330113806.GL15122@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080330113806.GL15122@2ka.mipt.ru>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 30 Mar 2008 08:43:30 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 03:38:06PM +0400, Evgeniy Polyakov wrote:
> On Fri, Mar 28, 2008 at 07:27:00AM -0500, David Fries (david@fries.net) wrote:
> > masters/ds1wm.c 1.4
> > Like the previous w1_io.c reset coments and msleep patch, I don't have
> > the hardware to verify the change, but I think it is safe.  It also
> > helps to see a comment like this in the code.
> > "We'll wait a bit longer just to be sure."
> > If they are going to calculate delaying 324.9us, but actually delay
> > 500us, why not just give up the CPU and sleep?  This is designed for a
> > battery powered ARM system, avoiding busywaiting has to be good for
> > battery life.
> 
> Ack, but would like to here from Matt Reimer.
> Added to Cc:

Yes, it would be nice to hear from someone with the hardware, but it
has been over three weeks without a response.

Date:   Fri, 7 Mar 2008 22:37:37 -0600
Subject: [W1] ds1wm: testers please, msleep not udelay
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Matt Reimer <mreimer@vpop.net>


> > I sent a request for testers March 7, 2008 to the Linux kernel mailing
> > list and two developers who have patches for ds1wm.c, but I didn't get
> > any respons.
> > 
> > Signed-off-by: David Fries <david@fries.net>
> > ---
> >  drivers/w1/masters/ds1wm.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
> > index ea894bf..29e144f 100644
> > --- a/drivers/w1/masters/ds1wm.c
> > +++ b/drivers/w1/masters/ds1wm.c
> > @@ -160,8 +160,10 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
> >  	 *     625 us - 60 us - 240 us - 100 ns = 324.9 us
> >  	 *
> >  	 * We'll wait a bit longer just to be sure.
> > +	 * Was udelay(500), but if it is going to busywait the cpu that long,
> > +	 * might as well come back later.
> >  	 */
> > -	udelay(500);
> > +	msleep(1);
> >  
> >  	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
> >  		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
> > -- 
> > 1.4.4.4
> 
> 
> 
> -- 
> 	Evgeniy Polyakov

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
