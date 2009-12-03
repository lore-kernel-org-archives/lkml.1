Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZLCUN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZLCUN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZLCUN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:13:58 -0500
Received: from smtp.nokia.com ([192.100.105.134]:24668 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZLCUN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:13:57 -0500
Message-ID: <4B181BB4.1020800@nokia.com>
Date: Thu, 03 Dec 2009 22:12:36 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Cliff Brake <cbrake@bec-systems.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "madhu.cr@ti.com >> Madhusudhan Chikkature" <madhu.cr@ti.com>
Subject: Re: [PATCH] mmc: move regulator handling to core
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de> <4B17CADB.1070406@nokia.com> <20091203192044.GJ14091@buzzloop.caiaq.de>
In-Reply-To: <20091203192044.GJ14091@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2009 20:12:37.0740 (UTC) FILETIME=[F57152C0:01CA7454]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> On Thu, Dec 03, 2009 at 04:27:39PM +0200, Adrian Hunter wrote:
>> gDaniel Mack wrote:
> 
> [...]
> 
>>> drivers/mmc/core/core.c   |   36 ++++++++++++++++++++----------------
>>> drivers/mmc/core/host.c   |    3 +++
>>> drivers/mmc/host/mmci.c   |   28 ++++++++++++----------------
>>> drivers/mmc/host/mmci.h   |    1 -
>>> drivers/mmc/host/pxamci.c |   20 ++++++++------------
>>> include/linux/mmc/host.h  |   10 ++++++----
>> What about arch/arm/mach-omap2/mmc-twl4030.c ?
> 
> Argh, missed that one. And this particular case doesn't fit to my
> modifications. I don't know the code well ...  We would need to
> have a struct mmc_host * in all the functions there calling
> mmc_regulator_{set,get}_ocr. Any idea how to resolve that?
> 

Pass it down from the omap_hsmmc driver.

>>> --- a/drivers/mmc/core/host.c
>>> +++ b/drivers/mmc/core/host.c
>>> @@ -18,6 +18,7 @@
>>> #include <linux/leds.h>
>>> #include <linux/mmc/host.h>
>>> +#include <linux/regulator/consumer.h>
>>> #include "core.h"
>>> #include "host.h"
>>> @@ -154,6 +155,8 @@ void mmc_remove_host(struct mmc_host *host)
>>> 	mmc_remove_host_debugfs(host);
>>> #endif
>>> +	regulator_put(host->vcc);
>>> +
>> If the core is doing a 'regulator_put()' shouldn't it also be doing
>> a 'regulator_get()'?  Why not leave it to the drivers?
> 
> Yes, I can change the patch to do that, no problem. The major reason why
> I didn't put the regulator_get() to the mmc core is that I need to have
> the platform_device to obtain its name.
> 
> Daniel
> 
> 

