Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbXEIVIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbXEIVIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXEIVIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:08:23 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34435 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbXEIVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:08:22 -0400
Date: Wed, 9 May 2007 23:08:20 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org
Subject: 2.6.21-mm2: power_supply_core.c build failure
Message-ID: <20070509210818.GA7672@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  CC      drivers/power/power_supply_core.o
In file included from drivers/power/power_supply_core.c:18:
include/linux/power_supply.h:125: error: field 'changed_work' has incomplete type
drivers/power/power_supply_core.c: In function 'power_supply_changed_work':
drivers/power/power_supply_core.c:25: warning: type defaults to 'int' in declaration of '__mptr'
drivers/power/power_supply_core.c:25: warning: initialization from incompatible pointer type
drivers/power/power_supply_core.c: In function 'power_supply_changed':
drivers/power/power_supply_core.c:57: warning: implicit declaration of function 'schedule_work'
drivers/power/power_supply_core.c: In function 'power_supply_register':
drivers/power/power_supply_core.c:103: warning: implicit declaration of function 'INIT_WORK'
drivers/power/power_supply_core.c: In function 'power_supply_unregister':
drivers/power/power_supply_core.c:128: warning: implicit declaration of function 'flush_scheduled_work'
make[3]: *** [drivers/power/power_supply_core.o] Error 1
make[2]: *** [drivers/power] Error 2
make[1]: *** [drivers] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.21-mm2.agp'
make: *** [debian/stamp-build-kernel] Error 2

CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_OLPC is not set

P3/700 UP, gcc 4.1.3.

Care to add a #include <linux/workqueue.h> or so? ;)
(worked for me when adding to include/linux/power_supply.h)

Ugh, such a pain following ever-outdated and always-broken -mm versions ;)

Andreas Mohr
