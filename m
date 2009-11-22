Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZKVPCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZKVPCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 10:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZKVPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 10:02:07 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48212 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZKVPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 10:02:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UJ9hPUcx76W2gcBvAiZyZXneM5JtE8XWNhgNdKZH7PpcWXYKv9+bFryRsEeldHBZl9
         93tx86ojHYyO95IAi1O+ZbLv0X0egNBdjAQ7AkFamNJ3pP2UUYJ9MfU5tF2BBoJB/JVG
         Hy/hFrtr9hxVVcR4qzXFoeO8wHQEvCgJIMno8=
Message-ID: <4B0952A6.7010704@gmail.com>
Date: Sun, 22 Nov 2009 07:03:02 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>	 <mYW9sxtWd2G.A.EnF.gDACLB@chimera>  <4B08258E.9050607@gmail.com> <1258886823.7094.101.camel@johannes.local>
In-Reply-To: <1258886823.7094.101.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> On Sat, 2009-11-21 at 09:38 -0800, Justin P. Mattock wrote:
>
>    
>> I did a bisect yesterday on this, and the results
>> seemed to have worked over here by reverting:
>>
>> 75e6c3b72b3ab01c47629f3fbd0fed4e6550bf3a
>> cfg80211: lower dynamic PS timeout to 100ms
>>
>> if Kristoffer can try reverting this one
>> to see, then we can go from there.
>>      
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
>   		BIT(NL80211_IFTYPE_ADHOC) |
>   		BIT(NL80211_IFTYPE_MESH_POINT);
>
> +	hw->wiphy->ps_default = false;
> +
>   	hw->queues = 4;
>   	hw->max_rates = 4;
>   	hw->channel_change_time = 5000;
>
>
>
>    
I'm in the process of stepping out
of my office for a few days.
(can probably give a try where I'm
headed, just give me some time).

Justin P. Mattock
