Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYGNHYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYGNHYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbYGNHYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:24:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36199 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbYGNHYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:24:41 -0400
Date: Mon, 14 Jul 2008 16:23:31 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zhang Rui <rui.zhang@intel.com>, Rus <harbour@sfinx.od.ua>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [mmotm] pm: fix build error
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080714162102.F6D1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

My IA64 machine can't build on today's mmotm(Jul 13).
So, below patch is necessary, I think.

----------------------------------------------------
Against: mmotm, Jul 13
Applies after: pm-schedule-sysrq-poweroff-on-boot-cpu.patch

Now, handle_poweroff() use cpu_online_map variable.
So cpumask.h sould be included.
Otherwise it cause following build error on ia64 (I guess also sevaral othor platfom).

	kernel/power/poweroff.c: In function 'handle_poweroff':
	kernel/power/poweroff.c:29: error: implicit declaration of function 'first_cpu'
	kernel/power/poweroff.c:29: error: 'cpu_online_map' undeclared (first use in this function)
	kernel/power/poweroff.c:29: error: (Each undeclared identifier is reported only once
	kernel/power/poweroff.c:29: error: for each function it appears in.)
	make[2]: *** [kernel/power/poweroff.o] Error 1
	make[1]: *** [kernel/power] Error 2


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Zhang Rui <rui.zhang@intel.com>
CC: Rus <harbour@sfinx.od.ua>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>

---
 kernel/power/poweroff.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/kernel/power/poweroff.c
===================================================================
--- a/kernel/power/poweroff.c
+++ b/kernel/power/poweroff.c
@@ -10,6 +10,7 @@
 #include <linux/pm.h>
 #include <linux/workqueue.h>
 #include <linux/reboot.h>
+#include <linux/cpumask.h>
 
 /*
  * When the user hits Sys-Rq o to power down the machine this is the


