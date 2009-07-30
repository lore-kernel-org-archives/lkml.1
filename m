Return-Path: <linux-kernel-owner+w=401wt.eu-S1751356AbZG3Ogu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbZG3Ogu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbZG3Ogu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:36:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48332 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZG3Ogt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:36:49 -0400
Date: Thu, 30 Jul 2009 16:36:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Paul Moore <paul.moore@hp.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] net/netlabel: Add kmalloc NULL tests
In-Reply-To: <200907301032.20318.paul.moore@hp.com>
Message-ID: <Pine.LNX.4.64.0907301636280.8734@ask.diku.dk>
References: <Pine.LNX.4.64.0907301610230.8734@ask.diku.dk>
 <200907301032.20318.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009, Paul Moore wrote:

> On Thursday 30 July 2009 10:10:54 am Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> >
> > The test on map4 should be a test on map6.
> 
> ...
> 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> >
> > ---
> >  net/netlabel/netlabel_kapi.c        |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> > index 3ff6f32..6ce0020 100644
> > --- a/net/netlabel/netlabel_kapi.c
> > +++ b/net/netlabel/netlabel_kapi.c
> > @@ -151,7 +151,7 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
> >  			addr6 = addr;
> >  			mask6 = mask;
> >  			map6 = kzalloc(sizeof(*map6), GFP_ATOMIC);
> > -			if (map4 == NULL)
> > +			if (!map6)
> >  				goto cfg_unlbl_map_add_failure;
> >  			map6->type = NETLBL_NLTYPE_UNLABELED;
> >  			ipv6_addr_copy(&map6->list.addr, addr6);
> 
> Another good find, although I would suggest changing it to the following to 
> stay consistent with the rest of the function:
> 
> 		map6 = kzalloc(...);
> 		if (map6 == NULL)
> 			goto ...;

OK, I hesitated...  I'll send a new patch shortly.

julia
