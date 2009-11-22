Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZKVPVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZKVPVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 10:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZKVPVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 10:21:25 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59702 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZKVPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 10:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=a97/BEm4pIwBHw6iwvyMV3hjfyCH2w3r/tPePv+d/lT51saYX9GEOBUljf+FkxkGOe
         y0Etp/95/C5VWBktlA2uODPJWOwDi3LccwUe+ldiBUXUV018mpfpX8r97FJYB01GPeFc
         tWcoLnKslAwGKtxVcoKwTARybOxr0XqduSBr0=
Date: Sun, 22 Nov 2009 16:21:31 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-Id: <20091122162131.0e2e60ef.kristoffer.ericson@gmail.com>
In-Reply-To: <200911221519.54284.rjw@sisk.pl>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
	<4B08258E.9050607@gmail.com>
	<1258886823.7094.101.camel@johannes.local>
	<200911221519.54284.rjw@sisk.pl>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 15:19:54 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 22 November 2009, Johannes Berg wrote:
> > On Sat, 2009-11-21 at 09:38 -0800, Justin P. Mattock wrote:
> > 
> > > I did a bisect yesterday on this, and the results
> > > seemed to have worked over here by reverting:
> > > 
> > > 75e6c3b72b3ab01c47629f3fbd0fed4e6550bf3a
> > > cfg80211: lower dynamic PS timeout to 100ms
> > > 
> > > if Kristoffer can try reverting this one
> > > to see, then we can go from there.
> > 
> > So that just means the driver is broken. Please run
> > 
> > 	iwconfig wlan0 power off
> > 
> > to fix it then. And the patch below will disable it by default since
> > it's broken.
> > 
> > johannes
> > 
> > --- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-11-22 11:44:41.000000000 +0100
> > +++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-11-22 11:45:26.000000000 +0100
> > @@ -1893,6 +1893,8 @@ void ath_set_hw_capab(struct ath_softc *
> >  		BIT(NL80211_IFTYPE_ADHOC) |
> >  		BIT(NL80211_IFTYPE_MESH_POINT);
> >  
> > +	hw->wiphy->ps_default = false;
> > +
> >  	hw->queues = 4;
> >  	hw->max_rates = 4;
> >  	hw->channel_change_time = 5000;
> 
> OK, so perhaps this patch should be applied until th ath9k driver is fixed?  Luis?  John?

I applied the patch from johannes and it ended my issues atleast. I ran my machine for approx
2 hours without seeing the disconnect issue (which I usually saw after 15-25min). Cant be 100% of course
but so far so good.

I agree with Justin that we could wait until he gets a chance to test it. It should be accepted
after initial merge (and stable trees) after that I think. Rafael thoughts?

Also, we should notify the atheros people so they could start fixing the driver (in a perfect world).

Best wishes
Kristoffer Ericson



-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
