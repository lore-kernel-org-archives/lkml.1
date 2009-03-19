Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZCSS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZCSS45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCSS4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:56:45 -0400
Received: from bu3sch.de ([62.75.166.246]:53802 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZCSS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:56:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for March 19 (wireless/p54)
Date: Thu, 19 Mar 2009 19:55:00 +0100
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au> <200903191850.17825.mb@bu3sch.de> <49C293CC.6020009@oracle.com>
In-Reply-To: <49C293CC.6020009@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903191955.00718.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009 19:49:48 Randy Dunlap wrote:
> Michael Buesch wrote:
> > On Thursday 19 March 2009 18:28:30 Randy Dunlap wrote:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20090318:
> >>
> >> ERROR: "led_classdev_register" [drivers/net/wireless/p54/p54common.ko] undefined!
> >> ERROR: "led_classdev_unregister" [drivers/net/wireless/p54/p54common.ko] undefined!
> >>
> >> One possible option (fix) is to have CONFIG_MAC80211_LEDS also select
> >> LEDS_CLASS (that would build the missing functions).
> > 
> > Does p54 select CONFIG_MAC80211_LEDS? If that's the case, I think it should
> 
>   No, it doesn't.  p54common.c just has a large block of code that is
> surrounded by
> #ifdef CONFIG_MAC80211_LEDS
> ...
> #endif

Yeah. I do think that it'd be wrong for mac80211 to select LEDS_CLASS.
mac80211 implements the triggers and the lowlevel drivers implement the LED class device.
So mac80211 does not depend on LEDS_CLASS at all.

So p54 should probably introduce an automagic config option like b43 does, or it should do
something (ugly) like this:

#if defined(CONFIG_MAC80211_LEDS) && (defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE))
...
#endif
-- 
Greetings, Michael.
