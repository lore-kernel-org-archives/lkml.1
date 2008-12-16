Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYLPFmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYLPFmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 00:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYLPFmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 00:42:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52822 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYLPFmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 00:42:17 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: akpm <akpm@linux-foundation.org>
Subject: [mmotm][PATCH] Add #include <linux/irqflags.h> to acpi/processor_idle.c
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20081216131105.DB9A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <494726DE.6000100@oracle.com> <20081216131105.DB9A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081216143938.DBA6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 14:42:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Applied after: remove-linux-hardirqh-from-asm-generic-localh.patch

=
Subject: [mmotm][PATCH] Add #include <linux/irqflags.h> to acpi/processor_idle.c

In past, processor_idle.c include irqflags.h indirectly via local.h.
But now, its inclusion was removed.

Then following build error happend.

	  CC [M]  drivers/acpi/processor_idle.o
	drivers/acpi/processor_idle.c: In function 'acpi_cstate_enter':
	drivers/acpi/processor_idle.c:275: error: implicit declaration of function 'stop_critical_timings'
	drivers/acpi/processor_idle.c:288: error: implicit declaration of function 'start_critical_timings'
	make[1]: *** [drivers/acpi/processor_idle.o] Error 1
	make: *** [drivers/acpi/processor_idle.o] Error 2


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/processor_idle.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/acpi/processor_idle.c
===================================================================
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -41,6 +41,7 @@
 #include <linux/pm_qos_params.h>
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
+#include <linux/irqflags.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines


