Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZKVOTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZKVOTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 09:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZKVOTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 09:19:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33456 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbZKVOTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 09:19:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Date: Sun, 22 Nov 2009 15:19:54 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-wireless@vger.kernel.org
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera> <4B08258E.9050607@gmail.com> <1258886823.7094.101.camel@johannes.local>
In-Reply-To: <1258886823.7094.101.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911221519.54284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 November 2009, Johannes Berg wrote:
> On Sat, 2009-11-21 at 09:38 -0800, Justin P. Mattock wrote:
> 
> > I did a bisect yesterday on this, and the results
> > seemed to have worked over here by reverting:
> > 
> > 75e6c3b72b3ab01c47629f3fbd0fed4e6550bf3a
> > cfg80211: lower dynamic PS timeout to 100ms
> > 
> > if Kristoffer can try reverting this one
> > to see, then we can go from there.
> 
> So that just means the driver is broken. Please run
> 
> 	iwconfig wlan0 power off
> 
> to fix it then. And the patch below will disable it by default since
> it's broken.
> 
> johannes
> 
> --- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-11-22 11:44:41.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-11-22 11:45:26.000000000 +0100
> @@ -1893,6 +1893,8 @@ void ath_set_hw_capab(struct ath_softc *
>  		BIT(NL80211_IFTYPE_ADHOC) |
>  		BIT(NL80211_IFTYPE_MESH_POINT);
>  
> +	hw->wiphy->ps_default = false;
> +
>  	hw->queues = 4;
>  	hw->max_rates = 4;
>  	hw->channel_change_time = 5000;

OK, so perhaps this patch should be applied until th ath9k driver is fixed?  Luis?  John?
