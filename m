Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752609AbYLRRLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYLRRLh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYLRRLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:11:21 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:45000 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYLRRLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:11:20 -0500
Date: Thu, 18 Dec 2008 18:11:15 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: lrodriguez@atheros.com, jmalinen@atheros.com,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/11] drivers/net/wireless/ath9k: Move a dereference
 below a NULL test
In-Reply-To: <20081218155042.GF4121@tuxdriver.com>
Message-ID: <Pine.LNX.4.64.0812181807330.23988@ask.diku.dk>
References: <Pine.LNX.4.64.0812161613510.20444@pc-004.diku.dk>
 <20081218155042.GF4121@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, John W. Linville wrote:

> On Tue, Dec 16, 2008 at 04:14:28PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > In each case, if the NULL test is necessary, then the dereference should be
> > moved below the NULL test.
> > 
> > The semantic patch that makes this change is as follows:
> > (http://www.emn.fr/x-info/coccinelle/)
> > 
> > // <smpl>
> > @@
> > type T;
> > expression E;
> > identifier i,fld;
> > statement S;
> > @@
> > 
> > - T i = E->fld;
> > + T i;
> >   ... when != E
> >       when != i
> >   if (E == NULL) S
> > + i = E->fld;
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  drivers/net/wireless/ath9k/hw.c     |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
> > index 98bc25c..7d1dac6 100644
> > --- a/drivers/net/wireless/ath9k/hw.c
> > +++ b/drivers/net/wireless/ath9k/hw.c
> > @@ -5581,11 +5581,12 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
> >  	struct ath9k_channel ichan;
> >  	bool isCalDone;
> >  	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
> > -	const struct hal_percal_data *calData = currCal->calData;
> > +	const struct hal_percal_data *calData;
> >  	int i;
> >  
> >  	if (currCal == NULL)
> >  		return false;
> > +	calData = currCal->calData;
> >  
> >  	ichan.CalValid = 0;
> 
> This patch doesn't seem to apply.  I don't see this code anywhere.
> Perhaps this is against some older version?

I used the following version of linux-next, which indeed a bit out of 
date:

commit feaf3848a813a106f163013af6fcf6c4bfec92d9
Merge: a771132... 0e435ac...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Dec 3 16:45:56 2008 -0800


But I see the same code in the following version of linux-2.6

commit 1bda71282ded6a2e09a2db7c8884542fb46bfd4f
Merge: 7a62b17... 25a41b2...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Dec 16 09:49:10 2008 -0800

julia
