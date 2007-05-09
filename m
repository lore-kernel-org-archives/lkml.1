Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbXEIKvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbXEIKvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbXEIKvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:51:02 -0400
Received: from mail.z-net.ru ([89.113.80.10]:4028 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbXEIKvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:51:00 -0400
Date: Wed, 9 May 2007 14:50:20 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 -- Compile =?utf8?Q?error?=
	=?utf8?Q?=3A_include=2Flinux=2Fpower=5Fsupply=2Eh=3A125=3A_error=3A_field?=
	=?utf8?B?IOKAmGNoYW5nZWRfd29ya+KAmQ==?= has incomplete type
Message-ID: <20070509105019.GA20209@zarina>
Reply-To: cbou@mail.ru
References: <a44ae5cd0705090343n6ddae15he51198a0e448198a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <a44ae5cd0705090343n6ddae15he51198a0e448198a@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 03:43:34AM -0700, Miles Lane wrote:
>   CC      drivers/power/power_supply_core.o
>  In file included from drivers/power/power_supply_core.c:18:
>  include/linux/power_supply.h:125: error: field 'changed_work' has
>  incomplete type
>  drivers/power/power_supply_core.c: In function 'power_supply_changed_work':
>  drivers/power/power_supply_core.c:25: warning: type defaults to 'int'
>  in declaration of '__mptr'
>  drivers/power/power_supply_core.c:25: warning: initialization from
>  incompatible pointer type
>  drivers/power/power_supply_core.c: In function 'power_supply_changed':
>  drivers/power/power_supply_core.c:57: warning: implicit declaration of
>  function 'schedule_work'
>  drivers/power/power_supply_core.c: In function 'power_supply_register':
>  drivers/power/power_supply_core.c:103: warning: implicit declaration
>  of function 'INIT_WORK'
>  drivers/power/power_supply_core.c: In function 'power_supply_unregister':
>  drivers/power/power_supply_core.c:128: warning: implicit declaration
>  of function 'flush_scheduled_work'
>  make[2]: *** [drivers/power/power_supply_core.o] Error 1

Oh oh.. yet another refactors in -mm. It compiles clean on bare
2.6.21, though. But power_supply.h is indeed wrong, it assumed that
workqueue.h included by other headers, it is not. I hope following patch
will fix it.


diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 14e617b..2f47df7 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -14,6 +14,7 @@
 #define __LINUX_POWER_SUPPLY_H__
 
 #include <linux/device.h>
+#include <linux/workqueue.h>
 #include <linux/leds.h>
 
 /*
