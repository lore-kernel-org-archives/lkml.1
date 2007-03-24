Return-Path: <linux-kernel-owner+w=401wt.eu-S934045AbXCXBtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbXCXBtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 21:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934341AbXCXBtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 21:49:49 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:43237 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934045AbXCXBts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 21:49:48 -0400
Message-ID: <460483B5.70808@lwfinger.net>
Date: Fri, 23 Mar 2007 20:49:41 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       reiserfs-dev@namesys.com
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>	 <1174433034.62033.16.camel@localhost>	 <20070320223643.d8cbc3f6.akpm@linux-foundation.org>	 <46015990.0@lwfinger.net> <1174678832.289400.16.camel@localhost>
In-Reply-To: <1174678832.289400.16.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx wrote:
> 
> It may have partly been a problem of having half of softmac and half
> devicescape.  I'm not entirely sure what udev did.
> 
> I tried a patch for the Sonic Silicon that was posted and I turned off
> all the configuration for the softmac driver.
> 
> It isn't crashing right now but 802.11 isn't working either.  I may get
> a chance this weekend to try some things with it, and some different
> firmware sets.

That is my experience with a 4311. It does the open authentication and associates, but the WPA
authentication step times out and I never get connected.

> If the new bcm43xx drivers do not support 802.11b at all and never will,
> I missed the documentation.  Someone should add that to Kconfig.

Yes it should. Until bcm43xx-mac80211 got picked up by -mm, it was only used within the bcm43xx
group and that was understood in that circle. It has just been decided that the softmac version of
the driver will be renamed bcm4301 and be converted to use mac80211. When bcm43xx-mac80211 goes
mainline, bcm4301 will be restricted to 802.11b-only cards. That is the way we will support the
older cards. The reason for a separate driver is that the bcm4301 and bcm4303 do not have sufficient
memory to run the latest firmware (V4), and bcm43xx-mac80211 only uses that firmware; whereas
bcm4301 will use the older V3 firmware.

Larry


