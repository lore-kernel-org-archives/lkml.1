Return-Path: <linux-kernel-owner+w=401wt.eu-S932605AbXHVUM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbXHVUM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760179AbXHVUMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:12:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055AbXHVUMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:12:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: 2.6.23-rc3-mm1: net/wireless/rt2x00mac.c build failure
Date: Wed, 22 Aug 2007 22:22:12 +0200
User-Agent: KMail/1.9.5
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       John Linville <linville@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222154.03663.m.kozlowski@tuxland.pl> <200708222212.52805.IvDoorn@gmail.com>
In-Reply-To: <200708222212.52805.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708222222.13618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 22 August 2007 22:12, Ivo van Doorn wrote:
> Hi,
> 
> >   CC [M]  drivers/net/wireless/zd1211rw-mac80211/zd_mac.o
> > drivers/net/wireless/zd1211rw-mac80211/zd_mac.c: In function `zd_op_erp_ie_changed':
> > drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: `IEEE80211_ERP_CHANGE_PREAMBLE' undeclared (first use in this function)
> > drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: (Each undeclared identifier is reported only once
> > drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: for each function it appears in.)
> > drivers/net/wireless/zd1211rw-mac80211/zd_mac.c: At top level:
> > drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:844: error: unknown field `erp_ie_changed' specified in initializer
> > drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:844: warning: initialization from incompatible pointer type
> > make[4]: *** [drivers/net/wireless/zd1211rw-mac80211/zd_mac.o] Error 1
> > make[3]: *** [drivers/net/wireless/zd1211rw-mac80211] Error 2
> > make[2]: *** [drivers/net/wireless] Error 2
> > make[1]: *** [drivers/net] Error 2
> > make: *** [drivers] Error 2
> 
> I'm not a zd1211rw developer, but a quick look into the patch series it seems
> that the mac80211 version in -mm1 does not contain the patch
> [PATCH 4/4] mac80211: implement ERP info change notifications
> But it does contain the zd1211rw patch:
> [PATCH] zd1211rw-mac80211: use correct preambles for RTS/CTS frames
> Which depended on the above mentioned mac80211 patch.
> 
> Just had a second thought about those rt2x00 compilation errors you reported,
> the error is not caused by rt2x00 lagging behind mac80211 api changes but
> that rt2x00 patches to follow the api changes are going upstream but
> the mac80211 api changes it depends on are not going anywhere.
> 
> It seems that mac80211 has not been updated in the -mm tree while the
> drivers have been updated. This is causing the compilation errors for both
> rt2x00 as zd1211rw.
> I'll bet that if you try any other mac80211 driver similar issues will arise.

Yup.  This also happens to the b43 driver, for example.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
