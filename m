Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbZIPSC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbZIPSC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZIPSC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:02:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:60979 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZIPSC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,399,1249282800"; 
   d="scan'208";a="727547705"
Subject: Re: WARNING: at net/mac80211/scan.c:267
 ieee80211_scan_completed+0x299/0x2b0 	[mac80211]()
From: reinette chatre <reinette.chatre@intel.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <8db1092f0909161036t5bae781eqa6f0a0df308ec4cd@mail.gmail.com>
References: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
	 <1253122055.26521.431.camel@rc-desk>
	 <8db1092f0909161036t5bae781eqa6f0a0df308ec4cd@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 11:02:29 -0700
Message-Id: <1253124149.26521.438.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Wed, 2009-09-16 at 10:36 -0700, Maciej Rutecki wrote:
> 2009/9/16 reinette chatre <reinette.chatre@intel.com>:
> >
> > The important information is not what you posted here, but still in the
> > dmesg file you provided. In that log we see the following right before
> > the warnings:
> >
> > [  163.126590] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
> > [  163.130027] wlan0 direct probe responded
> > [  163.130032] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
> > [  163.131924] wlan0: authenticated
> > [  163.131952] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
> > [  163.134325] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28 (capab=0x431 status=0 aid=1)
> > [  163.134331] wlan0: associated
> > [  163.155938] wlan0: deauthenticating by local choice (reason=3)
> >
> > It shows that association was successful, but something in userspace requested a disconnect.
> 
> Hmm. Yes, connect takes more time than in 2.6.31.

You mentioned that you tried to connect to two networks. From the logs I
can understand that the connection to the first network took a long
time. This is also not due to the warnings you encountered (the warnings
only showed up after you disconnected from second network). The reason
why the connection to the first network took so long was some protocol
exchange problems with AP. Here is the relevant information from your
log:

[  117.741190] wlan0: deauthenticating by local choice (reason=3)
[  117.741308] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  117.745515] wlan0 direct probe responded
[  117.745523] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  117.747256] wlan0: authenticated
[  117.747288] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  117.749529] wlan0: RX AssocResp from 00:1b:11:f6:0f:28 (capab=0x431 status=0 aid=1)
[  117.749536] wlan0: associated
[  121.404153] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  124.123203] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  124.126121] wlan0 direct probe responded
[  124.126129] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  124.127876] wlan0: authenticated
[  124.127906] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  124.130164] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28 (capab=0x431 status=0 aid=1)
[  124.130172] wlan0: associated
[  128.263997] wlan0: disassociated (Reason: 3)
[  128.280067] wlan0: deauthenticating by local choice (reason=3)
[  130.968263] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  130.970685] wlan0 direct probe responded
[  130.970692] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  130.972497] wlan0: authenticated
[  130.972529] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  130.974780] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28 (capab=0x431 status=0 aid=1)
[  130.974787] wlan0: associated
[  134.511593] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  137.216183] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  137.218606] wlan0 direct probe responded
[  137.218614] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  137.220520] wlan0: authenticated
[  137.220555] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  137.222808] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28 (capab=0x431 status=0 aid=1)
[  137.222815] wlan0: associated
[  140.758586] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  143.513364] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  143.524448] wlan0 direct probe responded
[  143.524456] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  143.526207] wlan0: authenticated
[  143.526238] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  143.540625] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28 (capab=0x431 status=0 aid=1)
[  143.540632] wlan0: associated
[  162.901260] b44: eth0: powering down PHY
[  162.919757] wlan0: deauthenticating by local choice (reason=3)

As you can see the AP keeps deauthenticating you with Reason 6. This
means "Incorrect frame type or subtype received from unauthenticated
station". Can you try to connect using wpa_supplicant? When you do make
sure there is no other network managing applications (like network
manager, wicd, or even other instances of wpa_supplicant etc) running.

The connection to the second network went very fast - completed in one
second. But a disconnection was requested locally just as fast. Do you
perhaps have more than one network managing application running?

Reinette


