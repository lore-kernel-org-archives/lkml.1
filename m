Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZKVP3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZKVP3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 10:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbZKVP33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 10:29:29 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42881 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZKVP32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 10:29:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Fqf8MHW8sAoVbXIAcOrK1RiLPZhfM7/FXt+pFY03Zx2MkllIkGmw4HUbQ4BFccCeQt
         HzE9Kzk92IK18uv6FEZiP5eybEpglHE9h5wNKWFfLJbHZbTOpvHfW/4CBdtfUzeJ4n9N
         5b0tfoLGqFayFQR/zdLxJNFFI9kKg8PAiWHcQ=
Date: Sun, 22 Nov 2009 16:29:36 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-Id: <20091122162936.ac603ad1.kristoffer.ericson@gmail.com>
In-Reply-To: <1258886823.7094.101.camel@johannes.local>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
	<mYW9sxtWd2G.A.EnF.gDACLB@chimera>
	<4B08258E.9050607@gmail.com>
	<1258886823.7094.101.camel@johannes.local>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 11:47:03 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

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
> 
> 

Johannes, am I correct in thinking that this also solves the decreased signal strength
issue in bug http://bugzilla.kernel.org/show_bug.cgi?id=13807 ?


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
