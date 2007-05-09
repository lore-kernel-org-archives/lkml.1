Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXEIV2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXEIV2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXEIV2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:28:34 -0400
Received: from mail.z-net.ru ([89.113.80.10]:1568 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbXEIV2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:28:33 -0400
Date: Thu, 10 May 2007 01:27:42 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2: power_supply_core.c build failure
Message-ID: <20070509212742.GA10967@zarina>
Reply-To: cbou@mail.ru
References: <20070509210818.GA7672@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070509210818.GA7672@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 11:08:20PM +0200, Andreas Mohr wrote:
> Hi,
> 
>   CC      drivers/power/power_supply_core.o
> In file included from drivers/power/power_supply_core.c:18:
> include/linux/power_supply.h:125: error: field 'changed_work' has incomplete type
> drivers/power/power_supply_core.c: In function 'power_supply_changed_work':
> drivers/power/power_supply_core.c:25: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/power/power_supply_core.c:25: warning: initialization from incompatible pointer type
> drivers/power/power_supply_core.c: In function 'power_supply_changed':
> drivers/power/power_supply_core.c:57: warning: implicit declaration of function 'schedule_work'
> drivers/power/power_supply_core.c: In function 'power_supply_register':
> drivers/power/power_supply_core.c:103: warning: implicit declaration of function 'INIT_WORK'
> drivers/power/power_supply_core.c: In function 'power_supply_unregister':
> drivers/power/power_supply_core.c:128: warning: implicit declaration of function 'flush_scheduled_work'
> make[3]: *** [drivers/power/power_supply_core.o] Error 1
> make[2]: *** [drivers/power] Error 2
> make[1]: *** [drivers] Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.21-mm2.agp'
> make: *** [debian/stamp-build-kernel] Error 2
> 
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_BATTERY_DS2760 is not set
> # CONFIG_BATTERY_OLPC is not set
> 
> P3/700 UP, gcc 4.1.3.
> 
> Care to add a #include <linux/workqueue.h> or so? ;)
> (worked for me when adding to include/linux/power_supply.h)
> 
> Ugh, such a pain following ever-outdated and always-broken -mm versions ;)
> 
> Andreas Mohr

http://lkml.org/lkml/2007/5/9/163

Already fixed in battery2-2.6.git. But thanks anyway for reporting. ;-)

I really do test builds prior commiting them, but headers changed
recently, and now including workqueue.h should be explicit. Wondering why
this worked prior, though. ;-)

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
