Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbZJHSus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbZJHSus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbZJHSur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:50:47 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181AbZJHSuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:50:46 -0400
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091008080615.09c8b803.randy.dunlap@oracle.com>
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
	 <1254949672-24022-1-git-send-email-linville@tuxdriver.com>
	 <4ACD0E5A.7060106@oracle.com> <1254954842.3713.7.camel@johannes.local>
	 <4ACD1C3D.3030506@oracle.com> <1254957256.3713.10.camel@johannes.local>
	 <20091007171235.d40f0cc2.randy.dunlap@oracle.com>
	 <1254995282.3713.18.camel@johannes.local>
	 <20091008080615.09c8b803.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Oct 2009 20:29:23 +0200
Message-Id: <1255026563.3713.28.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 08:06 -0700, Randy Dunlap wrote:

> > It's kinda strange though that you can select wireless drivers without
> > selecting WIRELESS. Maybe the solution is as simple as making WLAN
> > (drivers/net/wireless/Kconfig) depend on WIRELESS?
> 
> Yes, I think that would be a very good start.

On the other hand, of course, the whole WIRELESS thing is somewhat
stupid. How about this?

johannes

From: Johannes Berg <johannes@sipsolutions.net>
Subject: wireless: make wireless drivers select core

It is somewhat non-sensical to allow selecting wireless
drivers without showing wireless core code options, and
since the wext refactoring this has made it possible to
generate configurations that will not build. Avoid this
and make wireless drivers select the wireless options.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/drivers/net/wireless/Kconfig	2009-10-08 20:25:04.000000000 +0200
+++ wireless-testing/drivers/net/wireless/Kconfig	2009-10-08 20:27:38.000000000 +0200
@@ -5,6 +5,7 @@
 menuconfig WLAN
 	bool "Wireless LAN"
 	depends on !S390
+	select WIRELESS
 	default y
 	---help---
 	  This section contains all the pre 802.11 and 802.11 wireless


