Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZKVKrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZKVKrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 05:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZKVKrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 05:47:04 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:58258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZKVKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 05:47:03 -0500
Subject: Re: [Bug #14267] Disassociating atheros wlan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
In-Reply-To: <4B08258E.9050607@gmail.com>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
	 <mYW9sxtWd2G.A.EnF.gDACLB@chimera>  <4B08258E.9050607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 11:47:03 +0100
Message-ID: <1258886823.7094.101.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-21 at 09:38 -0800, Justin P. Mattock wrote:

> I did a bisect yesterday on this, and the results
> seemed to have worked over here by reverting:
> 
> 75e6c3b72b3ab01c47629f3fbd0fed4e6550bf3a
> cfg80211: lower dynamic PS timeout to 100ms
> 
> if Kristoffer can try reverting this one
> to see, then we can go from there.

So that just means the driver is broken. Please run

	iwconfig wlan0 power off

to fix it then. And the patch below will disable it by default since
it's broken.

johannes

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-11-22 11:44:41.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-11-22 11:45:26.000000000 +0100
@@ -1893,6 +1893,8 @@ void ath_set_hw_capab(struct ath_softc *
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
+	hw->wiphy->ps_default = false;
+
 	hw->queues = 4;
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;


