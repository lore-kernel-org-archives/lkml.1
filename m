Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZDXUr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZDXUr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZDXUrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:47:18 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:39816 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbZDXUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:47:17 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for April 24 (p54 build error) (and pull request: wireless-next-2.6 2009-04-24)
Date: Fri, 24 Apr 2009 22:47:14 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-wl; KDE/4.2.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       davem@davemloft.net
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au> <49F1FD4B.2020909@oracle.com>
In-Reply-To: <49F1FD4B.2020909@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904242247.15042.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX18ZZjc59irCXv0RK5Z4IPi/onAAvhLZZzwHiB6j
	SwsHVgNYpdVyBfoHY3ctutKg5BX0iV2Br2PHeGKBqE4hWt+uMs
	r8PZ0x9Is=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 April 2009 19:56:27 Randy Dunlap wrote:
> 
> drivers/net/wireless/p54/p54.h:193: error: array type has incomplete element type
> 
> struct p54_led_dev definition is controlled by
> #ifdef CONFIG_P54_LEDS (is not set)
> 
> but the struct declaration is controlled by
> #ifdef CONFIG_MAC80211_LEDS (=y)
> 
meh, [p54: more SoftLED updates] broke it
( dce072580e095d1fb7be59a1be30dc0e8307821b )

this also affects "pull request: wireless-next-2.6 2009-04-24"

and the current wireless-testing!

however the patches on the linux-wireless are all fine?!
(see: http://osdir.com/ml/linux-wireless/2009-03/msg01240.html )

I guess there was merge conflict with [p54: more SoftLED updates] 
and [p54: replace MAC80211_LEDS with P54_LEDS in p54.h] ?

Regards,
	Chr
---
In case someone want to fix it manually... here's the undo:
---
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 7fda1a9..db3df94 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -189,10 +189,10 @@ struct p54_common {
 	unsigned long *used_rxkeys;
 
 	/* LED management */
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_P54_LEDS
 	struct p54_led_dev leds[4];
 	struct delayed_work led_work;
-#endif /* CONFIG_MAC80211_LEDS */
+#endif /* CONFIG_P54_LEDS */
 	u16 softled_state;		/* bit field of glowing LEDs */
 
 	/* statistics */
